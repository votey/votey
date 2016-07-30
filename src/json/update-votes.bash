#!/bin/bash


if [ -z "$VOTEY_HOST" ] ; then
    echo "HOST ($VOTEY_HOST) not set"
    exit 1
fi

function doPut() {
  ##Use -vv or --trace filename.txt
  >&2 echo curl -b ./cookies -c ./cookies \
          -X PUT \
          --header "Content-Type: application/json"  \
          --data-binary @$1 "$VOTEY_HOST/votey/votes"

  curl -b ./cookies -c ./cookies \
          -X PUT \
          --header "Content-Type: application/json"  \
          --data-binary @$1 "$VOTEY_HOST/votey/votes"
}

doPut 'vote1update.json'
echo
echo
