#!/bin/bash

LOCATION='/opt/docker-ubuntu-vnc-desktop'

while [[ $# > 1 ]]
do
    key="$1"
    case $key in
        --action)
            # add / remove / start / stop
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
  sed -i 's,^\(ENV PASSWORD \).*,\1'${PASSWORD}',' $LOCATION/Dockerfile
  docker build --no-cache=false -t dorowu/ubuntu-desktop-lxde-vnc-$NAME-$PORT $LOCATION
  if [ ! "$?" -eq 0 ]; then
    exit $?
  fi

  docker run --kernel-memory 50M -t --detach -p $PORT:6080 -c 250 dorowu/ubuntu-desktop-lxde-vnc-$NAME-$PORT
  RUN_RESULT=$?
  sed -i 's,^\(ENV PASSWORD \).*,\1'unknown',' $LOCATION/Dockerfile

  if [ ! "$RUN_RESULT" -eq 0 ]; then
    exit $?
  fi
  exit 0
elif [ "$ACTION" == 'start' ];then
  CONTAINER_ID=$(docker ps -a | grep dorowu/ubuntu-desktop-lxde-vnc-${NAME}-${PORT} | awk '{print $1}')
  docker start $CONTAINER_ID
  exit $?
elif [ "$ACTION" == 'stop' ];then
  CONTAINER_ID=$(docker ps -a | grep dorowu/ubuntu-desktop-lxde-vnc-${NAME}-${PORT} | awk '{print $1}')
  docker stop $CONTAINER_ID
  exit $?
#elif [ "$ACTION" == 'remove' ];then
  # To be implemented
fi
