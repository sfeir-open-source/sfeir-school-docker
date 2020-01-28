<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Dockerfile

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code medium-code" -->

# Dockerfile

* **Image as code**
* Document texte

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

* Chaque **instruction** dans le Dockerfile créer un nouveau layer dans l’image finale qui sera créée.
* Au final, au travers de ces instructions Docker ne fait que réutiliser des features déjà existantes.
  * **run** d’un container
  * **exécution** de l’instruction (ce qui déclenche le Copy-On-Write)
  * **commit** de l’état du container pour créer une nouvelle image transitive
  * **rm** du container intermédiaire

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

* Pour permettre à Docker de gagner en efficacité, celui-ci utilise un cache sauf si l’on précise lors du **build**

```docker
docker build --no-cache=true
```

* Docker **invalide** ce cache dans plusieurs cas qu’il vaut mieux avoir en tête.
  * comparaison entre image parent et image file pour voir si une instruction est la même
  * pour les instructions **ADD** et **COPY**, le cache est invalidé sur le checksum des fichiers ajoutés est différent
  * **commit** de l’état du container pour créer une nouvelle image transitive
  * le check du cache ne s’effectue pas sur les fichiers à l’intérieur du container

Notes:
* Starting with a parent image that is already in the cache, the next instruction is compared against all child images derived from that base image to see if one of them was built using the exact same instruction. If not, the cache is invalidated.
* In most cases, simply comparing the instruction in the Dockerfile with one of the child images is sufficient. However, certain instructions require more examination and explanation.

Once the cache is invalidated, all subsequent Dockerfile commands generate new images and the cache is not used.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# FROM

* **Initialise une nouveau “build stage”** : défini l’image de base qui servira de base pour créer la notre. Celle-ci peut être disponible localement ou non et dans ce cas, un  Docker ira cherche sur un public repositories.
* On peut placer un **ARG** avant un **FROM** pour définir un argument qui servira dans le FROM.

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

* **ARG** permet de définir des arguments à passer à Docker au moment du build d’une image.
* On peut définir des valeurs par défauts directement depuis le `Dockerfile`

```dockerfile
FROM busybox
ARG version=1.0.0
```

* On définit la valeur de ces arguments au moment du build.

```docker
docker build --build-arg foo=some_value
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# LABEL

* **LABEL** permet de définir des metadatas associées à une image Docker
* Les metadatas sont renseignés sous la forme clé ⇒ valeur.

```dockerfile
LABEL maintainer=”Julien KLAER”
LABEL version=1.0.0
```

* On peut **inspect** les labels associés à notre image avec.

```docker
docker inspect image
```

Notes:
Si le LABEL contient des espacements, il faut utiliser des quotes / backslash comme on le ferait dans une ligne de commande.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# COPY and ADD

* **COPY** permet de copier des *fichiers locaux* vers le *container* à partir du build context.

```dockerfile
COPY file.txt /tmp/destination
```

* **ADD** permet de copier des *fichiers locaux*, *remote* et <span class="underline">dézipper directement</span> le contenu d’un tar dans le *container*.

```dockerfile
ADD application.tar /opt
```

* Par défaut les fichiers copiés <span class="underline">appartiennent à root</span> mais on peut préciser le user et le groupe.
Ils doivent exister au préalable

```dockerfile
COPY --chown=<user>:<group> <src> <dest>
```

Notes:
* COPY permets de copier uniquement des fichiers locaux vers le container.
* ADD lui permet de faire ceci ainsi que de dézipper directement le contenu d’un tar dans le container voir même de récupérer un fichier à distance.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# RUN

* **RUN** permet d'exécuter des commandes sur le *container transitif* afin de le faire muter pour écrire un <span class="underline">nouveau layer</span> sur une image.
* Il existe deux formes d’écriture mais le plus souvent on se passe de l’exec form.

```dockerfile
RUN apt-get dist-upgrade -y
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# EXPOSE

