#!/bin/bash
usage(){
    echo ""
    echo "Usage : $0 -a action -e env_file";
    echo ""
    echo "    -a action     : up | down | create_certs";
    echo "    -e env_file   : envirronment file to be rename in .env";
    echo ""
    echo "  Example : $0 -a up -e minnie"
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
export ENV_FILE=

if [ $# -gt 1 ]; then
    while getopts ":a:e:" opt; do
        case $opt in
            a) export ACTION=$OPTARG ;;
            e) export ENV_FILE=$OPTARG ;;
            *) usage "$1: unknown option" ;;
        esac
    done
fi

if [ -z "$ACTION" ] ; then
    echo "ERROR : Missing parameter : -a action"
    usage
fi

if [ -z "$ENV_FILE" ] ; then
    echo "ERROR : Missing parameter : -e env_file"
    usage
fi

if [ ! -f "env/$ENV_FILE" ]; then
    echo "env/$ENV_FILE not found"
    usage
fi

cp env/$ENV_FILE .env

history "$*"

if [ "$ACTION" == "up" ] ; then 
    docker-compose up -d --build
    exit 0
fi

if [ "$ACTION" == "down" ] ; then 
    docker-compose down
    exit 0
fi

if [ "$ACTION" == "create_certs" ] ; then 
    docker-compose -f create-certs.yml run --rm create_certs
    exit 0
fi
