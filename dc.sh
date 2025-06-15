#!/bin/bash
usage(){
    echo ""
    echo "Usage : $0 -a action -p project_name";
    echo ""
    echo "    -a action         : up | stop | down | clean | init | logs";
    echo "    -p project_name   : project_name in order to be create relevant .env file";
    echo ""
    echo "  Example : $0 -a up -p minnie"
    echo ""
    exit 1
}
history(){
    DATE="`date +%Y/%m/%d-%H:%M:%S`"
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    echo "$DATE - $0 $1" >> $DIR/history.txt
}

if [ "$1" == "-h" ] ; then 
    usage
fi

export ACTION=
export PROJECT=

if [ $# -gt 1 ]; then
    while getopts ":a:p:v:" opt; do
        case $opt in
            a) export ACTION=$OPTARG ;;
            p) export PROJECT=$OPTARG ;;
            *) usage "$1: unknown option" ;;
        esac
    done
fi

if [ -z "$ACTION" ] ; then
    echo "ERROR : Missing parameter : -a action"
    usage
fi

if [[ ! "$ACTION" =~ ^(up|stop|down|clean|init|logs|build)$ ]]; then
    echo "EROR: Unknown action!"
    usage
fi

if [ "$ACTION" != "init" ] ; then 
    if [ -z "$PROJECT" ] ; then
        echo "ERROR : Missing parameter : -p project_name"
        usage
    fi

    if [ ! -f "env/$PROJECT" ]; then
        echo "env/$PROJECT not found"
        usage
    fi

    cp env/$PROJECT .env
fi

#history "$*"

if [ "$ACTION" == "up" ] ; then 
    if [ -f "docker-compose.${PROJECT}.yml" ] ; then 
        docker compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml up -d --build
    else
        docker compose up -d --build
    fi
fi


if [ "$ACTION" == "stop" ] ; then 
    if [ -f "docker-compose.${PROJECT}.yml" ] ; then 
        docker compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml stop
    else
        docker compose stop
    fi
fi

if [ "$ACTION" == "down" ] ; then 
    if [ -f "docker-compose.${PROJECT}.yml" ] ; then 
        docker compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml down
    else
        docker compose down
    fi
fi

if [ "$ACTION" == "logs" ] ; then 
    if [ -f "docker-compose.${PROJECT}.yml" ] ; then 
        docker compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml logs -f
    else
        docker compose logs -f
    fi
fi

if [ "$ACTION" == "clean" ] ; then 
    if [ -f "docker-compose.${PROJECT}.yml" ] ; then 
        docker compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml rm -v
        docker compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml down -v
    else
        docker compose rm -v
        docker compose down -v
    fi
fi

if [ "$ACTION" == "init" ] ; then 
    echo "ES_VERSION=8.0.0" > .env
    docker compose -f create-certs.yml run --rm create_certs
fi

rm -f .env
