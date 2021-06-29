# Dockerfile

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code medium-code" -->

# Dockerfile

* **Image as code**
* Text Document

```dockerfile
# Create image with you nodejs image (replace zbbfufu by your docker id)
FROM zbbfufu/nodejs:1.0
# Declare ports listening in the container
EXPOSE 9000
# Define variables
ENV appDir=/app
# Define current working directory (build & run)
WORKDIR ${appDir}
# Copy all files from “build context” to /app folder
COPY . /app
# Build the application
RUN npm install
# Declare container startup command and options
ENTRYPOINT node
CMD server.js
```

Notes:
https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/  
The main purpose of a CMD is to provide defaults for an executing container. These defaults can include an executable, or they can omit the executable, in which case you must specify an ENTRYPOINT instruction as well.

https://blog.codeship.com/3-different-ways-to-provide-docker-build-context/

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Dockerfile lifecycle

* Every **instruction** in the Dockerfile creates a new layer
* In the end, docker only reuse the existing commands we've seen just before:
  * **run** a container
  * **execute** the instruction (triggers the Copy-On-Write)
  * **commit** the container state to create intermediate image
  * **rm** on the intermediate container

Notes:
Exemple d’une stack docker build

```dockerfile
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM busybox
 ---> d8233ab899d4
Step 2/4 : ARG CONT_IMG_VER
 ---> Running in 1e56aa344f65
Removing intermediate container 1e56aa344f65
 ---> 3a8255d58f7a
Step 3/4 : ENV CONT_IMG_VER ${CONT_IMG_VER:-v1.0.0}
 ---> Running in f40cdd5a551a
Removing intermediate container f40cdd5a551a
 ---> b80dbb9af46d
Step 4/4 : RUN echo $CONT_IMG_VER
 ---> Running in 15966b838883
v1.0.0
Removing intermediate container 15966b838883
 ---> 40a0d16a7d2a
Successfully built 40a0d16a7d2a
Successfully tagged test-arg:latest
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code medium-code" -->

# Docker build console output

```dockerfile
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM busybox
 ---> d8233ab899d4
Step 2/4 : ARG CONT_IMG_VER
 ---> Running in 1e56aa344f65
Removing intermediate container 1e56aa344f65
 ---> 3a8255d58f7a
Step 3/4 : ENV CONT_IMG_VER ${CONT_IMG_VER:-v1.0.0}
 ---> Running in f40cdd5a551a
Removing intermediate container f40cdd5a551a
 ---> b80dbb9af46d
Step 4/4 : RUN echo $CONT_IMG_VER
 ---> Running in 15966b838883
v1.0.0
Removing intermediate container 15966b838883
 ---> 40a0d16a7d2a
Successfully built 40a0d16a7d2a
Successfully tagged test-arg:latest
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# Dockerfile lifecycle 2

* For efficiency purposes, Docker uses a cache
* Unless stated otherwise at **build** time:

```docker
docker build --no-cache=true
```

* Docker uses the cache:
  * same instructions (in same order and layer)
  * for instructions **ADD** and **COPY**, cache is invalidated when the checksum of added files change
  * Docker doesn't checksum on files **inside** the container. (This is a caveat when you update a dependcy in an external system but the instruction is the same, for ex using :latest dependencies)


Notes:
* Starting with a parent image that is already in the cache, the next instruction is compared against all child images derived from that base image to see if one of them was built using the exact same instruction. If not, the cache is invalidated.
* In most cases, simply comparing the instruction in the Dockerfile with one of the child images is sufficient. However, certain instructions require more examination and explanation.

Once the cache is invalidated, all subsequent Dockerfile commands generate new images and the cache is not used.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# FROM

* **Init a new “build stage”** : tells which image will be used for creating our own.
* It can be found locally (on the machine). if not, docker will pull it from public repositories
* You can define an **ARG** before **FROM**. It can be used to define an argument in the FROM. 

<br />

```dockerfile
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}
```

Notes:
L’instruction ARG doit se situer avant le FROM dans ce cas et ne peut être utilisée que par FROM.

```dockerfile
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}
CMD  /code/run-app

FROM extras:${CODE_VERSION}
CMD  /code/run-extras
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# ARG

* **ARG** are used to pass arguments to Docker for building images
* You can supply default values in the `Dockerfile`

```dockerfile
FROM busybox
ARG version=1.0.0
```

* **ARG**s can be defined at build time:

```docker
docker build --build-arg version=2.5.3
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# LABEL

* **LABEL** are metadatas for Docker images
* Labels are key ⇒ value pairs
* They are for documenting purposes

```dockerfile
LABEL maintainer=”Julien KLAER”
LABEL version=1.0.0
```

* One can **inspect** labels on an image:

```docker
docker inspect image
```

Notes:
Si le LABEL contient des espacements, il faut utiliser des quotes / backslash comme on le ferait dans une ligne de commande.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# COPY and ADD

* **COPY** allows copying *local files* to the *container*, from the build context.

```dockerfile
COPY file.txt /tmp/destination
```

* **ADD** allows copyings *local files*, *remote files* and <span class="underline">extract</span> tar archives into a *container*.

```dockerfile
ADD application.tar /opt
```

* By default, copied files are <span class="underline">owned by root</span>, but on can specify the user and group:
(they must already exist inside the container, more on that later)

```dockerfile
COPY --chown=<user>:<group> <src> <dest>
```

