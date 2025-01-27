#!/usr/bin/env bash

source SAMPLE.env # so that at least everything has a default value and the script doesn't fail
source .env        # so that things will have a correct value
source teams.sh
source config.sh

function git_sync {
    # Example:
    # git_sync dokku-01.cs.ucsb.edu proj-gauchoride-qa https://github.com/ucsb-cs156-s23/proj-gauchoride-s23-5pm-1 xy-new-feature
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    app=${2} # e.g. proj-gauchoride-qa
    url=${3} # e.g. https://github.com/ucsb-cs156-s23/proj-gauchoride-s23-5pm-1
    branch=${4} # xy-new-feature
    
    ssh $host dokku git:sync $app $url $branch
    ssh $host dokku config:set --no-restart $app SOURCE_REPO=${url}
}


function list_apps {
    # Example:
    # list_apps dokku-01.cs.ucsb.edu 
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    
    RESULT=`ssh $host dokku apps:list | grep -v "=====> My Apps"`
    echo $RESULT
}


function list_databases {
    # Example:
    # list_databases dokku-01.cs.ucsb.edu 
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    
    RESULT=`ssh $host dokku postgres:list | grep -v "=====> Postgres services"`  
    echo $RESULT
}

function matching_databases {
    # Example:
    # list_databases dokku-01.cs.ucsb.edu 
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    regex=${2} # e.g. "^jpa03-.*$"

    RESULT=`ssh $host dokku postgres:list | grep -v "=====> Postgres services" | grep $regex` 
    echo $RESULT
}



function matching_apps {
    # Example:
    # matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    regex=${2} # e.g. "^jpa03-.*$"

    RESULT=`ssh $host dokku apps:list | grep -v "=====> My Apps" | grep $regex`
    echo $RESULT

}

function unlink_and_destroy_db {
    # Example:
    # unlink_and_destroy_db dokku-05.cs.ucsb.edu proj-courses-s23-7pm-3
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    app=${2} # e.g. proj-courses-s23-7pm-3
    
    db=${2}-db 

    ssh $host dokku ps:stop $app
    ssh $host dokku postgres:unlink ${db} ${app}
    ssh $host dokku postgres:destroy ${db} --force
}

function destroy {
    # Example:
    # unlink_and_destroy_db dokku-05.cs.ucsb.edu proj-courses-s23-7pm-3
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    app=${2} # e.g. proj-courses-s23-7pm-3
    
    unlink_and_destroy_db $host $app
    ssh $host dokku apps:destroy $app --force
}

function destroy_database {
    # Example:
    # unlink_and_destroy_db dokku-05.cs.ucsb.edu proj-courses-s23-7pm-3
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    db=${2} # e.g. team03-db
    
    ssh $host dokku postgres:destroy $db --force
}


function destroy_matching_apps {
    # Example:
    # destroy_matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    regex=${2} # e.g. "^proj-courses-s23-.*$"
    
    for app in $(matching_apps $host $regex); do
        destroy $host $app
    done
}


function ps_rebuild_matching_apps {
    # Example:
    # ps_rebuild_matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    regex=${2} # e.g. "^proj-courses-s23-.*$"
    
    for app in $(matching_apps $host $regex); do
        ssh $host dokku ps:rebuild $app
    done
}


function ps_rebuild_matching_apps_all_hosts {
    # Example:
    # ps_rebuild_matching_apps_all_hosts "^jpa03-.*$"
    regex=${1} # e.g. "^proj-courses-s23-.*$"
    
    for d in `all_dokku_nums`; do
        ps_rebuild_matching_apps dokku-${d}.cs.ucsb.edu $regex
    done
}


function destroy_matching_databases {
    # Example:
    # destroy_matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    regex=${2} # e.g. "^proj-courses-s23-.*$"
    
    for db in $(matching_databases $host $regex); do
        destroy_database $host $db
    done
}

function all_dokku_nums {
    echo "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16"
}


function destroy_matching_apps_all_hosts {
    # Example:
    # destroy_all_matching_apps "^team02-.*$"
     regex=${1} # e.g. "^team02-.*$"
    
    for d in `all_dokku_nums`; do
        destroy_matching_apps dokku-${d}.cs.ucsb.edu $regex
    done
}

function destroy_matching_databases_all_hosts {
    # Example:
    # destroy_all_matching_apps "^team02-.*$"
     regex=${1} # e.g. "^team02-.*$"
    
    for d in `all_dokku_nums`; do
        destroy_matching_databases dokku-${d}.cs.ucsb.edu $regex
    done
}


