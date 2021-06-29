# Images and Containers

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# VM **vs** Containers

<div class="left">
<div class="box">
![center](./assets/images/images_et_containers/vm.png)
</div>
</div>

<div class="right">
<div class="box">
![center](./assets/images/images_et_containers/docker_engine.png)
</div>
</div>

Notes:

* Avantages de Docker :
  * permet un partage des ressources efficace
  * plus de simple pour gérer des environnements d’exécution variés

* Avantages des full VMs :
  * isolation GARANTIE puisqu’il n’y a aucune communications entre l'hôte et la machine virtuelle
  * accès au matériel plus simple

##--##

# Docker on
# Toolbox / Docker4Win / Docker4Mac

<div class="left">
<div class="box">
![center](./assets/images/images_et_containers/virtualbox.png)
</div>
</div>

<div class="right">
<div class="box">
![center](./assets/images/images_et_containers/windows_docker.png)
</div>
</div>

Notes:
Dans ces 3 cas :

* Linux + daemon Docker dans VM Linux,
* client Docker sur l’OS de la machine (Windows, Mac)

* Docker Toolbox : Virtualbox + docker-machine (gestion des VMs)

* Docker4Win : Linux dans HyperV
* Docker4Mac : hyperviseur xhyve sur primitives de virtualisation intégré dans macOS
* Docker4(Win/Mac) : intégration réseau et montage de fs facilité

##--##
<!-- .slide: class="sfeir-bg-white-5" -->

# Dependency to host OS

* Binary compat with host kernel:
  * Linux / x86
  * Linux / arm
  * Windows 10 / x86 = "Windows Containers"
  * IBM Z Systems
* multi-OS "Manifests" (redirections)
* Today, we mostly use x86_64 Linux containers / x86

Notes:
Les commandes/processus sont exécutées sur l’OS (noyau/kernel) de hôte  
⇒ il faut que les binaires de l’image soient compatibles  
⇒ 4 architecture == 4 images différentes  

Manifests:
* lien vers les images pour chaque archi
* stockée dans la registry
* redirection suivie par le daemon docker
* pas de commande manifests dans le client docker ⇒ third party tools

La formation est orientée Linux / x86

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Your first image

Exercise 7 <!-- .element: class="exo" -->

* Fetch an **alpine** image then execute a interactive container with it :

```docker
docker image pull alpine:3.5
docker container run -it --name node_ctn alpine:3.5
```

* Install **nodejs** there then leave the container :

```bash
apk add --update nodejs
exit
```

* Create a new image from the container :

```docker
docker container commit node_ctn mynodejs
```

Notes:
Objectif :  
création d’une nouvelle image “commitée” à partir d’un container ⇒ aka. snapshot

node_ctn = nom du container  
mynodejs = nom de la nouvelle image


##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Image layers

* Image are read-only -> immutability
* Copy-On-Write strategy

<div class="center" style="margin-top: 5rem;">
![h-450](./assets/images/images_et_containers/docker_brique_1.png)
![h-450](./assets/images/images_et_containers/docker_brique_2.png)
![h-450](./assets/images/images_et_containers/docker_brique_3.png)
<div>

Notes:

* Images constituées de layers, notion d’héritage
* Immutabilité des images / filesystem (fs) du container en lecture/écriture
* Un fichier est modifié par recopie dans le layer du container ⇒ “Copy-On-Write”
* Un fichier supprimé est matérialisé par un marqueur “suppression” dans le layer du container

<span class="underline">exemple :</span>
installation debian + emacs + apache
les layers sont le résultat des fichiers écrits par des commandes apt-get, ...


##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Image layers 2

* Storage
* Performances

![center h-600](./assets/images/images_et_containers/saving-space.png)

Notes:
<span class="underline">Autre exemple :</span>

* La modification à partir d’une image ubuntu:15.04 ne modifie pas l’image, mais en crée une nouvelle
* La nouvelle image réutilise les layers de la précédente
* la nouvelle layer ne pèse ici que 13 octets

Espace disque : pas besoin de dupliquer le contenu binaire des images  
⇒ versus VM où l’OS hôte est dupliqué.  
⇒ Intéret en entreprise de définir une image de base communes à tous les projets.

Performances : le mapping des fichiers de l’image stockée sur disque vers la mémoire vive n’est fait qu’une fois par image ⇒ binaire partagé en mémoire tant que non modifié

##--##


<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Share images

Exercise 8 <!-- .element: class="exo" -->

* Tag your image :

```docker
docker image tag mynodejs <dockerHubId>/nodejs:1.0
```

* List local images. Notice anything ?

```docker
docker image ls
```

* Publish your image to your repository to Docker Hub:

```docker
docker login
docker image push <dockerHubId>/nodejs:1.0
```

Notes:
On peut associer plusieurs tags à une même image.  

⇒ Voir slide suivant pour détails sur la composition du nom des images

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Images and tags

* Image ID = sha256 of the contents
* Tag :
  * identifying an image quickly
  * identify the repository

Pattern : <!-- .element: class="underline" -->

<div class="center border">
[[<span class="warning">registry url</span>/]]<span class="primary">username</span>/]<span class="danger">image</span>[:<span class="success">tag</span>|<span class="dark">@sha256</span>]
</div>

Exemples : <!-- .element: class="underline" -->

<div class="center border" style="margin-top: 1rem;">
<span class="danger">node</span>
<br/>
<span class="danger">node</span>:<span class="success">latest</span>
<br/>
<span class="warning">hub.docker.com</span>/<span class="primary">library</span>/<span class="danger">node</span>:<span class="success">latest</span>
<br/>
<span class="warning">hub.docker.com</span>/<span class="primary">zbbfufu</span>/<span class="danger">node</span>:<span class="success">8.0</span>
<br/>
<span class="warning">registry.sfeir.com:9000</span>/<span class="primary">taiebm</span>/<span class="danger">cordova</span>:<span class="success">5.0-test</span>
</div>
Notes:
An image est identifiée de façon unique par son ID, le sha256 du contenu.  
La plupart du temps les ids sont tronqués à l’affichage, comme dans git.  

Pour simplifier l’accès aux images, on y applique des tags.  
On peut avoir n tags ⇒ 1 image  
On peut modifier un tag pour pointer sur une autre image (autre ID).  

Le nom complet de l’image détermine le repository d’origine/destination.  
Repository = le nom complet de l’image sans la version  

##--##

<!-- .slide: class="sfeir-bg-white-5 with-code big-code" -->

# Docker "management commands"

```bash
docker ${OBJECT} ${COMMAND}
```

## With <!-- .element: style="margin-top: 5rem; margin-bottom: 5rem;" -->

| OBJECT | COMMAND | Description |
|--|--|--|
| <span class="warning">image</span>      | ls, pull, rm, prune, **push**, **tag** | <span class="dark">Manage images</span>     |
| <span class="warning">container</span>  | ls, run, stop, rm, prune, **commit**   | <span class="dark">Manage containers</span> |
|  |  |  |

Notes:
**en gras :** nouvelles commandes découvertes dans ce chapître