Notes:
* COPY permets de copier uniquement des fichiers locaux vers le container.
* ADD lui permet de faire ceci ainsi que de dézipper directement le contenu d’un tar dans le container voir même de récupérer un fichier à distance.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# RUN

* **RUN** will run commands inside the intermediate container, writing in the intermediate layer, to be committed before the next Dockerfile instruction.
* Il existe deux formes d’écriture mais le plus souvent on se passe de l’exec form.

```dockerfile
RUN apt-get install -y openjdk-11
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# EXPOSE

* **EXPOSE** will <span class="danger">documente</span> which port and protocol the application uses and should be bound

```dockerfile
EXPOSE 80/tcp
EXPOSE 80/udp
```

Beware this instruction in itself will not do the port binding when running a container

* To make a **port binding**, we use these options from previous chapters:

```docker
docker container run --name couchdb1 -d -p 5984:5984 couchdb:2.1
```

Notes:
en utilisant l’option `--publish-all` lors de l'instanciation d’un container, on peut binder tous les ports exposés sur des ports aléatoires du host

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# VOLUME

* **VOLUME** defines <span class="underline">mounting point</span>, which will be automatically created when a container is created with `docker run` (unless specified otherwise)
* To declare a volume, use this syntax:

```dockerfile
VOLUME /myVolume
```

Notes: The volume is a declaration and is not mounted during build time. It will be mounted once the image is built and you `docker run` a container from it

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# WORKDIR

**WORKDIR** changes the **current directory** where the next instructions will be run:

  * RUN
  * CMD
  * ENTRYPOINT
  * COPY
  * ADD

<br />

Syntax:

```dockerfile
WORKDIR /opt
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# USER

* **USER** will switch under which <span class="danger">user (UID and optionnaly GID)</span> the next instructions will run:
  * RUN
  * CMD
  * ENTRYPOINT
* This instruction **DOES NOT CREATE** a new user in the system.
* You can create a new user with this linux command: `RUN useradd -ms /bin/bash newuser`
* Syntax is:

```dockerfile
USER webserver:application
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# ENV

* **ENV** defines **environment variables** which will be available during <span class="underline">container execution</span> and during the <span class="underline">next build instructions</span>.
* The syntax is:

```dockerfile
ENV application=”my-application”
ENV environment=”development”
RUN pass secrets/${environment}/${application}
```

* You can **set** or even **override** these when you run a container

```docker
docker container run -e environment=”development” busybox
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# ENTRYPOINT and CMD

* **ENTRYPOINT** defines which <span class="underline">executable</span> the container will run when instanciated.
* **CMD** is used to give **default options** to the instruction in **ENTRYPOINT**.
* example :

```dockerfile
FROM ubuntu
ENTRYPOINT [“top”, “-b”]
CMD [“-c”]
```

Notes:
Rappeler qu’un container sans processus en foreground = un container qui s’arrête

Ouvrir la page https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact  
pour les interactions entre les deux instructions

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# ENTRYPOINT and CMD 2

![center](./assets/images/dockerfile/table_entrypoint_cmd.png)

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Your first image

Exercise 14 <!-- .element: class="exo" -->

* go into **assignment-material/back**.

  Build and tag (**-t**) the image describe in the **Dockerfile** :

```docker
docker image build -t <dockerId>/docker-training-back:1.0 .
```

*Don't forget the dot !* <!-- .element: style="margin-left: 25.5rem;" -->

* Publish your image on Docker Hub :

```docker
docker image push <dockerId>/docker-training-back:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Optimise your Dockerfiles

* Objective: minimize an image size footprint
* An application should contain only its binary/program and its dependencies, no more

<br />
=> *What when the dependencies needed to build (maven, go) are not the same needed to run (jdk ...)*


Notes:
Comment construisons nous notre application si notre Dockerfile ne doit pas contenir les outils nécessaires à son packaging ? 

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# Before, we had ...

## ➡ **Dockerfile.build**

```dockerfile
FROM golang:1.7.3
WORKDIR /go/src/github.com/alexellis/href-counter/
COPY app.go .
RUN go get -d -v golang.org/x/net/html \
  && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
```

## ➡ **Dockerfile.run**
<!-- .element: style="margin-top: 3rem;" -->

```dockerfile
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY app .
CMD ["./app"]
```

Notes:
Avec un Dockerfile on s’occuper de **builder** notre image.

Ajouts 2019-03-27:
Depuis cette nouvelle image, on lance un container, et on utilise

```docker
docker container cp \
<container_id>:/go/src/github.com/alexellis/href-counter/app \
./app
```
pour extraire `app` dans le dossier courant.

Et avec un autre Dockerfile on s’occupait de **livrer** notre application.

Malheureusement, pour passer les binaires d’une image à l’autre il fallait encore gérer des scripts shells en plus.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# Now we can combine those...

## <span class="border">➡ The **Multi stage build**</span>

```dockerfile
FROM golang:1.7.3 as builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/alexellis/href-counter/app .
CMD ["./app"] 
```

Notes:
Le multistage build permet de garder les layers de l’image uniquement du dernier FROM.  
Le reste n’est pas persisté.

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Starting the backend

Exercise 14b <!-- .element: class="exo" -->

* Run the *container* :

```docker
docker run -ti --rm -p 9000:9000 <dockerId>/docker-training-back:1.0
```

![center](./assets/images/dockerfile/docker_run_server.png)

Notes:
Le programme tente de se connecter au serveur “db:5984”, mais ne le trouve pas….

Ajouts 2019-03-27  
La version courante du “back” retry à l’infini la connexion, on peut tuer le container
