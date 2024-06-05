#!/usr/bin/env bash

help() {
  echo "Usage: $0 [-h] <name> <command>{down|up}"
  echo "  -h            displays usage help"
  echo "  <name>        name of the tool to target"
  echo "  <command>     one of the following: down, up"
}

fail() {
  echo "FAILURE: $1"
  exit 1
}

err() {
  fail "$1, use -h for help"
}

while getopts ":h" opt; do
  case $opt in
    h)
      help
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

TOOL=${@:$OPTIND:1}
if [ -z "$TOOL" ]; then
  err "Tool name parameter required"
fi

CMD=${@:$OPTIND+1:1}
if [ -z "$CMD" ]; then
  err "Command parameter required"
fi
if [ "$CMD" != "down" ] && [ "$CMD" != "up" ]; then
  err "Unsupported command [$CMD]"
fi

if [ "$CMD" == "down" ]; then
    docker ps --format "{{.Names}}" | grep "$TOOL" | while read NAME
    do
        docker container stop "$NAME"
    done

elif [ "$CMD" == "up" ]; then
    docker compose -f $DOCKER_SPEC_HOME/$TOOL.yaml up -d
fi
