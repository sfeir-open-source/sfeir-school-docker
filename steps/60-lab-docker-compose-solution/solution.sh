#!/usr/bin/env bash

docker-compose build
# Build the images using the `build` from docker compose

docker-compose up -d

curl localhost:9092
# This is a sfeir school about Docker ! 
# I have been seen 1 times.