* **EXPOSE** permet de <span class="danger">documenter</span> l’exposition d’un ou plusieurs ports ainsi que de leurs protocols
* Les metadatas sont renseignés sous la forme clé ⇒ valeur.

```dockerfile
EXPOSE 80/tcp
EXPOSE 80/udp
```

* Pour effectuer le **port forwarding** il faut faire comme d’habitude :

```docker
docker container run --name couchdb1 -d -p 5984:5984 couchdb:2.1
```

Notes:
en utilisant l’option `--publish-all` lors de l'instanciation d’un container, on peut binder tous les ports exposés sur des ports aléatoires du host

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# VOLUME

* **VOLUME** permet de définir un <span class="underline">point de montage</span> qui sera effectivement créé lors de l'instanciation d’un nouveau container
* Pour créer un volume il faut utiliser l’instruction suivante :

```dockerfile
VOLUME /myVolume
```

Notes:
Attention les volumes utilisés dans les Dockerfile sont du type “anonyme”

Changing the volume from within the Dockerfile: If any build steps change the data within the volume after it has been declared, those changes will be discarded.

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# WORKDIR

* **WORKDIR** permet de définir le **répertoire d’éxécution** des prochaines instructions :
  * RUN
  * CMD
  * ENTRYPOINT
  * COPY
  * ADD
* On s’en sert simplement de cette manière :

```dockerfile
WORKDIR /opt
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# USER

* **USER** permet de définir le prochain <span class="danger">UID et optionnellement GID</span> dans lesquelles les instructions suivantes seront exécutées :
  * RUN
  * CMD
  * ENTRYPOINT
* Il est aussi très facile de s’en servir.

```dockerfile
USER webserver:application
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# ENV

* **ENV** permet de définir des **variables d’environnements** qui seront disponible à <span class="underline">l'exécution du container</span> et lors des <span class="underline">prochaines phases du build</span>.
* On les définit et s’en sert de la manière suivante.

```dockerfile
ENV application=”my-application”
ENV environment=”development”
RUN pass secrets/${environment}/${application}
```

* Il est possible de **setter** et même **overrider** ces variables lorsque l’on run un container.

```docker
docker container run -e environment=”development” busybox
```

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# ENTRYPOINT and CMD

* **ENTRYPOINT** permet de définir quel <span class="underline">exécutable</span> le container va lancer à son instanciation.
* **CMD** est utilisé principalement pour fournir des **options par défaut** pour l’instruction **ENTRYPOINT**.
* Voici un exemple d'utilisation des deux instructions ensemble :

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

# Votre première "vraie" image

Exo 14 <!-- .element: class="exo" -->

* Allez dans le dossier **docker-sfeirschool-2018/back**.
  Construisez et taggez (**-t**)  l’image décrite par le fichier **Dockerfile** :

```docker
docker image build -t <dockerId>/docker-sfeir-back:1.0 .
```

![dot_important](./assets/images/dockerfile/dot_important.png) <!-- .element: style="margin-left: 18.5rem;" -->

* Publiez votre image sur le Hub Docker :

```docker
docker image push <dockerId>/docker-sfeir-back:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Optimiser votre Dockerfile

* Objectif de minimiser la taille d’une image
* Une application devrait donc contenir uniquement son binaire et ses dépendances pour s'exécuter

Notes:
Comment construisons nous notre application si notre Dockerfile ne doit pas contenir les outils nécessaires à son packaging ? 

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# Avant on avait...

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

# Mais maintenant on a...

## <span class="border">➡ le **Multi stage build**</span>

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

# Lancement du serveur back

Exo 14 suite <!-- .element: class="exo" -->

* Lancez le *container* :

```docker
docker run -ti --rm -p 9000:9000 <dockerId>/docker-sfeir-back:1.0
```

![center](./assets/images/dockerfile/docker_run_server.png)

Notes:
Le programme tente de se connecter au serveur “db:5984”, mais ne le trouve pas….

Ajouts 2019-03-27  
La version courante du “back” retry à l’infini la connexion, on peut tuer le container
