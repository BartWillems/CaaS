#!/bin/bash 

if [ "$EUID" -ne 0 ]
    then echo "You should run this script as root"
    exit 1
fi

while [[ $# > 1 ]]
do
    key="$1"
    case $key in
        --action)
            # add / remove
            ACTION="$2"
        ;;
        --containerName)
            NAME="$2"
        ;;
        --containerPort)
            PORT="$2"
        ;;
        --containerPassword)
            PASSWORD="$2"
        ;;
        *)
        ;;
    esac
    shift
done
