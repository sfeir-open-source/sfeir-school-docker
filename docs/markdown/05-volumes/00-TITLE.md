<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Volumes

##--##

<!-- .slide: class="sfeir-bg-white-7" -->

# Stocker des fichiers : les volumes

![center h-600](./assets/images/volumes/file_system.png) <!-- .element: style="margin-top: 5rem;" -->

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Volumes managés

Exo 10a <!-- .element: class="exo" -->

* L’image **couchdb** déclare un volume qui est créé et géré par Docker.
Listez les volumes gérés par docker :

```docker
docker volume ls
```

* Inspectez le container **couchdb1** pour identifier le volume utilisé :

```docker
docker container inspect --format "{{json .Mounts}}" couchdb1
```

* On peut réutiliser les volumes d’un autre container.
Lancez un container **busybox** avec les volumes du container **couchdb1** :

```docker
docker container run -it --rm --volumes-from=couchdb1 busybox
ls /opt/couchdb/data
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Volumes managés - nettoyage

Exo 10b <!-- .element: class="exo" -->

* Arrêtez **couchdb1** et supprimez le container ainsi que ses volumes (rm **-v**) :

```docker
docker container stop couchdb1
docker container rm -v couchdb1
```

* Vérifiez que le volume a bien été supprimé :

```docker
docker volume ls
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Volumes nommés

Exo 11 <!-- .element: class="exo" -->

* Vous allez créer un volume nommé et l’utiliser pour le container **couchdb1**
* Créez un volume nommé :

```docker
docker volume create couchdb_vol
docker volume ls
```

* Recréez un container **couchdb1**, utilisant cette fois le volume nommé :

```docker
docker container run  --name couchdb1 -d -p 5984:5984 \
                      -v couchdb_vol:/opt/couchdb/data couchdb:2.1
```

* Inspectez le nouveau container **couchdb1** :

```docker
docker container inspect -f "{{json .Mounts}}" couchdb1
```

##--##

<!-- .slide: class="sfeir-bg-white-7" -->

# Stocker des fichiers : bin mounts

![center h-600](./assets/images/volumes/file_system_area.png) <!-- .element: style="margin-top: 5rem;" -->

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Bind mount et astuce

Exo 12 <!-- .element: class="exo" -->

* Lancez un container **busybox** intéractif en montant le dossier `/var/lib/docker` du *host* vers le dossier `/dck` du *container* :

```docker
docker container run -it --rm -v /var/lib/docker:/dck busybox
```

* Regarder le contenu du volume **couchdb1** :

```bash
ls /dck/volumes/couchdb_vol/_data
```

![center](./assets/images/volumes/ls_volume.png)

* Note : Le dossier `/var/lib/docker` est situé dans la VM où tourne le démon Docker. Cet exercice montre comment y accéder depuis *Windows / Mac*.

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Pattern SideCar

Exo 13 <!-- .element: class="exo" -->

* Lancez un container **busybox** en montant le dossier courant `$(pwd)` du *host* vers le dossier `/dck` du *container* :

```docker
docker container run  -d --rm --name gen_date \
                      -v $(pwd):/dck busybox \
                      sh -c 'while true; do date >> /dck/date.log; sleep 1; done'
```

* Lancez un second container **busybox** interactif pour voir les “logs” :

```docker
docker run -it --rm -v $(pwd):/dck2 busybox
tail -f /dck2/date.log
```

* Quittez le second puis tuez le premier container :

```docker
docker kill gen_date
```

##--##

<!-- .slide: class="sfeir-bg-white-7 with-code big-code" -->

# Stocker des fichiers : en mémoire

![center h-500](./assets/images/volumes/file_system_memory.png) <!-- .element: style="margin-top: 5rem;" -->

* Pour lancer un container avec un filesystem en mémoire (**tmpfs**) :

```docker
docker container run -ti --tmpfs /test busybox /bin/sh
mount | grep test
```

![center](./assets/images/volumes/tmpfs_container.png)

##--##

<!-- .slide: class="sfeir-bg-white-7 with-code big-code" -->

# Docker "management commands"

```bash
docker ${OBJECT} ${COMMAND}
```

## With <!-- .element: style="margin-top: 5rem; margin-bottom: 5rem;" -->

| OBJECT | COMMAND | Description |
|--|--|--|
| <span class="warning">image</span>      | ls, pull, rm, prune, push, tag                                               | <span class="dark">Manage images</span>     |
| <span class="warning">container</span>  | ls, run -p **--rm -v --volumes-from**, stop, rm, **kill**, **inspect**       | <span class="dark">Manage containers</span> |
| <span class="warning">volume</span>     | ls, create, rm                                                               | <span class="dark">Manage volumes</span> |
|  |  |  |
