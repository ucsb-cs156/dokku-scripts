#!/bin/bash

prefix="https://ucsb-cs156/proj-"

function usage() {
    echo "Usage: ${0} projectName deployment branch"
    echo ""
    echo "Example:"
    echo "  ${0} organic organic main"
    echo "  ${0} organic organic-qa pc-add-feature"
    echo ""
    echo "Notes:"
    echo "  The project should be hosted at ${prefix}projectName"
    echo "  This will sync with the specified branch and then rebuild the project"
}

if [ "$1" = "-h" ]; then
    usage
    exit 1
fi

if [ "$#" -ne 3 ]; then
    echo "Error: exactly one argument expected; received $#"
    echo ""
    usage
    exit 1
fi

dokku git:sync ${2} https://github.com/ucsb-cs156/proj-${1} ${3}
dokku ps:rebuild ${2}
