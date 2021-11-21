# Refer https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-daterange-aggregation.html

CURL_TIMEOUT=30
CURL_RETRY=3
CURL_RETRY_DELAY=5
ES_URL=http://127.0.0.1:9222
ALERT_URL=http://127.0.0.1:5000

gen_random() {
  cat /dev/urandom | tr -dc 'a-z0-9' | fold -w $1 | head -n 1
}

RANDOM_STR=$(gen_random 4)
PATH_JSON=/tmp/res_$RANDOM_STR.json
PATH_ENV=/tmp/res_$RANDOM_STR.env

# Get authen token
# echo -n 'elastic:changeme' | openssl base64
# ZWxhc3RpYzpjaGFuZ2VtZQ==

# Test ES API
echo "Test ES API"
curl \
  --connect-timeout $CURL_TIMEOUT \
  --retry $CURL_RETRY \
  --retry-delay $CURL_RETRY_DELAY \
  -H "Authorization: Basic ZWxhc3RpYzpjaGFuZ2VtZQ==" -XGET "$ES_URL"

# Query
echo "Query ES"
curl \
  --connect-timeout $CURL_TIMEOUT \
  --retry $CURL_RETRY \
  --retry-delay $CURL_RETRY_DELAY \
  -H "Authorization: Basic ZWxhc3RpYzpjaGFuZ2VtZQ==" -H "Content-Type: application/json" -XGET "$ES_URL/kibana_sample_data_logs/_search?size=0" -d'
{
  "query": {
    "query_string": {
          "query": "message:business-analytics"
        }
  },
   "aggs": {
       "range": {
           "date_range": {
               "field": "@timestamp",
               "time_zone": "GMT+7",
               "ranges": [
                  { "key": "current", "from": "now-30m/m", "to" : "now/m" },
                  { "key": "yesterday", "from": "now-1d-30m/m", "to" : "now-1d/m" },
                  { "key": "lastweek", "from": "now-7d-30m/m", "to" : "now-7d/m" }
              ]
          }
      }
   }
}' > $PATH_JSON

# Parse result and convert to key=value
# lastweek=X
# yesterday=Y
# current=Z
cat $PATH_JSON | jq -r ".aggregations.range.buckets | .[]" | jq -r "{key, doc_count}" | jq -r 'to_entries| .[]' | jq -r "{value}|.[]" | paste -d "=" - - > $PATH_ENV

# Assign 3 variables current, yesterday, lastweek
export $(grep -v '^#' $PATH_ENV | xargs -0)

echo ""
echo "DEBUG: lastweek=$lastweek | yesterday=$yesterday | current=$current"

function send_alert {
  title=$1
  message=$2

  curl \
    --connect-timeout $CURL_TIMEOUT \
    --retry $CURL_RETRY \
    --retry-delay $CURL_RETRY_DELAY \
    -u grafana:grafana -H "Content-Type: application/json" -XPOST "$ALERT_URL/grafana" -d"""
{
  \"title\": \"$title\",
  \"message\": \"'$message\"
}"""
}

# Check and fire alert
function check {
  ll=$1
  yy=$2
  cc=$3

  eps=0.1
  cmin=$(awk -v n=$cc -v l=$eps 'BEGIN{print(n*(1.0-l))}')
  cmax=$(awk -v n=$cc -v l=$eps 'BEGIN{print(n*(1.0+l))}')

  if awk "BEGIN {exit !($cmin > $yy)}" || awk "BEGIN {exit !($yy > $cmax)}"; then
      echo "yesterday - alert"
      send_alert "yesterday alert title" "yesterday alert message"
  else
      echo "yesterday - good"
  fi

  if awk "BEGIN {exit !($cmin > $ll)}" || awk "BEGIN {exit !($ll > $cmax)}"; then
      echo "lastweek - alert"
      send_alert "lastweek alert title" "lastweek alert message"
  else
      echo "lastweek - good"
  fi
}

check $lastweek $yesterday $current

if [ -z $RUN_TEST ]; then
  echo "DONE"
  exit 0
fi

# Test - Skip in Production
function test_check {
  ll=$1
  yy=$2
  cc=$3

  echo ""
  echo "TEST: lastweek=$ll | yesterday=$yy | current=$cc"

  check $ll $yy $cc
}

test_check 8 9 10

test_check 9.5 9 10

test_check 11 9 10

test_check 12 5 10
