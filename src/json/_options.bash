#!/bin/bash
## This file should be sourced, not executed.

if [ -z "$1" ] ; then
    >&2 echo "run with either -local or -web1"
    exit 1
fi

export VOTEY_API_USER=cornell.west
export VOTEY_API_PASSWORD=mysecret

case "$1" in
    -local|local)
        export VOTEY_DB_HOST=local
        ;;
    -web1|web1)
        export VOTEY_DB_HOST=web1
        ;;
esac

case "$VOTEY_DB_HOST" in
'local')
    VOTEY_HOST=http://localhost:18080
    >&2 echo using VOTEY_HOST: $VOTEY_HOST
  ;;
 'web1')
    VOTEY_HOST=http://li257-17.members.linode.com
    >&2 echo using web VOTEY_HOST: $VOTEY_HOST
  ;;
esac

>&2 echo "_options.bash now sourcing ./curl-form-login to get server cookie."
. ./curl-form-login
