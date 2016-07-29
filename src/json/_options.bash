case "$ANARCHIA_DB_HOST" in
'local')
    ANARCHIA_HOST=http://localhost:18080
    ANARCHIA_BASIC_AUTH=laramie:ecotel33
    >&2 echo using ANARCHIA_HOST: $ANARCHIA_HOST
  ;;
 'web1')
    ANARCHIA_HOST=http://li257-17.members.linode.com
    ANARCHIA_BASIC_AUTH=laramie:ecotel33
    >&2 echo using web ANARCHIA_HOST: $ANARCHIA_HOST
  ;;
esac