function matching_apps_all_hosts {
    # Example:
    # matching_apps_all_hosts "^team02-.*$"
     regex=${1} # e.g. "^team02-.*$"
    
    ALL_HOSTS=""
    for d in `all_dokku_nums`; do
        ALL_HOSTS="${ALL_HOSTS} "`matching_apps dokku-${d}.cs.ucsb.edu $regex`
    done
    echo ${ALL_HOSTS}
}

function matching_databases_all_hosts {
    # Example:
    # matching_databases_all_hosts "^team02-.*$"
     regex=${1} # e.g. "^team02-.*$"
    
    ALL_HOSTS=""
    for d in `all_dokku_nums`; do
        ALL_HOSTS="${ALL_HOSTS} "`matching_databases dokku-${d}.cs.ucsb.edu $regex`
    done
    echo ${ALL_HOSTS}
}


function all_hosts_do {
    # Example:
    # all_hosts_do dokku apps:list
    for d in `all_dokku_nums`; do
        ssh dokku-${d}.cs.ucsb.edu $@
    done
}

function all_hosts_destroy_all_databases {
  for dd in `all_dokku_nums`; do
    for db in `list_databases dokku-$dd.cs.ucsb.edu`; do
      ssh dokku-$dd.cs.ucsb.edu dokku postgres:destroy $db --force
    done
  done
}


function destroy_all_databases {
  host=${1}
  for db in `list_databases $host`; do
    echo "Destroying $db"
    ssh $1 dokku postgres:destroy $db --force
  done
}

function url_to_host {
  url=${1}
  # remove all chars up to first . from arg, that should be the host
  host=`echo $url  | sed 's/[^\.]*\.//'`
  echo $host
} 

function url_to_app {
 url=${1}
 # remove all chars after first ., then all chars up to //
 host=`echo $url  | sed 's/\..*//' | sed 's/.*\/\///'`
 echo $host

}

function apps_create_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Creating dokku app for ${url}..."
    ssh $host "dokku apps:create $app; dokku config:set --no-restart $app PRODUCTION=true"
    ssh $host "dokku git:set ${app} keep-git-dir true"
  done
}

function https_all {
  all=$@
  for i in ${all} ; do 
    host=`url_to_host $i`
    app=`url_to_app $i`
    echo "Setting up https for ${i}..."
    ssh $host dokku "letsencrypt:set $app email phtcon@ucsb.edu;  dokku letsencrypt:enable $app"
  done
}

function db_all {
  all=$@
  for i in ${all} ; do 
    host=`url_to_host $i`
    app=`url_to_app $i`
    echo "Setting up db for ${i}..."
    ssh $host dokku postgres:create ${app}-db
    ssh $host dokku postgres:link ${app}-db ${app}
    RESULT=`ssh $host dokku config:show ${app} | grep -E "^DATABASE_URL"`
    if [ "$RESULT" == "" ]; then
        RESULT=`ssh $host dokku config:show ${app} | grep -E "^DOKKU_POSTGRES_.*_URL"`
    fi
    PASSWORD=`echo "$RESULT" |  awk -F[:@] '{print $4}'`
    DATABASE=`echo "$RESULT" |  awk -F[/] '{print $4}'`

    #IP=`ssh $host "dokku postgres:info ${app}-db" | grep "Internal ip:"`
    #IP=`echo ${IP/Internal ip: /} | tr -d '[:space:]'`
    URL="jdbc:postgresql://dokku-postgres-${app}-db:5432/${DATABASE}"
    ssh $host "dokku config:set --no-restart ${app} JDBC_DATABASE_URL=${URL} ; \
               dokku config:set --no-restart ${app} JDBC_DATABASE_USERNAME=postgres ; \
               dokku config:set --no-restart ${app} JDBC_DATABASE_PASSWORD=${PASSWORD} ; \
               dokku config:set --no-restart ${app} PRODUCTION=true "
    ssh $host dokku config:show ${app}
  done
}




function OLD_mongodb_all {
  all=$@
  for i in ${all} ; do 
    host=`url_to_host $i`
    app=`url_to_app $i`
    echo "Setting up mongodb for ${i}..."
    ssh $host dokku mongo:create ${app}-mongodb
    ssh $host dokku mongo:link ${app}-mongodb ${app}
    RESULT=`ssh $host dokku config:show ${app} | grep -E "^MONGO_URL"`
    RESULT=${RESULT/MONGO_URL: /}
    IP=`ssh $host dokku mongo:info ${app}-mongodb | grep "Internal ip:"`
    IP=`echo ${IP/Internal ip: /} | tr -d '[:space:]'`
    HOST="dokku-mongo-${app}-mongodb"
    URL=${RESULT/${HOST}/${IP}}
    ssh $host "dokku config:set --no-restart ${app} MONGODB_URI=\"${URL}\"" 
    ssh $host dokku config:show ${app}
  done
}

