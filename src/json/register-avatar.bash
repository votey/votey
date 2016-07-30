#!/bin/bash

. _options.bash


if  [ -z "$VOTEY_HOST" ] ; then
    echo "HOST ($VOTEY_HOST)  not set"
    exit 1
fi


function doPost() {
  >&2 echo curl  -XPOST \
                 --header "Content-Type: application/json" \
                 --data-binary @$1 $VOTEY_HOST/votey-registrar/registerAvatar?newAvatarID=cornell.west\&newPassword=mysecret

  curl           -w "\n [HTTP Response Code: %{http_code}]"  -XPOST \
                 --header "Content-Type: application/json"  \
                 --data-binary @$1 $VOTEY_HOST/votey-registrar/registerAvatar?newAvatarID=cornell.west\&newPassword=mysecret\&reloadPage=true
}

doPost 'registerAvatar1.json'
echo
echo

