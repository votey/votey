#!/bin/bash

if [ -z "$VOTEY_HOST" ] ; then
    echo "HOST ($VOTEY_HOST) not set"
    exit 1
fi


function doPost() {
  >&2 echo curl  -b ./cookies -c ./cookies \
                 -XPOST --header "Content-Type: application/json"  \
                 --data-binary @$1 $VOTEY_HOST/votey/community

  curl           -b ./cookies -c ./cookies \
                 -XPOST --header "Content-Type: application/json"  \
                 --data-binary @$1 $VOTEY_HOST/votey/community
}

doPost 'community1.json'
echo
echo
doPost 'community2.json'
echo
echo

