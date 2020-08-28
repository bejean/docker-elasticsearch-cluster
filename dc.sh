#!/bin/bash
usage(){
    echo ""
    echo "Usage : $0 -a action -p project_name";
    echo ""
    echo "    -a action         : up | stop | down | clean | create_certs";
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
    while getopts ":a:p:" opt; do
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

if [[ ! "$ACTION" =~ ^(up|stop|down|clean|create_certs)$ ]]; then
    echo "EROR: Unknown action!"
    usage
fi

if [ -z "$PROJECT" ] ; then
    echo "ERROR : Missing parameter : -p project_name"
    usage
fi

if [ ! -f "env/$PROJECT" ]; then
    echo "env/$PROJECT not found"
    usage
fi

cp env/$PROJECT .env

history "$*"

if [ "$ACTION" == "up" ] ; then 
    if [ -f "docker-compose.${PROJECT}.yml" ] ; then 
        docker-compose -f docker-compose.yml -f docker-compose.${PROJECT}.yml up -d --build
    else
        docker-compose up -d --build
    fi
fi

if [ "$ACTION" == "stop" ] ; then 
    docker-compose stop
fi

if [ "$ACTION" == "down" ] ; then 
    docker-compose down
fi

if [ "$ACTION" == "clean" ] ; then 
    docker-compose rm -v
    docker-compose down
fi

if [ "$ACTION" == "create_certs" ] ; then 
    docker-compose -f create-certs.yml run --rm create_certs
fi

rm .env
