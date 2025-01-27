#!/bin/bash

source .env
source teams.sh

declare -A TEAM_TO_DOKKU
declare -A DOKKU_TO_TEAM

for ((i = ((${#TEAMS[@]} - 1)); i >= 0; i--)); do
    team=${TEAMS["$i"]}
    dokku=${DOKKUS["$i"]}
    TEAM_TO_DOKKU[$team]=$dokku
    DOKKU_TO_TEAM[$dokku]=$team
done

declare -A TEAM_TO_APP

for t in ${COURSES_TEAMS}; do TEAM_TO_APP[$t]=courses; done
for t in ${HAPPYCOWS_TEAMS}; do TEAM_TO_APP[$t]=happycows; done
for t in ${ORGANIC_TEAMS}; do TEAM_TO_APP[$t]=organic; done
for t in ${GAUCHORIDE_TEAMS}; do TEAM_TO_APP[$t]=gauchoride; done

COURSES_DOKKUS=""
HAPPYCOWS_DOKKUS=""
ORGANIC_DOKKUS=""
GAUCHORIDE_DOKKUS=""

for team in ${COURSES_TEAMS}; do COURSES_DOKKUS="${COURSES_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done
for team in ${HAPPYCOWS_TEAMS}; do HAPPYCOWS_DOKKUS="${HAPPYCOWS_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done
for team in ${ORGANIC_TEAMS}; do ORGANIC_DOKKUS="${ORGANIC_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done
for team in ${GAUCHORIDE_TEAMS}; do GAUCHORIDE_DOKKUS="${GAUCHORIDE_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done


# Set up APP_URL_TO_* mappings

declare -A APP_URL_TO_CLIENT_ID
declare -A APP_URL_TO_CLIENT_SECRET
declare -A APP_URL_TO_UCSB_API_KEY
declare -A APP_URL_TO_GITHUB_URL
declare -A APP_URL_TO_ADMIN_EMAILS
declare -A APP_URL_TO_ADMIN_GITHUB_LOGINS
declare -A APP_URL_TO_TEAM

echo "courses..."

for d in ${COURSES_DOKKUS}; do
    echo "setting up courses variables for dokku-$d"

    prod_url="https://courses.dokku-${d}.cs.ucsb.edu"
    qa_url="https://courses-qa.dokku-${d}.cs.ucsb.edu"
    team=${DOKKU_TO_TEAM[$d]}
    for url in $prod_url $qa_url ; do
        APP_URL_TO_TEAM[$url]=${team}
        APP_URL_TO_CLIENT_ID[$url]=${PROJ_TO_CLIENT_ID[courses]}
        APP_URL_TO_CLIENT_SECRET[$url]=${PROJ_TO_CLIENT_SECRET[courses]}
        APP_URL_TO_UCSB_API_KEY[$url]=${PROJ_TO_UCSB_API_KEY[courses]}
        APP_URL_TO_GITHUB_URL["$url"]=https://github.com/ucsb-cs156-${QXX}/proj-courses-${team}
        APP_URL_TO_MONGO_URI[$url]=${TEAM_TO_MONGO_URI[$team]}
    done
    APP_URL_TO_ADMIN_EMAILS[$prod_url]="${ALL_STAFF_EMAILS},${TEAM_TO_ADMIN_EMAILS[$team]}"
    APP_URL_TO_ADMIN_EMAILS[$qa_url]="${ALL_STAFF_EMAILS},${ALL_STUDENT_EMAILS}"
done

echo the one we want: ${APP_URL_TO_GITHUB_URL["https://courses.dokku-01.cs.ucsb.edu"]}


echo "happycows..."

for d in ${HAPPYCOWS_DOKKUS}; do
    echo "setting up happycows variables for dokku-$d"
    prod_url="https://happycows.dokku-${d}.cs.ucsb.edu"
    qa_url="https://happycows-qa.dokku-${d}.cs.ucsb.edu"
    team=${DOKKU_TO_TEAM[$d]}
    for url in $prod_url $qa_url ; do
        APP_URL_TO_TEAM["$url"]=${team}
        APP_URL_TO_CLIENT_ID["$url"]=${PROJ_TO_CLIENT_ID[happycows]}
        APP_URL_TO_CLIENT_SECRET["$url"]=${PROJ_TO_CLIENT_SECRET[happycows]}
        APP_URL_TO_UCSB_API_KEY["$url"]=${PROJ_TO_UCSB_API_KEY[happycows]}
        APP_URL_TO_GITHUB_URL["$url"]=https://github.com/ucsb-cs156-${QXX}/proj-happycows-${team}
        APP_URL_TO_MONGO_URI["$url"]=not-needed-for-this-app
    done
    APP_URL_TO_ADMIN_EMAILS["$prod_url"]="${ALL_STAFF_EMAILS},${TEAM_TO_ADMIN_EMAILS[$team]}"
    APP_URL_TO_ADMIN_EMAILS["$qa_url"]="${ALL_STAFF_EMAILS},${ALL_STUDENT_EMAILS}"
done


echo "organic..."

for d in ${ORGANIC_DOKKUS}; do
    echo "setting up organic variables for dokku-$d"
    prod_url="https://organic.dokku-${d}.cs.ucsb.edu"
    qa_url="https://organic-qa.dokku-${d}.cs.ucsb.edu"
    team=${DOKKU_TO_TEAM[$d]}
    for url in $prod_url $qa_url ; do
        APP_URL_TO_TEAM[$url]=${team}
        APP_URL_TO_CLIENT_ID[$url]=${PROJ_TO_CLIENT_ID[organic]}
        APP_URL_TO_CLIENT_SECRET[$url]=${PROJ_TO_CLIENT_SECRET[organic]}
        APP_URL_TO_UCSB_API_KEY[$url]=${PROJ_TO_UCSB_API_KEY[organic]}
        APP_URL_TO_GITHUB_URL["$url"]=https://github.com/ucsb-cs156-${QXX}/proj-organic-${team}
        APP_URL_TO_MONGO_URI[$url]=not-needed-for-this-app
    done
    APP_URL_TO_ADMIN_GITHUB_LOGINS[$prod_url]="${ALL_STAFF_GITHUBS},${TEAM_TO_GITHUB_LOGINS[$team]}"
    APP_URL_TO_ADMIN_GITHUB_LOGINS[$qa_url]="${ALL_STAFF_GITHUBS},${ALL_STUDENT_GITHUBS}"
done

echo "gauchoride..."

for d in ${GAUCHORIDE_DOKKUS}; do
    echo "setting up gauchoride variables for dokku-$d"
    prod_url="https://gauchoride.dokku-${d}.cs.ucsb.edu"
    qa_url="https://gauchoride-qa.dokku-${d}.cs.ucsb.edu"
    team=${DOKKU_TO_TEAM[$d]}
    for url in $prod_url $qa_url ; do
        APP_URL_TO_TEAM[$url]=${team}
        APP_URL_TO_CLIENT_ID[$url]=${PROJ_TO_CLIENT_ID[gauchoride]}
        APP_URL_TO_CLIENT_SECRET[$url]=${PROJ_TO_CLIENT_SECRET[gauchoride]}
        APP_URL_TO_UCSB_API_KEY[$url]=${PROJ_TO_UCSB_API_KEY[gauchoride]}
        APP_URL_TO_GITHUB_URL[$url]=https://github.com/ucsb-cs156-${QXX}/proj-gauchoride-${team}
        APP_URL_TO_MONGO_URI[$url]=not-needed-for-this-app
    done
    APP_URL_TO_ADMIN_EMAILS[$prod_url]="${ALL_STAFF_EMAILS},${TEAM_TO_ADMIN_EMAILS[$team]}"
    APP_URL_TO_ADMIN_EMAILS[$qa_url]="${ALL_STAFF_EMAILS},${ALL_STUDENT_EMAILS}"
done