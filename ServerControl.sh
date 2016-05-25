#!/bin/bash
#nohup java -jar -server -Xms512M -Xmx2048M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui&
#echo $! > ~/minecraft/run/reika_dev.pid

function start() {
# verify the server is stopped
if [ -f "./run/$1.pid" ]; then
    echo "Pid file exists.  Exiting"
    return 1
fi
echo "Starting $1"
cd $1
JAR=`ls | grep 'forge.*\.jar\|FTBServer.*\.jar'`
echo "jar: $JAR"
java -jar -server -Xms1024M -Xmx4096M -XX:MaxPermSize=256M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -jar $JAR nogui > /dev/null &
echo $! > ../run/$1.pid
}

function stop() {
echo "Stopping $1"
cd ./run
if [ ! -f "$1.pid" ]; then
    echo "Failed to read pid file for instance: $1"
    return 1
fi
cat $1.pid | xargs kill -9
if [ "$?" ==  "0" ]; then
    echo "Stopped $1"
    rm $1.pid
    return 0
else
    echo "Failed to stop: $?"
    return 1
fi
}

function clear_locks() {
echo "Clearing locks"
cd ./run
rm -rf *.pid
echo "Locks cleared"
}


if [ "$1" == "start" ]; then
    start $2
elif [ "$1" == "stop" ]; then
    stop $2
elif [ "$1" == "clear_locks" ]; then
    clear_locks
else
    echo "Please pass a valid command"
fi
