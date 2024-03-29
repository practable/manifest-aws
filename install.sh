#!/bin/bash
go=$(which go)
if [ ! $? -eq 0 ]; then
   echo "please install go then try again"
fi

mkdir .source 2> /dev/null || true
mkdir bin 2> /dev/null || true
cd .source
if cd relay 2> /dev/null; then git pull origin v0.2.3; else git clone --branch v0.2.3 https://github.com/practable/relay && cd relay; fi
cd cmd/book
go build
cp book ../../../../bin/book
