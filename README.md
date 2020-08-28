# Elasticsearch Docker configuration templates

Allows running several Docker Stack based on COMPOSE_PROJECT_NAME.
One Docker stack = One elasticsearch cluster including one Kibana node for monitoring and managment

Docker stack and elasticsearch cluster configuration use .env files


## 2 helper scripts

### dc.sh 

docker-compose wrapper script
1. based on -p parameter, create the .env file by copying it from env directory
2. detect extra docker-compose.<project>.yml
3. launch the Docker stack with docker-compose
4. remove the .env file

Directly use docker-compose will failed due to missing variables declarations.

	$ ./dc.sh -h

	Usage : ./dc.sh -a action -p project_name

	    -a action         : up | stop | down | clean | create_certs
	    -p project_name   : project_name in order to be create relevant .env file

	  Example : ./dc.sh -a up -p minnie



### de.sh 

docker exec ... wrapper script

	$ ./de.sh -h

	Usage : ./de.sh -c container_name [-u user] [-s shell]

	    -c container_name : container name
	    -u user           : user to log in (default root)
	    -s shell          : bash (default) or sh

	  Example : ./de.sh -c picsou_elastic_es01 -u elasticsearch


