# docker-compose-elk-stack

## Required

- docker
- docker-compose (supported version 3.9)

## Applications

- Elastic Search (standalone or cluster)
- Logstash
- Kibana
- Grafana
- Postgres (data base for grafana)
- Cerebro
- Filebeat (collect docker logs and send to logstash)

We could run multi instances for:

- Logstash
- Kibana
- Grafana

## Run

```bash
docker-compose up -d
```

## Run ES cluster with 3 nodes

We are using ES standalone for quick demo. The current setup also supports to run ES cluster with 3 nodes. Update these files to use cluster model.

- docker-compose.yaml
- res/kibana/kibana.yml
- res/logstash/logstash.conf
- res/logstash/logstash.yml

## Change the version of ELK stack

The default version is defined in `.env` as below

```bash
ELK_VERSION=7.9.0
```

update it to change to other version.

## Access UI

- Kibana: [http://localhost:5601](http://localhost:5601)
  - Username: `elastic`
  - Password: `changeme`
- Grafana: [http://localhost:3000](http://localhost:3000)
  - Username: `admin`
  - Password: `admin`
- Cerebro: [http://localhost:9000](http://localhost:9000)
  - ES URL: `http://es01:9200`
  - Username: `elastic`
  - Password: `changeme`