function mongodb_all {
  all=$@
  for i in ${all} ; do 
    host=`url_to_host $i`
    app=`url_to_app $i`
    echo "Setting up mongodb for ${i}..."
    ssh $host "dokku config:set --no-restart ${app} MONGODB_URI=\"${APP_URL_TO_MONGO_URI[$i]}\""
    ssh $host dokku config:show ${app}
  done
}

function google_oauth_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Setting up google oauth for ${url}... host=${host} app=${app}"

    GOOGLE_CLIENT_ID=${APP_URL_TO_CLIENT_ID[$url]}
    GOOGLE_CLIENT_SECRET=${APP_URL_TO_CLIENT_SECRET[$url]}

    ssh $host " \
      dokku config:set --no-restart ${app} GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID} ;\
      dokku config:set --no-restart ${app} GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET} ;\
      dokku config:show ${app} \
    "
  done
}

function github_oauth_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Setting up github oauth for ${url}... host=${host} app=${app}"

    GITHUB_CLIENT_ID=${APP_URL_TO_GITHUB_CLIENT_ID[$url]}
    GITHUB_CLIENT_SECRET=${APP_URL_TO_GITHUB_CLIENT_SECRET[$url]}

    ssh $host " \
      dokku config:set --no-restart ${app} GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} ;\
      dokku config:set --no-restart ${app} GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} ;\
      dokku config:show ${app} \
    "
  done
}


function admin_emails_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Setting up admin_emails for ${url}... host=${host} app=${app}"
    ssh $host dokku config:set --no-restart ${app} ADMIN_EMAILS=${APP_URL_TO_ADMIN_EMAILS[$url]}
  done
}

function github_logins_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    team=${APP_URL_TO_TEAM["$url"]}
    echo "Setting up github logins for ${url}... host=${host} app=${app} team=${team}"
    ssh $host dokku config:set --no-restart ${app} ADMIN_GITHUB_LOGINS=${APP_URL_TO_ADMIN_GITHUB_LOGINS[$url]}
  done
}


function ucsb_api_key_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Setting up UCSB_API_KEY for ${url}... host=${host} app=${app}"
    ssh $host dokku config:set --no-restart ${app} UCSB_API_KEY=${APP_URL_TO_UCSB_API_KEY[$url]}
  done
}

function git_sync_main_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Performing git sync on main branch for ${url}... host=${host} app=${app}"

    GITHUB_URL=${APP_URL_TO_GITHUB_URL[$url]}
    echo "GITHUB_URL=$GITHUB_URL"

    ssh $host "dokku git:set ${app} keep-git-dir true"
    ssh $host dokku git:sync ${app} ${GITHUB_URL} main
    ssh $host dokku config:set --no-restart $app SOURCE_REPO=${GITHUB_URL} 
  done
}

function set_source_repo_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Performing git sync on main branch for ${url}... host=${host} app=${app}"

    GITHUB_URL=${APP_URL_TO_GITHUB_URL["$url"]}
    echo url is $url 
    echo "GITHUB_URL=$GITHUB_URL"

    ssh $host dokku config:set --no-restart $app SOURCE_REPO=${GITHUB_URL} 
  done
}


function ps_rebuild_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Performing ps:rebuild for ${url}... host=${host} app=${app}"
    ssh $host dokku ps:rebuild ${app} 
  done
}


function full_app_create_all {
   all=$@
   echo "full_app_create_all underway for:"
   for url in $all; do 
     echo "  $url"
   done
   apps_create_all $all
   db_all $all
   google_oauth_all $all
   admin_emails_all $all
   git_sync_main_all $all
   ps_rebuild_all $all
   https_all $all
   echo "full_app_create_all done for:"
   for url in $all; do 
     echo "  $url"
   done
}

function full_app_create_all_github_logins {
   all=$@
   echo "full_app_create_all_github_logins underway for:"
   for url in $all; do 
     echo "  $url"
   done
   apps_create_all $all
   db_all $all
   github_oauth_all $all
   github_logins_all $all
   git_sync_main_all $all
   ps_rebuild_all $all
   https_all $all
   ps_rebuild_all $all
   echo "full_app_create_all_github_logins done for:"
   for url in $all; do 
     echo "  $url"
   done
}


