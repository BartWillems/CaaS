#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "You should run this script as root"
    exit 1
fi

LOCATION='/opt/docker-ubuntu-vnc-desktop'

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

# Exit when these vars are empty
[ ! -z "$NAME" ] || exit 1
[ ! -z "$PORT" ] || exit 1

if [ "$ACTION" == 'add' ];then
  [ ! -z "$PASSWORD" ] || exit 1
  sed -i 's,^\(PASS=\).*,\1'${PASSWORD}',' $LOCATION/startup.sh
  docker build --rm -t dorowu/ubuntu-desktop-lxde-vnc-$NAME-$PORT docker-ubuntu-vnc-desktop
  if [ ! "$?" -eq 0 ]; then
    exit $?
  fi

  docker run -i -t -p $PORT:6080 dorowu/ubuntu-desktop-lxde-vnc-$NAME-$PORT
  if [ ! "$?" -eq 0 ]; then
    exit $?
  fi
  sed -i 's,^\(PASS=\).*,\1'_EMPTY_',' $LOCATION/startup.sh
  exit 0
elif [ "$ACTION" == 'remove' ];then
  # To be implemented
fi
