#!/usr/bin/env bash

docker build -t <dockerHubId>/my_flask:1.0 .
docker push <dockerHubId>/my_flask:1.0

docker run -d -p 9090:9090 --name app --rm <dockerHubId>/my_flask:1.0

curl localhost:9090