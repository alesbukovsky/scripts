#!/usr/bin/env bash

help() {
  echo "Usage: $0 [-p <profile>] [-u <user>] [-t <port>] [-h] <name> <command>{start|ssh|stop}"
  echo "  -p <profile>  uses specified AWS profile"
  echo "  -u <user>     remote EC2 user, ssh command only"
  echo "  -t <port>     opens tunnel on given port, ssh command only"
  echo "  -h            displays usage help"
  echo "  <name>        EC2 instance name"
  echo "  <command>     one of the following: start, ssh, stop"
}

fail() {
  echo "FAILURE: $1"
  exit 1
}

err() {
  fail "$1, use -h for help"
}

while getopts ":p:u:t:h" opt; do
  case $opt in
    p)
      PROFILE="--profile $OPTARG"
      ;;
    u)
      USER=$OPTARG
      ;;
    t)
      TUNNEL="-L $OPTARG:127.0.0.1:$OPTARG"
      ;;
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

if [ -z "$PROFILE" ]; then
  PROFILE=""
fi

NAME=${@:$OPTIND:1}
if [ -z "$NAME" ]; then
  err "Instance name attribute required"
fi

CMD=${@:$OPTIND+1:1}
if [ -z "$CMD" ]; then
  err "Command attribute required"
fi
if [ "$CMD" != "start" ] && [ "$CMD" != "ssh" ] && [ "$CMD" != "stop" ]; then
  err "Unsupported command attribute [$CMD]"
fi
if [ "$CMD" != "ssh" ] && [ -z "$USER" ]; then
  err "Remote user attribute required for ssh command"
fi

DESC=$(aws ec2 describe-instances $PROFILE --filter Name=key-name,Values="$NAME" --query "Reservations[].Instances[0]" --output json)
if [ -z "$DESC" ] || [ "$DESC" = "[]" ]; then
  fail "Unable to obtain EC2 instance details [name=$NAME]"
fi

if [ "$CMD" == "start" ]; then
  
  STATE=$( echo "$DESC" | jq -r '.[0].State.Name' )
  if [ "$STATE" = "running" ]; then
    fail "EC2 instance is already running"
  fi
  IID=$( echo "$DESC" | jq -r '.[0].InstanceId' )
  aws ec2 start-instances $PROFILE --instance-ids $IID
  echo "Waiting for EC2 instance to start..."
  aws ec2 wait instance-running $PROFILE --instance-ids $IID 

elif [ "$CMD" == "ssh" ]; then
    
  IIP=$( echo "$DESC" | jq -r '.[0].PublicIpAddress' )
  if [ -z "$IIP" ] || [ "$IIP" == "null" ]; then
    fail "Unable to get EC2 instance IP address, possibly not running"
  fi
  ssh -i ~/.ssh/"$NAME".pem $TUNNEL -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $USER@$IIP

elif [ "$CMD" == "stop" ]; then
    
  STATE=$( echo "$DESC" | jq -r '.[0].State.Name' )
  if [ "$STATE" != "running" ]; then
    fail "EC2 instance is not running"
  fi
  IID=$( echo "$DESC" | jq -r '.[0].InstanceId' )
  aws ec2 stop-instances $PROFILE --instance-ids $IID
  echo "Waiting for EC2 instance to stop..."
  aws ec2 wait instance-stopped $PROFILE --instance-ids $IID 
fi
