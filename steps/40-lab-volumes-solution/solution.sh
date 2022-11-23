#!/usr/bin/env bash

docker container run --name couchdb -d -p 5984:5984 couchdb:2.1

docker volume ls

docker container inspect couchdb

# "Mounts": [
#            {
#                "Type": "volume",
#                "Name": "3e073fa98d8d36ef7de34022d8d74bfbb25b3dfa60d3f957b705b735a09407de",
#                "Source": "/var/lib/docker/volumes/3e073fa98d8d36ef7de34022d8d74bfbb25b3dfa60d3f957b705b735a09407de/_data",
#                "Destination": "/opt/couchdb/data",
#                "Driver": "local",
#                "Mode": "",
#                "RW": true,
#                "Propagation": ""
#            }
#        ],

# Defined by couche db

docker container run -it --rm --volumes-from=couchdb busybox

ls /opt/couchdb/data

# _dbs.couch         _nodes.couch       _replicator.couch  _users.couch

docker stop couchdb

docker container rm -v couchdb

docker volume ls

##

docker volume create couchdb_vol

docker container run  --name couchdb -d -p 5984:5984 \
                      -v couchdb_vol:/opt/couchdb/data couchdb:2.1

docker container inspect couchdb

# "Mounts": [
#             {
#                 "Type": "volume",
#                 "Name": "couchdb_vol",
#                 "Source": "/var/lib/docker/volumes/couchdb_vol/_data",
#                 "Destination": "/opt/couchdb/data",
#                 "Driver": "local",
#                 "Mode": "z",
#                 "RW": true,
#                 "Propagation": ""
#             }
#         ],

##

docker container run -it --rm -v /var/lib/docker:/dck busybox

# > ls /dck/volumes/couchdb_vol/_data

# _dbs.couch         _nodes.couch       _replicator.couch  _users.couch

##

docker container run  -d --rm --name gen_date \
                      -v $(pwd)/sidecar:/dck busybox \
                      sh -c 'while true; do date >> /dck/date.log; sleep 1; done'

cat sidecar/date.log

# Mon Nov 21 12:49:06 UTC 2022
# Mon Nov 21 12:49:07 UTC 2022
# Mon Nov 21 12:49:08 UTC 2022
# Mon Nov 21 12:49:09 UTC 2022

docker run -it --rm -v $(pwd)/sidecar:/dck2 busybox

tail -f /dck2/date.log

# Mon Nov 21 12:49:06 UTC 2022
# Mon Nov 21 12:49:07 UTC 2022
# Mon Nov 21 12:49:08 UTC 2022
# Mon Nov 21 12:49:09 UTC 2022

# SIGKILL signal has been send

##

docker container run -ti --tmpfs /test busybox /bin/sh

# > mount | grep test
# tmpfs on /test type tmpfs (rw,nosuid,nodev,noexec,relatime)

