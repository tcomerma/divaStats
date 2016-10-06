#!/bin/bash
if [ -z "$1" ]
then
  echo "To delete logs from a day, you need to add an argument YYYY.MM.DD"
  exit
fi
curl -XDELETE "http://localhost:9200/logstash-$1/"