function full_app_create_with_mongo_and_ucsb_api_key_all {
   all=$@
   echo "full_app_create_all underway for:"
   for url in $all; do 
     echo "  $url"
   done
   apps_create_all $all
   db_all $all
   mongodb_all $all
   ucsb_api_key_all $all
   google_oauth_all $all
   admin_emails_all $all
   git_sync_main_all $all
   ps_rebuild_all $all
   https_all $all
   ps_rebuild_all $all
   echo "full_app_create_all done for:"
   for url in $all; do 
     echo "  $url"
   done
}

function git_sync_main_ps_build_all {
   all=$@
   echo "git_sync_main_ps_build_all underway for:"
   for url in $all; do 
     echo "  $url"
   done
   git_sync_main_all $all
   ps_rebuild_all $all
   echo "git_sync_main_ps_build_all done for:"
   for url in $all; do 
     echo "  $url"
   done
}

function get_config_value {
  host=${1} # e.g. dokku-00.cs.ucsb.edu
  app=${2} # e.g. courses
  key=${3} # e.g. DATABASE_URL
  RESULT=`ssh $host dokku config:show ${app} | grep -E "^${key}:" | sed "s/${key}://" | awk '{$1=$1};1'`
  echo $RESULT
}

function database_url {
  host=${1} # e.g. dokku-00.cs.ucsb.edu
  app=${2} # e.g. courses
  RESULT=`get_config_value $host $app DATABASE_URL`
  if [ "$RESULT" == "" ]; then
      KEY=`ssh $host dokku config:show ${app} | grep -E "^DOKKU_POSTGRES_.*_URL" |  awk -F[:] '{print $1}'`
      RESULT=`ssh $host dokku config:show ${app} | grep -E "^DOKKU_POSTGRES_.*_URL" | sed "s/${KEY}://" | awk '{$1=$1};1'`
  fi
  echo $RESULT
}

function set_jdbc_database_url {
  host=${1} # e.g. dokku-00.cs.ucsb.edu
  app=${2} # e.g. courses
  RESULT=`database_url ${host} ${app}`

  PASSWORD=`echo "$RESULT" |  awk -F[:@] '{print $3}'`
  echo $PASSWORD
  DATABASE=`echo "$RESULT" |  awk -F[/] '{print $4}'`
  echo $DATABASE

  HOST_PORT_DATABASE=`echo "$RESULT" |  sed "s_postgres://postgres:__" | sed "s/${PASSWORD}@//"`
  
  URL="jdbc:postgresql://${HOST_PORT_DATABASE}"
  echo $URL
  ssh $host "dokku config:set --no-restart ${app} JDBC_DATABASE_URL=${URL} ; \
               dokku config:set --no-restart ${app} JDBC_DATABASE_USERNAME=postgres ; \
               dokku config:set --no-restart ${app} JDBC_DATABASE_PASSWORD=${PASSWORD} ; \
               dokku config:set --no-restart ${app} PRODUCTION=true "
  ssh $host dokku config:show ${app}
}


function set_jdbc_database_url_matching_apps {
    # Example:
    # set_jdbc_database_url_matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    regex=${2} # e.g. "^proj-courses-s23-.*$"
    
    for app in $(matching_apps $host $regex); do
        set_jdbc_database_url $host $app
    done
   
}

function set_jdbc_database_url_matching_apps_all_hosts {
    # Example:
    # set_jdbc_database_url_matching_apps_all_hosts "^team02-.*$"
    regex=${1} # e.g. "^team02-.*$"
    
    for d in `all_dokku_nums`; do
        set_jdbc_database_url_matching_apps dokku-${d}.cs.ucsb.edu $regex
    done
}

function git_set_keep_git_dir_true {
  # Example:
  # git_set_keep_git_dir_true dokku-01.cs.ucsb.edu organic
  host=${1} # e.g. dokku-00.cs.ucsb.edu
  app=${2} # e.g. courses
  ssh $host dokku git:set ${app} keep-git-dir true
}


function git_set_keep_git_dir_true_matching_apps {
    # Example:
    # git_set_keep_git_dir_true_matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    regex=${2} # e.g. "^proj-courses-s23-.*$"
    
    for app in $(matching_apps $host $regex); do
        git_set_keep_git_dir_true $host $app
    done
}

function git_set_keep_git_dir_true_matching_apps_all_hosts {
    # Example:
    # git_set_keep_git_dir_true_matching_apps_all_hosts "^jpa03-.*$"
    regex=${1} # e.g. "^proj-courses-s23-.*$"
    for d in `all_dokku_nums`; do
        git_set_keep_git_dir_true_matching_apps  dokku-${d}.cs.ucsb.edu $regex
    done
}


