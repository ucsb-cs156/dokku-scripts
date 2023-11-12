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

dokku config:set --no-restart ${1} PRODUCTION=true
dokku letsencrypt:set ${1} email ${2}
dokku letsencrypt:enable ${1}
dokku urls ${1}
