<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Images et Containers

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

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# VM et Containers

![center](./assets/images/images_et_containers/vm_et_container.png) <!-- .element: width="100%" -->

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Image layers

* Image en lecture seule -> immutabilité
* Copy-On-Write strategy

<div class="center" style="margin-top: 5rem;">
![h-450](./assets/images/images_et_containers/docker_brique_1.png)
![h-450](./assets/images/images_et_containers/docker_brique_2.png)
![h-450](./assets/images/images_et_containers/docker_brique_3.png)
<div>

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Image layers 2

* Espace disque
* Performances

![center h-600](./assets/images/images_et_containers/saving-space.png)

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Dépendance à l'OS hôte

* Compatibilité binaire avec le noyau de l'OS hôte :
  * Linux / x86
  * Linux / arm
  * Windows 10 / x86 = "Windows Containers"
  * IBM Z Systems
* "Manifestes" multi-OS (redirections)
* Aujourd'hui, on ne parle que de containers Linux / x86

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Votre première image

Exo 7 <!-- .element: class="exo" -->

* Récupérez une image **alpine** et lancez-là en mode intéractif :

```docker
docker image pull alpine:3.5
docker container run -it --name node_ctn alpine:3.5
```

* Installez **nodejs** puis quittez le container :

```bash
apk add --update nodejs
exit
```

* Créez une nouvelle image à partir du container :

```docker
docker container commit node_ctn mynodejs
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Partagez des images

Exo 8 <!-- .element: class="exo" -->

* Taggez votre image :

```docker
docker image tag mynodejs <dockerHubId>/nodejs:1.0
```

* Listez vos images locales. Que constatez-vous ?

```docker
docker image ls
```

* Publiez votre image vers votre dépôt sur le Hub Docker :

```docker
docker login
docker image push <dockerHubId>/nodejs:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Images et tags

* Image ID = sha256 du contenu
* Tag :
  * pour identifier facilement une image
  * pour déterminer le dépôt d'origine

Pattern : <!-- .element: class="underline" -->

<div class="center border">
[[<span class="warning">registry url</span>/]]<span class="primary">username</span>/]<span class="danger">image</span>[:<span class="success">tag</span>|<span class="dark">@sha256</span>]
</div>

Exemples : <!-- .element: class="underline" -->

<div class="center border" style="margin-top: 1rem;">
<span class="warning">hub.docker.com</span>/<span class="primary">library</span>/<span class="danger">node</span>:<span class="success">latest</span>
<br/>
<span class="warning">hub.docker.com</span>/<span class="primary">zbbfufu</span>/<span class="danger">node</span>:<span class="success">8.0</span>
<br/>
<span class="warning">registry.sfeir.com:9000</span>/<span class="primary">taiebm</span>/<span class="danger">cordova</span>:<span class="success">5.0-test</span>
</div>

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
