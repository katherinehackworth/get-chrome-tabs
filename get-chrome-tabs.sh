#!/bin/bash

PORT=9222
SOCKET=chrome_devtools_remote
FILE=tabs.json

while getopts 'hf:p:s:' opt; do
  case $opt in
  h)
    cat <<EOF
A tool to transfer tabs from your android phone to your computer using adb.
Usage: get-chrome-tabs.sh [options]

  Options:
  -h    Print this help message
  -f    The relative filepath to write
  -p    The port to forward requests with using adb
  -s    The socket to forward requests with using adb
EOF
    exit
    ;;
  p) PORT=$OPTARG ;;
  s) SOCKET=$OPTARG ;;
  f) FILE=$OPTARG ;;
  \?) echo "invalid argument detected" ;;
  esac
done

echo "Using port $PORT and socket $SOCKET"
adb -d forward tcp:$PORT localabstract:$SOCKET
sleep 2
url="http://localhost:$PORT/json/list"
echo "fetching $url"
jsonString=curl $url
if test -z "$jsonString"; then
  echo "Unable to download tabs from device! Please check the device connection!"
  exit 1
else
  echo $jsonString >$file
fi
