#!/bin/bash
elasticdump --input=/home/kibana/kibana.json --output=http://localhost:9200/.kibana --type=data
