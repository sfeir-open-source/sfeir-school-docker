#!/usr/bin/env bash

docker container run --name couchdb1 -d -p 5984:5984 couchdb:2.1

curl localhost:5984

# {"couchdb":"Welcome","version":"2.1.2","features":["scheduler"],"vendor":{"name":"The Apache Software Foundation"}}

docker run -it --rm  busybox sh

wget localhost:5984

# Can't reach localhost:5984
# not the same host

wget couchdb1:5984

# Can't reach couchdb1:5984
# not the same host, not the same network, no dns

docker network create busyboxtocouchdb

docker network connect busyboxtocouchdb couchdb1 

docker run -it --rm --network busyboxtocouchdb busybox sh

wget couchdb1:5984
# Connecting to couchdb1:5984 (172.19.0.2:5984)
# saving to 'index.html'
# index.html           100% |*****************************************************************************************************************|   116  0:00:00 ETA
# 'index.html' saved