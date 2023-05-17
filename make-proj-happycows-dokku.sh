#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Error: exactly two arguments expected"
    echo ""
    echo "Usage: ${0} app-name email"
    echo ""
    echo "Example:"
    echo "  ${0} jpa03-cgaucho cgaucho@ucsb.edu"
    echo ""
    exit 1
fi

dokku apps:create ${1}
~/dokku-scripts/db.sh ${1}
~/dokku-scripts/https.sh ${1} ${2}
~/dokku-scripts/admin.sh ${1}
~/dokku-scripts/google-oauth.sh ${1}
