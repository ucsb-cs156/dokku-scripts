#!/bin/bash

dokku postgres:create ${1}-db
dokku postgres:link ${1}-db ${1}

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
