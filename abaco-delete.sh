#!/bin/bash

THIS=$(basename $0)
THIS=${THIS%.sh}
THIS=${THIS//[-]/ }

HELP="
Usage: ${THIS} [OPTION]... [ACTORID]

Deletes the actor corresponding to the given actor ID

Options:
  -h	show help message
  -z    api access token
  -v	verbose output
"

#function usage() { echo "$0 usage:" && grep " .)\ #" $0; exit 0; }
function usage() { echo "$HELP"; exit 0;}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$DIR/common.sh"
tok=

while getopts ":hvz:" o; do
    case "${o}" in
        z) # custom token
            tok=${OPTARG}
            ;;
        v) # verbose
            verbose="true"
            ;;
        h | *) # print help text
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ ! -z "$tok" ]; then TOKEN=$tok; fi

actor="$1"
if [ -z "$actor" ]; then
    echo "Please specify actor ID at end of command"
    usage
fi

curlCommand="curl -sk -H \"Authorization: Bearer $TOKEN\" -X DELETE '$BASE_URL/actors/v2/${actor}'"

function filter() {
    eval $@ | jq -r '.message'
}

if [[ "$verbose" == "true" ]]; then
    eval $curlCommand
else
    filter $curlCommand
fi
