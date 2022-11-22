<!-- .slide: class="with-code"-->

# Docker compose

## Service

```yaml
version: "3.9" # Deprecated
services:
  frontend:
    ...
  backend:
    ...
  db:
    ...
```

* services refer to the container's configuration

Notes:

Version is depracated but still present to maintain backwards compatibility
It follow the [Docker Compose specification](https://docs.docker.com/compose/compose-file/)

Speaker **Thibauld**

##--##

# Docker compose

## Container image

```yaml
services:
  frontend:
    image: my-vue-app
    ...
```

* image refer to the container's image to use
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**

##--##

# Docker compose

## Container build

```yaml
services:
  frontend:
    build: /path/to/dockerfile/ # can also use a URL
    ...
```

* image can be replaced by **build** to use dockerfile
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**

##--##

# Docker compose

## Container image & build

```yaml
services:
  frontend:
    build: /path/to/dockerfile/ # can also use a URL
    image: my-vue-app
    ...
```

* both **image** and **build** to name the images build
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**


##--##

# Docker compose

## Network

```yaml
services:
  network-example-service:
    image: busybox
    expose:
      - "80" # PORT IS EXPOSED THROUGH THE DOCKERFILE
```

```yaml
services:
  network-example-service:
    image: busybox
    ports:
      - "80:80" # PORT IS EXPOSED ON HOST 
```

* Avoid collision on host

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code"-->

# Docker compose

## Network - virtual

```yaml[5,10,15|18,19]
services:
  network-example-service:
    image: busybox
    networks: 
      - my-shared-network
    ...
  another-service-in-the-same-network:
    image: alpine:latest
    networks: 
      - my-shared-network
    ...
  another-service-in-its-own-network:
    image: alpine:latest
    networks: 
      - my-private-network
    ...
networks:
  my-shared-network: {}
  my-private-network: {}
```
<!-- .element: class="max-height" -->

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code"-->

# Docker compose

## Volume

```yaml
services:
  volumes-example-service:
    image: alpine:latest
    volumes: 
      - my-named-global-volume:/my-volumes/named-global-volume # RWO
      - /tmp:/my-volumes/host-volume # RWO - HOST
      - /home:/my-volumes/readonly-host-volume:ro # RO
    ...
  another-volumes-example-service:
    image: alpine:latest
    volumes:
      - my-named-global-volume:/another-path/the-same-named-global-volume # RWO
    ...
volumes:
  my-named-global-volume: 

```
<!-- .element: class="max-height" -->

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code"-->

# Docker compose

## Dependencies

```yaml
services:
  kafka:
    image: bitnami/kafka
    depends_on:
      - zookeeper
    ...
  zookeeper:
    image: bitnami/zookeeper
    ...
```
<!-- .element: class="max-height" -->

Notes:

No wait at all - if we want to wait utile load we should use `command` with custom sh script

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code"-->

# Docker compose

## Environment Variables

```yaml
services:
  database: 
    image: "postgres:${POSTGRES_VERSION}"
    environment:
      DB: mydb
      USER: "${USER}"
```
<!-- .element: class="max-height" -->

* using **.env** or **.properties** files (only work with `docker-compose up`) with `--env-file`

```.env
POSTGRES_VERSION=alpine
USER=foo
```

* before running the command

```shell
export POSTGRES_VERSION=alpine
export USER=foo
docker-compose up
```

Notes:

No wait at all - if we want to wait utile load we should use `command` with custom sh script

order : 
1. Compose file
2. Shell environment variables
3. Environment file
4. Dockerfile
5. Variable not defined

Speaker **Thibauld**



