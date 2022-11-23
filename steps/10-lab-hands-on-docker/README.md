# Lab 1 - Hands on Docker

## Pull your first images.

### Tips

- Busybox from the docker hub registry: `registry.hub.docker.com/library/busybox`
- Pull busybox from another registry: `registry.gitlab.com/gitlab-org/cloud-native/mirror/images/busybox`

### Images from different registry

- Pull `busybox` from the default registry
- Pull `busybox` from the gitlab registry

1. What is the default registry ?
2. What is the différence between these images ?
3. Remove all images that aren't from the default registry.

## Work with container

1. Run a busybox container
   1. What happend ?
   2. Fix it with a sleep
2. Run a busybox container that said "Hello world"
3. Instantiate an interactive shell with busybox
   1. Run a Hello world inside the container
   2. Leave the container
   3. What happened ?
4. Run a container in background that say "Hello world"
5. Find the container id
6. Print the container logs
7. Stop the container
8. List all container
   1. What happend ?
   2. List all container even the one that is stopped
9. Delete the stopped container
10. Delete all stopped containers

## Work with ephemeral container

1. Run a interactif container with busybox that will be deleted at stop
   1. Create a txt file with "Hello"
   2. Exit the container
2. Re-run the container 
3. Check the file 
4. What happened ?

## Clean up

1. List all images
2. Delete busybox images

You can use the `prune` command