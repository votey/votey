#!/bin/bash

if [ -z "$ANARCHIA_BASIC_AUTH" ] || [ -z "$ANARCHIA_HOST" ] ; then
    echo "HOST ($ANARCHIA_HOST) or AUTH ($ANARCHIA_BASIC_AUTH) not set"
    exit 1
fi


function doPost() {
  >&2 echo curl  -u $ANARCHIA_BASIC_AUTH -XPOST --header "Content-Type: application/json"  --data-binary @$1 $ANARCHIA_HOST/votey/voterToken
  curl       -u $ANARCHIA_BASIC_AUTH -XPOST --header "Content-Type: application/json"  --data-binary @$1 $ANARCHIA_HOST/votey/voterToken
}

doPost 'voterToken1.json'
echo
echo
doPost 'voterToken2.json'
echo
echo

