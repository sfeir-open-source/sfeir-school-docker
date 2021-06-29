# Volumes

##--##

<!-- .slide: class="sfeir-bg-white-7" -->

# Store files: volumes

![center h-600](./assets/images/volumes/file_system.png) <!-- .element: style="margin-top: 5rem;" -->

Notes:
3 types of volumes :
* anonymous and named volumes, managed by docker
* bind mount from host
* tmpfs, in memory

The first type are managed volumes:
* Docker manages the storage where files are stored and written (internally a folder, depending on OS)
* The folder is mounted as a traditionnal linux mount
* User doesn't have to meddle with it, it is manage as a whole volume through docker commands


##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Managed Volumes

Exercise 10a <!-- .element: class="exo" -->

* Image **couchdb** declares a volume which is created and managed by Docker.
List docker managed volumes:

```docker
docker volume ls
```

* Inspect container **couchdb1** and identify which volume is used:

```docker
docker container inspect --format "{{json .Mounts}}" couchdb1
```

* You can reuse volumes with another container:
Start a **busybox** container with volumes from container **couchdb1** :

```docker
docker container run -it --rm --volumes-from=couchdb1 busybox
ls /opt/couchdb/data
```

Notes:
L’image couchdb inclus la déclaration d’un volume anonyme, géré par docker, pour sauvegarder les données par défaut même si le container est supprimé

Noter au passage la syntaxe du --format. Il s’agit de “Go template” (hors contexte de la formation mais peut servir pour des scripts)

**--volume-from** est une astuce pour inspecter les volumes d’un autre container.
On voit plus tard qu’on peut aussi s’en servir pour réaliser des traitements annexes (batchs, log forwarder, monitoring, …)

on voit que **/opt/couchdb/data** contient quelques fichiers générés par couchdb


##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Managed Volumes - cleanup

Exercise 10b <!-- .element: class="exo" -->

* Stop **couchdb1** then delete the container and its volumes as well (rm **-v**) :

```docker
docker container stop couchdb1
docker container rm -v couchdb1
```

* Check the volume have been deleted successfully:

```docker
docker volume ls
```

Notes:
Sans l’option **-v**, le volume vu précédement n’est pas supprimé.

On peut aussi supprimer les volumes avec la commande 

```docker
docker volume rm ${VOLUME_ID}
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Named volumes

Exercise 11 <!-- .element: class="exo" -->

* Create a named volume and use it with container **couchdb1**
* Create the named volume:

```docker
docker volume create couchdb_vol
docker volume ls
```

* Create a new **couchdb1** container, using the named volume this time:

```docker
docker container run  --name couchdb1 -d -p 5984:5984 \
                      -v couchdb_vol:/opt/couchdb/data couchdb:2.1
