#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Error: exactly one argument expected"
    echo ""
    echo "Usage: ${0} app-name"
    echo ""
    echo "Example:"
    echo "  ${0} jpa03-cgaucho"
    echo ""
    exit 1
fi


read -p 'Enter Google Client Id: ' GOOGLE_CLIENT_ID
read -p 'Enter Google Client Secret: ' GOOGLE_CLIENT_SECRET


dokku config:set --no-restart ${1} GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
dokku config:set --no-restart ${1} GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
dokku config:show ${1}
