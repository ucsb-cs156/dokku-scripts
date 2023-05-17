#!/bin/bash

function db {

    host=${1}
    app=${2}
    
    ssh $host dokku postgres:create ${app}-db
    ssh $host dokku postgres:link ${app}-db ${app}

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
    
    ssh $host dokku config:set --no-restart ${app} JDBC_DATABASE_URL=${URL}
    ssh $host dokku config:set --no-restart ${app} JDBC_DATABASE_USERNAME=postgres
    ssh $host dokku config:set --no-restart ${app} JDBC_DATABASE_PASSWORD=${PASSWORD}
    ssh $host dokku config:set --no-restart ${app} PRODUCTION=true
    
    ssh $host dokku config:show ${app}
}


function https {
    host=${1}
    app=${2}
    email=${3}

    ssh $host dokku config:set --no-restart ${app} PRODUCTION=true
    ssh $host dokku letsencrypt:set ${app} email ${email}
    ssh $host dokku letsencrypt:enable ${app}
    ssh $host dokku urls ${app}

}

function admin {
    host=${1}
    app=${2}

    ssh $host dokku config:set --no-restart ${app} ADMIN_EMAILS=phtcon@ucsb.edu,avishekde@ucsb.edu,vivianross@ucsb.edu,bzamoraflores@ucsb.edu,andrewpeng@ucsb.edu,rbriggs@ucsb.edu
    
}

DOKKU_INSTANCES_HAPPYCOWS="dokku-05 dokku-06 dokku-07 dokku-08"
#DOKKU_INSTANCES_HAPPYCOWS="dokku-05"


for d in $DOKKU_INSTANCES_HAPPYCOWS ; do
    echo $d
    
    ssh $d dokku apps:create proj-happycows
    db $d proj-happycows
    https $d proj-happycows phtcon@ucsb.edu
    admin $d proj-happycows

    
   ssh $d dokku apps:create proj-happycows-qa
   db $d proj-happycows-qa
   https $d proj-happycows-qa phtcon@ucsb.edu
   admin $d proj-happycows-qa


done
    

