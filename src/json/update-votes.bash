#!/bin/bash


if [ -z "$ANARCHIA_BASIC_AUTH" ] || [ -z "$ANARCHIA_HOST" ] ; then
    echo "HOST ($ANARCHIA_HOST) or AUTH ($ANARCHIA_BASIC_AUTH) not set"
    exit 1
fi

function doPut() {
  ##Use -vv or --trace filename.txt
  >&2 echo curl  -u "$ANARCHIA_BASIC_AUTH"  -X PUT --header "Content-Type: application/json"  --data-binary @$1 "$ANARCHIA_HOST/votey/votes"
  curl       -u "$ANARCHIA_BASIC_AUTH"  -X PUT --header "Content-Type: application/json"  --data-binary @$1 "$ANARCHIA_HOST/votey/votes"
}

doPut 'vote1update.json'
echo