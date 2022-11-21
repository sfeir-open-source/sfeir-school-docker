<!-- .slide: -->

# Docker CLI

* To list available commands, either run `docker` with no parameters or execute `docker help`.

```sh
$ docker

Usage: docker [OPTIONS] COMMAND [ARG...]
       docker [ --help | -v | --version ]
```

Notes: 

Speaker **Thibauld**

##--##

<!-- .slide: -->

# Docker CLI

## Useful commands about images

* `docker images [OPTIONS] [NAME]` - List images
* `docker pull NAME` – Pull an image or a repository from a docker registry server
* `docker push NAME` – Push an image or a repository to the docker registry server
* `docker rmi [OPTIONS] IMAGE` – Remove an image
<!-- .element: class="list-fragment" -->

Notes: 

Speaker **Thibauld**

##--##

<!-- .slide: -->

# Docker CLI

## Useful commands about containers

* `docker docker ps [OPTIONS]` – List containers
* `docker run [OPTIONS] IMAGE COMMAND [ARG...]` – Run a command in a new container
* `docker logs [OPTIONS] CONTAINER` – Fetch the logs of a container
* `docker start [OPTIONS] NAME` – Start a stopped container
* `docker stop [OPTIONS] NAME` – Stop a running container
* `docker rm [OPTIONS] CONTAINER` – Remove a container
* `docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]` - create a transitive image
* `docker exec [OPTIONS] CONTAINER COMMAND [ARG...]` - exec a command in a container
<!-- .element: class="list-fragment" -->

Notes: 

Speaker **Thibauld**
