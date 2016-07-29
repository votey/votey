#!/bin/bash
if [ -z "$1" ] ; then
    >&2 echo "run with either -local or -web1"
    exit 1
fi

case "$1" in
    -local|local)
        export ANARCHIA_DB_HOST=local
        ;;
    -web1|web1)
        export ANARCHIA_DB_HOST=web1
        ;;
esac

>&2 echo set-host: $ANARCHIA_DB_HOST