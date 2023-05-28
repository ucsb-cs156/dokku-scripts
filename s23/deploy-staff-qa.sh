#!/bin/bash


function deploy {
    host=${1}
    app=${2}
    url=${3}
    branch=${4}

    ssh $host dokku git:sync $app $url $branch
    ssh $host dokku ps:rebuild $app
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

if [ "$#" -ne 2 ]; then
    echo "Error: exactly two arguments expected"
    echo ""
    echo "Usage: ${0} team branch"
    echo ""
    echo "Example:"
    echo "  ${0} 5pm-2 xy-add-new-thing"
    exit 1
fi


team=${1}
branch=${2}

proj=`team2proj $team`
dokku=`team2dokku $team`
echo deploy dokku-${dokku} proj-${proj}-staff-qa    https://github.com/ucsb-cs156-s23/proj-${proj}-s23-${team}.git ${branch}
deploy dokku-${dokku} proj-${proj}-staff-qa    https://github.com/ucsb-cs156-s23/proj-${proj}-s23-${team}.git ${branch}
echo For team ${team}: branch ${branch} deployed at https://proj-${proj}-staff-qa.dokku-${dokku}.cs.ucsb.edu



    

