#!/bin/bash
 
MASTER=$1
 
HOST=$(hostname)
 
if [ "$HOST" == "$MASTER" ]; then
 
    $SPARK_ROOT/sbin/start-master.sh
 
fi
 
$SPARK_ROOT/sbin/start-slave.sh spark://$MASTER:7077 
 
tail -f /dev/null #wait forever
