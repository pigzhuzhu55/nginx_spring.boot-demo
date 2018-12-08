#!/bin/bash

SERVER_NAME='demo'
# jar名称
JAR_NAME='demo-0.0.1-SNAPSHOT.jar'
cd `dirname $0`
BIN_DIR=`pwd`
SERVER_PORT=8080

PIDS=`ps -ef | grep java | grep "$JAR_NAME" |awk '{print $2}'`
if [ "$1" = "status" ]; then
    if [ -n "$PIDS" ]; then
        echo "The $SERVER_NAME is running...!"
        echo "PID: $PIDS"
        exit 0
    else
        echo "The $SERVER_NAME is stopped"
        exit 0
    fi
fi

if [ -n "$PIDS" ]; then
    echo "ERROR: The $SERVER_NAME already started!"
    echo "PID: $PIDS"
    exit 1
fi

if [ -n "$SERVER_PORT" ]; then
    SERVER_PORT_COUNT=`netstat -tln | grep $SERVER_PORT | wc -l`
    if [ $SERVER_PORT_COUNT -gt 0 ]; then
        echo "ERROR: The $SERVER_NAME port $SERVER_PORT already used!"
        exit 1
    fi
fi

echo -e "Starting the $SERVER_NAME ..."

STDOUT_FILE=$BIN_DIR/stdout.log
nohup java -jar $BIN_DIR/$JAR_NAME > $STDOUT_FILE 2>&1 &
COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    if [ -n "$SERVER_PORT" ]; then
        COUNT=`netstat -an | grep $SERVER_PORT | wc -l`
    else
    	COUNT=`ps -f | grep java | grep "$BIN_DIR" | awk '{print $2}' | wc -l`
    fi
    if [ $COUNT -gt 0 ]; then
        break
    fi
done


echo "OK!"
