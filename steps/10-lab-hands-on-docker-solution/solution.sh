#!/usr/bin/env bash

docker pull registry.gitlab.com/gitlab-org/cloud-native/mirror/images/busybox

docker pull registry.hub.docker.com/library/busybox

docker pull busybox

docker images

# REPOSITORY                                                          TAG       IMAGE ID       CREATED       SIZE
# registry.hub.docker.com/library/busybox                             latest    9d5226e6ce3f   3 days ago    1.24MB
# busybox                                                             latest    9d5226e6ce3f   3 days ago    1.24MB
# registry.gitlab.com/gitlab-org/cloud-native/mirror/images/busybox   latest    bc01a3326866   3 weeks ago   1.24MB

# DockerHub is the default registry
# The repository is hardcoded even from the same registry

docker rmi registry.gitlab.com/gitlab-org/cloud-native/mirror/images/busybox

docker rmi registry.hub.docker.com/library/busybox

## Work with container

docker container run busybox

# A container need a background process to stay alive

docker container run busybox sleep 5

docker container run busybox echo "Hello World"

docker container run -i -t busybox 
# > echo "Hello world"
# > exit 
# The container is stopped

docker container run -d busybox sh -c 'while true; do echo Hello sfeir school; sleep 1; done'

docker container ls

docker container logs -f thirsty_elion

docker container stop thirsty_elion

docker container ls
docker container ls -a
docker container rm 3b8fbec97873

docker container prune
# prune delete EVERYTHING that is stopped !

docker container run --rm -it busybox
# > echo "hello" > /docker-test.txt
# > exit

docker container run --rm -it busybox
# > cat /docker-test.txt
# file not present anymore

docker container ls -a
docker rmi busybox