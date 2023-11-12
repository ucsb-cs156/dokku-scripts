#!/bin/bash

prefix="https://ucsb-cs156/proj-"

function usage() {
    echo "Usage: ${0} projectName"
    echo ""
    echo "Example:"
    echo "  ${0} organic"
    echo ""
    echo "Notes:"
    echo "  The project should be hosted at ${prefix}projectName"
    echo "  This will sync with the main branch and then rebuild the project"
}

if [ "$1"=="-h"]; then
    usage
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Error: exactly one argument expected"
    echo ""
    exit 1
fi

dokku git:sync ${1} https://github.com/ucsb-cs156/proj-${1} main
dokku ps:rebuild ${1}
