# Elasticsearch Docker configuration templates

Allows running several Docker Stack based on COMPOSE_PROJECT_NAME.
One Docker stack = One elasticsearch cluster including one Kibana node for monitoring and managment

## env directory
Contains environnement files corresponding to -p parameters of dc.sh script 


## 2 helper scripts

### dc.sh - Init / Start / Stop stack

docker-compose wrapper script
1. based on -p parameter, create the .env file by copying it from env directory
2. detect extra docker-compose.<project>.yml
3. launch the Docker stack with docker compose
4. remove the .env file

Directly use docker compose will failed due to missing variables declarations.

	$ ./dc.sh -h

	Usage : ./dc.sh -a action -p project_name

	    -a action         : up | stop | down | clean | init | logs | build
	    -p project_name   : project_name in order to be create relevant .env file

	  Example : ./dc.sh -a up -p minnie

### de.sh - Interact with containers

docker exec ... wrapper script

	$ ./de.sh -h

	Usage : ./de.sh -c container_name [-u user] [-s shell]

	    -c container_name : container name
	    -u user           : user to log in (default root)
	    -s shell          : bash (default) or sh

	  Example : ./de.sh -c picsou_elastic_es01 -u elasticsearch


## elasticsearch version consideration

### for version 7 
KIBANA_ELASTIC_USER=elastic

### for version 8+ 
KIBANA_ELASTIC_USER=kibana_system

And just after first stack startup, set kibana_system user password to value of KIBANA_ELASTIC_PASSWORD (see below)


## First startup

### Optional : reset self-signed certificates

$ rm -rf certs/*
$ ./dc.sh -a init -p <env>

### Start
$ ./dc.sh -a up -p <env>

### Version 8+ only : Set kibana_system user password
use password configured in KIBANA_ELASTIC_PASSWORD variable

$ docker exec -it <env>_elastic_es01 ./bin/elasticsearch-reset-password -i -u kibana_system --url https://es01:9200