```

* Inspect the new container **couchdb1** :

```docker
docker container inspect -f "{{json .Mounts}}" couchdb1
```

Notes:
on recrée un nouveau couchdb1 avec un volume nommé créé explicitement pour persister les données

##--##

<!-- .slide: class="sfeir-bg-white-7" -->

# Interact with your filesystem with bind mounts

![center h-600](./assets/images/volumes/file_system_area.png) <!-- .element: style="margin-top: 5rem;" -->

Notes:
Second type de volume, le bind mount

C’est un montage d’un dossier ou fichier de l’OS hôte vers le container.
Lecture seule ou lecture/écriture

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Bind mounts tips

Exercise 12 <!-- .element: class="exo" -->

* Start an interactive **busybox** container and mount directory `/var/lib/docker` from *host* to directory `/dck` inside the *container* :

```docker
docker container run -it --rm -v /var/lib/docker:/dck busybox
```

* Check this volume **couchdb1** contents:

```bash
ls /dck/volumes/couchdb_vol/_data
```

![center](./assets/images/volumes/ls_volume.png)

* Note: Directory `/var/lib/docker` is located where Docker Daemon runs (in a VM if not linux). This assignment shows how to access it from *Windows / Mac*.

Notes:
**/var/lib/docker** est dans la VM de toolbox/d4w/d4m, on ne peut pas y accéder directement.

**Anecdote : comment devenir root sur une VM avec docker**

Sous Linux, les droits d’accès aux fichier sont gérés par des userid (uid) et groupeid (gid). Par exemple l’utilisateur root a l’uid “0”. Le fonctionnement est le même dans les containers Linux.

Souvent, le processus à l’intérieur d’un container est exécuté en tant que l’utilisateur root “0” du container. Lorsqu’on monte un dossier de l’hôte dans un container, l’utilisateur root du container a les mêmes droits sur les fichiers que l’utilisateur root du système hôte.

Ainsi, si vous pouvez lancer un tel container sur un système où vous êtes simple utilisateur, vous pouvez écrire des fichiers auxquels seul root a accès, par exemple le fichier /etc/shadow qui contient les mots de passe utilisateur.

Il est donc possible de monter la racine “/” de l’hôte dans un container :
```docker
docker container run -it -v /:/host_root busybox sh
```

Ensuite, on pourra exécuter un chroot pour se placer dans ce fs et changer le mot de passe root :
```bash
chroot /host_root
passwd...
```

**Heureusement il y a des solutions.**

Les versions récentes (2017+) du démon de docker bénéficient du “user namespace”. Cette option permet de décaler les uid et gid des containers par rapport à ceux de l’OS hôte.

Par exemple, la plage d’utilisateur 0-2000 dans le container seront remappé sur la place 10000-12000 au niveau du système. L’utilisateur root “0” dans le container devient 10000 sur l’hôte et n’a donc plus aucun droit sur les fichiers de l’hôte.

On pourra également mettre en place des solutions de type SELinux pour gérer les permissions plus finement.

La documentation est disponible ici : https://docs.docker.com/engine/security/userns-remap/

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# SideCar Pattern

Exo 13 <!-- .element: class="exo" -->

* Launch a **busybox** container and mount current directory `$(pwd)` (from *host*) to `/dck` (to inside *container*):

```docker
docker container run  -d --rm --name gen_date \
                      -v $(pwd):/dck busybox \
                      sh -c 'while true; do date >> /dck/date.log; sleep 1; done'
```

* Launch a second **busybox** in interactive mode to check “logs” :

```docker
docker run -it --rm -v $(pwd):/dck2 busybox
tail -f /dck2/date.log
```

* Leave the second, then kill the first container :

```docker
docker kill gen_date
```

Notes:
Ce pattern permet d’exécuter des tâches annexes au container principal en conservant le principe “1 container 1 processus”.  
Ce principe n’est pas obligatoire : l’important dans un container multi-processus, c’est que le **processus principal du container (aka pid 0) gère l’arrêt de ses processus fils dans ce même container** lorqu’il reçoit un signal (sigterm, sigkill).


kill force l’arrêt du processsus là où stop envoie un signal TERM puis le KILL au bout de 30 secondes (paramétrable)

##--##

<!-- .slide: class="sfeir-bg-white-7 with-code big-code" -->

# File storage: in memory

![center h-500](./assets/images/volumes/file_system_memory.png) <!-- .element: style="margin-top: 5rem;" -->

* Launch a container with a (**tmpfs**) mount:

```docker
docker container run -ti --tmpfs /test busybox /bin/sh
mount | grep test
```

![center](./assets/images/volumes/tmpfs_container.png)

Notes:
**tmpfs** n’est pas spécifique docker, c’est un mécanisme générique Linux.
Docker facilite juste la création d’un tmpfs dans le container

Le tmpfs sert habituellement à accélérer des calculs.
Sur des machines avec beaucoup de RAM, on copie les matrices de données en fichier vers le tmpfs, et on exécute les calculs en lisant les fichiers en mémoire.

On peut aussi s’en servir pour stocker des secrets qui seront supprimés à l’arrêt du container.

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
