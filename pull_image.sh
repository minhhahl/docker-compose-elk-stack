source .env

docker pull docker.elastic.co/elasticsearch/elasticsearch:${ELK_VERSION}
docker pull docker.elastic.co/logstash/logstash:${ELK_VERSION}
docker pull docker.elastic.co/kibana/kibana:${ELK_VERSION}
docker pull docker.elastic.co/beats/filebeat:${ELK_VERSION}
docker pull docker.elastic.co/beats/metricbeat:${ELK_VERSION}
docker pull docker.elastic.co/beats/auditbeat:${ELK_VERSION}
docker pull docker.elastic.co/beats/heartbeat:${ELK_VERSION}
docker pull docker.elastic.co/beats/journalbeat:${ELK_VERSION}
docker pull docker.elastic.co/beats/elastic-agent:${ELK_VERSION}
# docker pull docker.elastic.co/beats/elastic-agent-complete:${ELK_VERSION}
docker pull docker.elastic.co/beats/packetbeat:${ELK_VERSION}
docker pull docker.elastic.co/enterprise-search/enterprise-search:${ELK_VERSION}
docker pull docker.elastic.co/apm/apm-server:${ELK_VERSION}
