#!/usr/bin/env bash

help() {
  echo "Usage: $0 [model]"
  echo "  -h        displays this usage help"
  echo "  [model]   model to run, uses DEFAULT_LLM if none given"
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

LLM=${@:$OPTIND:1}
if [ -z "$LLM" ]; then
  LLM=$DEFAULT_LLM    
fi
if [ -z "$LLM" ]; then
  err "Missing model name parameter"
fi

if ! pgrep -fiq "ollama serve"; then
  echo "Starting ollama..."
  open /Applications/Ollama.app
fi

echo "Launching $LLM model..."
ollama run $LLM
