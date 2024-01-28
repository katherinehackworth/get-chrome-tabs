#!/bin/bash

port=9222
socket=chrome_devtools_remote
file=tabs.json

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
  p) port=$OPTARG ;;
  s) socket=$OPTARG ;;
  f) file=$OPTARG ;;
  \?) echo "invalid argument detected" ;;
  esac
done

echo "Using port $port and socket $socket"
adb -d forward tcp:$port localabstract:$socket
sleep 2
url="http://localhost:$port/json/list"
echo "fetching $url"
jsonString=curl $url
if test -z "$jsonString"; then
  echo "Unable to download tabs from device! Please check the device connection!"
  exit 1
else
  echo $jsonString >$file
fi

./json-to-csv.py $file
