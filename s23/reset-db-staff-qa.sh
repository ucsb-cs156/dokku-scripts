#!/bin/bash


function unlink_and_destroy_db {
    host=${1}
    app=${2}
    db=${2}-db

    ssh $host dokku ps:stop $app
    ssh $host dokku postgres:unlink ${db} ${app}
    ssh $host dokku postgres:destroy ${db}
}

function db {

    host=${1}
    app=${2}
    
    ssh $host dokku postgres:create ${app}-db
    ssh $host dokku postgres:link ${app}-db ${app}

    RESULT=`ssh $host dokku config:show ${app} | egrep "^DATABASE_URL"`

    if [ "$RESULT" = "" ] ; then
	RESULT=`ssh $host dokku config:show ${app} | grep "POSTGRES"`;
    fi

    PASSWORD=`echo "$RESULT" |  awk -F[:@] '{print $4}'`
    DATABASE=`echo "$RESULT" |  awk -F[/] '{print $4}'`

    echo "RESULT=$RESULT"
    echo "PASSWORD=$PASSWORD"
    echo "DATABASE=$DATABASE"

    IP=`ssh $host dokku postgres:info ${app}-db | grep "Internal ip:"`
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


function team2dokku {
    team=${1}
    declare -A T2D
    T2D[5pm-1]=01
    T2D[5pm-2]=02
    T2D[5pm-3]=03
    T2D[5pm-4]=04
    T2D[6pm-1]=05
    T2D[6pm-2]=06
    T2D[6pm-3]=07
    T2D[6pm-4]=08
    T2D[7pm-1]=09
    T2D[7pm-2]=10
    T2D[7pm-3]=11
    T2D[7pm-4]=12
    echo ${T2D[$team]}
}

function team2proj {
    team=${1}
    declare -A T2P
    T2P[5pm-1]=gauchoride
    T2P[5pm-2]=gauchoride
    T2P[5pm-3]=gauchoride
    T2P[5pm-4]=gauchoride
    T2P[6pm-1]=happycows
    T2P[6pm-2]=happycows
    T2P[6pm-3]=happycows
    T2P[6pm-4]=happycows
    T2P[7pm-1]=courses
    T2P[7pm-2]=courses
    T2P[7pm-3]=courses
    T2P[7pm-4]=courses
    echo ${T2P[$team]}
}

function reset_db_staff_qa() {
    team=${1}
    branch=main
    suffix="-staff-qa"

    proj=`team2proj $team`
    dokku=`team2dokku $team`
    github_url="https://github.com/ucsb-cs156-s23/proj-${proj}${suffix}-s23-${team}.git"
    dokku_url=https://proj-${proj}${suffix}.dokku-${dokku}.cs.ucsb.edu

    unlink_and_destroy_db dokku-${dokku} proj-${proj}${suffix}
    db dokku-${dokku} proj-${proj}${suffix}
    echo "restarting app..."
    ssh $host dokku ps:start ${proj}${suffix}
    
    echo For team ${team}: Database reset for ${dokku_url}
}


if [ "$#" -ne 1 ]; then
    echo "Error: exactly one argument expected"
    echo ""
    echo "Usage: ${0} team "
    echo ""
    echo "Example:"
    echo "  ${0} 5pm-2"
    exit 1
fi


reset_db_staff_qa ${1}





    

