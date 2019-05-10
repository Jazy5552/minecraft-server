#!/bin/sh
# This script facilitates sending commands to
# the server within the container.
#  USAGE: ./server-cli.sh CONTAINERID COMMANDS

containerid=$1
shift
docker exec $containerid /bin/sh -c "echo $* > /minecraft.fifo"

