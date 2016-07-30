#!/bin/bash

if  [ -z "$VOTEY_HOST" ] ; then
    echo "HOST ($VOTEY_HOST) "
    exit 1
fi


function doPost() {
  >&2 echo curl -b ./cookies -c ./cookies \
          -XPOST \
          --header "Content-Type: application/json"  \
          --data-binary @$1 $VOTEY_HOST/votey/voterToken

  curl    -b ./cookies -c ./cookies \
          -XPOST \
          --header "Content-Type: application/json"  \
          --data-binary @$1 $VOTEY_HOST/votey/voterToken
}

doPost 'voterToken1.json'
echo
echo
doPost 'voterToken2.json'
echo
echo

