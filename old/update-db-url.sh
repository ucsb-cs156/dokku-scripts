function usage() {
    echo "Usage: ${0} appname"
    echo ""
    echo "Example:"
    echo "  ${0} organic"
    echo "  ${0} organic-qa"
    echo ""
    echo "Notes:"
    echo "  This assumes that there is already a database created"
    echo "  that has the name appname-db, that it is linked with"
    echo "  the application, and that only config variables need to"
    echo "  be updated"
}

if [ "$1" = "-h" ]; then
    usage
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Error: exactly one argument expected; received $#"
    echo ""
    usage
    exit 1
fi

RESULT=`dokku config:show ${1} | egrep "^DATABASE_URL"`
PASSWORD=`echo "$RESULT" |  awk -F[:@] '{print $4}'`
DATABASE=`echo "$RESULT" |  awk -F[/] '{print $4}'`

echo "RESULT=$RESULT"
echo "PASSWORD=$PASSWORD"
echo "DATABASE=$DATABASE"

IP=`dokku postgres:info ${1}-db | grep "Internal ip:"`
IP=`echo ${IP/Internal ip: /} | tr -d '[:space:]'`
URL="jdbc:postgresql://${IP}:5432/${DATABASE}"

echo "IP=$IP"
echo "URL=$URL"

dokku config:set --no-restart ${1} JDBC_DATABASE_URL=${URL}
dokku config:set --no-restart ${1} JDBC_DATABASE_USERNAME=postgres
dokku config:set --no-restart ${1} JDBC_DATABASE_PASSWORD=${PASSWORD}
dokku config:set --no-restart ${1} PRODUCTION=true

dokku config:show ${1}
