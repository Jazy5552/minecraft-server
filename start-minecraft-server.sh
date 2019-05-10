#!/bin/sh
mkfifo /minecraft.fifo
mpid=""

# Trap will ensure that the server is saved when
# docker stop is called
graceful_exit() {
  echo "Attempting to stop gracefully..."
  echo "stop" > /minecraft.fifo
  trap - 2 15 16
  wait $mpid
}
trap graceful_exit 2 15 16

cd /minecraft
tail -f /minecraft.fifo | java -Xmx2048M -Xms2048M -jar /minecraft/spigot*.jar nogui &
mpid=$!
echo "Waiting"
wait $mpid
echo "Passed wait"

