#!/usr/bin/env bash

# Encrypts or decrypts a given data file with the provided passphrase. Specifically, 
# performs AES-256 in CBC mode, using PBKDF2 for key derivation with a random salt 
# and SHA-1 message digest. Produces Base64-encoded output. Requires OpenSSL 1.1+.

help() {
  echo "Usage: $0 [-h] [-d] -p <file> -i <file> -o <file>"
  echo "  -h          displays usage help"
  echo "  -d          decryption mode, if ommited encryption is implied"
  echo "  -p <file>   passphrase file"
  echo "  -i <file>   input data file"
  echo "  -o <file>   output data file"
}
  
fail() {
  echo "FAILURE: $1"
  exit 1
}

err() {
  fail "$1, use -h for help"
}

ENCRYPT=true

while getopts ":dp:i:o:h" opt; do
  case $opt in
    d)
      ENCRYPT=false
      ;;
    p)
      FILE_PWD=$OPTARG
      ;;
    i)
      FILE_IN=$OPTARG
      ;;
    o)
      FILE_OUT=$OPTARG
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

if [ -z "$FILE_PWD" ] || [ -z "$FILE_IN" ] || [ -z "$FILE_OUT" ]; then
  err "Missing required parameter(s)"
fi

if [ "$ENCRYPT" = false ]; then
    FLAG="-d"
fi

openssl enc $FLAG -aes-256-cbc -pbkdf2 -base64 -salt -md sha1 -in "$FILE_IN" -out "$FILE_OUT" -kfile "$FILE_PWD"
