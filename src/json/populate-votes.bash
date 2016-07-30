#!/bin/bash

if  [ -z "$VOTEY_HOST" ] ; then
    echo "HOST ($VOTEY_HOST) not set"
    exit 1
fi


function doPost() {
  >&2 echo curl -b ./cookies -c ./cookies \
       -XPOST \
       --header "Content-Type: application/json"  \
       --data-binary @$1 $VOTEY_HOST/votey/votes

  curl -b ./cookies -c ./cookies \
      -XPOST \
      --header "Content-Type: application/json" \
      --data-binary @$1 $VOTEY_HOST/votey/votes
}

doPost 'vote1.json'
echo
echo
doPost 'vote2.json'
echo
echo
doPost 'vote3.json'
echo
echo

