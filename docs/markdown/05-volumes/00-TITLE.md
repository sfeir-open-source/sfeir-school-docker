<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Volumes

##--##

<!-- .slide: class="sfeir-bg-white-7" -->

# Stocker des fichiers : les volumes

![center h-600](./assets/images/volumes/file_system.png) <!-- .element: style="margin-top: 5rem;" -->

Notes:
3 types de volumes, détaillés après :
* volume “tout court” ou nommés, managés par docker
* bind mount depuis le host
* tmpfs, en mémoire

Le premier est le volume managé :
* Docker gère le répertoire où sont stockés les fichiers écrit dans ce volume.
* Le répertoire est monté comme un montage de disque sous Linux.
* L’utilisateur n’a pas à s’en occuper, sauf à faire du ménage de temps en temps (voir slides suivant)


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

Notes:
L’image couchdb inclus la déclaration d’un volume anonyme, géré par docker, pour sauvegarder les données par défaut même si le container est supprimé

Noter au passage la syntaxe du --format. Il s’agit de “Go template” (hors contexte de la formation mais peut servir pour des scripts)

**--volume-from** est une astuce pour inspecter les volumes d’un autre container.
On voit plus tard qu’on peut aussi s’en servir pour réaliser des traitements annexes (batchs, log forwarder, monitoring, …)

on voit que **/opt/couchdb/data** contient quelques fichiers générés par couchdb


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

Notes:
Sans l’option **-v**, le volume vu précédement n’est pas supprimé.

On peut aussi supprimer les volumes avec la commande 

```docker
docker volume rm ${VOLUME_ID}
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

Notes:
on recrée un nouveau couchdb1 avec un volume nommé créé explicitement pour persister les données

##--##

<!-- .slide: class="sfeir-bg-white-7" -->

# Stocker des fichiers : bin mounts

![center h-600](./assets/images/volumes/file_system_area.png) <!-- .element: style="margin-top: 5rem;" -->

Notes:
Second type de volume, le bind mount

C’est un montage d’un dossier ou fichier de l’OS hôte vers le container.
Lecture seule ou lecture/écriture

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

Notes:
Ce pattern permet d’exécuter des tâches annexes au container principal en conservant le principe “1 container 1 processus”.  
Ce principe n’est pas obligatoire : l’important dans un container multi-processus, c’est que le **processus principal du container (aka pid 0) gère l’arrêt de ses processus fils dans ce même container** lorqu’il reçoit un signal (sigterm, sigkill).


kill force l’arrêt du processsus là où stop envoie un signal TERM puis le KILL au bout de 30 secondes (paramétrable)

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
