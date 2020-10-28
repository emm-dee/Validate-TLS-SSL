#!/bin/bash

usage()
{
  echo "usage: $0 -c <cert_path> -k <key_path>"
  exit 1
}

#Check inputs
while getopts c:k: flag; do
  case "${flag}" in
    c) CERTFILE=${OPTARG};;
    k) KEYFILE=${OPTARG};;
    \? ) usage;;
  esac
done

if [ -z "$CERTFILE" ] || [ -z "$KEYFILE" ]; then
  usage
fi

# Validate cert/key
if [ -f "$CERTFILE" ] && [ -f "$KEYFILE" ]; then

  CRT_MD5=$(openssl x509 -noout -modulus -in "$CERTFILE" | openssl md5)
  KEY_MD5=$(openssl rsa  -noout -modulus -in "$KEYFILE" | openssl md5)

  if [ "$CRT_MD5" == "$KEY_MD5" ]; then
    echo "OK - Cert and Key match!"
  else
    echo "FAIL - Cert and Key do not match"
    exit 2
  fi

else
  echo "Provided key/cert location is invalid. Check paths and try again"
  exit 1
fi
