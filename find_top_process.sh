#!/bin/bash

SECS=10
UNIT_TIME=1

STEPS=$(( $SECS / $UNIT_TIME ))

echo Watching cpu usage ...;

for(( i=0; i<STEPS; i++))
do
    ps -eocomm,pcpu | egrep -v '(0.0)|(%CPU)' >> /tmp/cpu_usage.$$
    sleep $UNIT_TIME
done
echo
echo cpu eaters :
cat /tmp/cpu_usage.$$ | \
awk '
{process[$1]+=$2;}
END{
    for(i in process)
    {
        printf("%-20s %s\n", i, process[i] );
    }
}' | sort -nrk 2 | head

rm /tmp/cpu_usage.$$