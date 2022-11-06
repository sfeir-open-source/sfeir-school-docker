<!-- .slide: class="with-code" -->

# Production environment

## Best practices - privileges

* Rootless containers
  * **USER** instruction exists
  * Provide appropriate permissions
<!-- .element: class="list-fragment" -->

* Don’t bind to a specific UID
  * Don't make it a requirement eg. use **`/tmp`** to writte on container
  * Some images use random UIDs when running containers
  * specific UID requires adjusting the permissions of any bind mount
<!-- .element: class="list-fragment" -->

* Make executables owned by root and not writable
  * The app user only needs execution permissions on the file, not ownership
    <!-- .element: class="list-fragment" -->

Notes:

* Rootless containers 
* Don’t bind to a specific UID
* Make executables owned by root and not writable

Speaker **Thibauld**

##--##
<!-- .slide: -->

# Production environment

## Best practices - image size

* keep the images minimal
  *  Excluding Build Tools with Multistage builds
  *  Avoid multiple `RUN` stage and prefere use of `&&` 
  *  Build image from [Alpine](https://hub.docker.com/_/alpine) or [Distroless](https://github.com/GoogleContainerTools/distroless) images
  *  Prefere the use of **COPY** instead of **ADD**

Notes:

Use COPY unless you really need the ADD functionality, like to add files from an URL or from a tar file. COPY is more predictable and less error prone.

Speaker **Thibauld**

##--##
<!-- .slide: -->

# Production environment

## Best practices - image size - example

Use case: go app 

- FROM `ubuntu` 
  - ubuntu -> 636MB
- FROM `golang`
  - golang -> 744MB
- FROM `alpine`
  - alpine -> 426MB
- FROM `golang:1.10-alpine3.8` 
  - golang-alpine -> 288MB
- FROM `golang:1.10-alpine3.8 AS multistage`
<!-- .element: class="list-fragment" -->
  - \<none\> -> 294MB
  - prod -> 11.3MB
<!-- .element: class="list-fragment" -->

Notes:

`multistage` generate 2 images one used for build and the other juste use copied files 
  - \<none\> -> 294MB
  - prod -> 11.3MB

eg: 

```dockerfile
FROM golang:1.10-alpine3.8 AS multistage
RUN apk add --no-cache --update git
WORKDIR /go/src/api
COPY . .
RUN go get -d -v && go install -v && go build
##
FROM alpine:3.8
COPY --from=multistage /go/bin/api /go/bin/
EXPOSE 3000
CMD ["/go/bin/api"]
```

Speaker **Thibauld**

##--##
<!-- .slide: -->

## Best practices - usages 

* Use trusted base images
* Update your images frequently
* Expose only the ports mandatory
* Build context : prefere `docker build -t myimage files/` to `docker build -t myimage .`
* use a .dockerignore file
<!-- .element: class="list-fragment" -->

Notes:

`EXPOSE` is for doc only

Speaker **Thibauld**

##--##
<!-- .slide: -->

## Best practices - layer 


Prefer:

```dockerfile
FROM ubuntu
RUN apt-get install nodejs
COPY source/* .
ENTRYPOINT ["/usr/bin/node", "/main.js"]

```

Instead of:

```dockerfile
FROM ubuntu
COPY source/* .
RUN apt-get install nodejs
ENTRYPOINT ["/usr/bin/node", "/main.js"]
```

Notes:

Cache optimisation

Speaker **Thibauld**

##--##
<!-- .slide: -->

## Best practices - Misc 

* Use specific image tag
* Add metadata labels
* Use Linter
* Scanning for Security Vulnerabilities
* Create Stateless, Reproducible Containers
* NO TO LATEST TAG
<!-- .element: class="list-fragment" -->

Notes:

`docker scan img` 
Speaker **Thibauld**