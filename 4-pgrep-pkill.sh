#!/bin/sh

SCRIPT_PATH=$(readlink -f $0)
BASE_DIR=$(dirname "$SCRIPT_PATH")
PORT='8888'

echo 'stop monitor_sp.sh'
pgrep  -f "/bin/sh $BASE_DIR/monitor_sp.sh"
pkill  -f "/bin/sh $BASE_DIR/monitor_sp.sh"
echo 'stop monitor_sp.sh...done'

echo 'stop paas'
pgrep  -f "SCREEN -U -dmSL paas $BASE_DIR/bin/linux/node"
pkill  -f "SCREEN -U -dmSL paas $BASE_DIR/bin/linux/node"
sleep 3
echo 'stop paas...done'

echo '----------------------'

echo 'start paas'
cd $BASE_DIR
/usr/bin/screen -U -dmSL paas $BASE_DIR/bin/linux/node $BASE_DIR/start.js $PORT
sleep 1
pgrep  -f "SCREEN -U -dmSL paas $BASE_DIR/bin/linux/node"
echo 'start paas...done'

echo 'start monitor_sp.sh'
$BASE_DIR/monitor_sp.sh  &
sleep 1
pgrep  -f "/bin/sh $BASE_DIR/monitor_sp.sh"
echo 'start monitor_sp.sh...done'
