#!/bin/zsh

help() {
  echo "Usage: $0 [-h] <type> <port?"
  echo "  -h      displays usage help"
  echo "  -p      editor's HTTP port, default: 9001"
  echo "  <type>  specification type: open, async"
}

fail() {
  echo "FAILURE: $1"
  exit 1
}

err() {
  fail "$1, use -h for help"
}

launch() {
  STATUS=$(docker inspect -f '{{.State.Status}}' "$1" 2>/dev/null)
  if [ -z "$STATUS" ] || [ "$STATUS" != "running" ]; then 
    echo "Starting container [$1]..."
    eval $2
    sleep 3 
  fi
}

PORT=9001

while getopts ":hp:" opt; do
  case $opt in
    h)
      help
      exit 1
      ;;
    p)
      PORT=$OPTARG
      ;;    
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

SPEC=${@:$OPTIND:1}
if [[ -z "$SPEC" ]]; then
  err "Specification type parameter required"
fi

if [[ "$SPEC" == "async" ]]; then
  NAME="asyncapi-editor"
  IMAGE="asyncapi/studio"
  CPORT=80

elif [[ "$SPEC" == "open" ]]; then
  NAME="openapi-editor"
  IMAGE="swaggerapi/swagger-editor"
  CPORT=8080

else
  err "Unsupported specification type [$SPEC]"
fi

launch $NAME "docker run --detach --rm --name $NAME --platform linux/amd64 -p $PORT:$CPORT $IMAGE"
open -a "Google Chrome" http://127.0.0.1:"$PORT"
