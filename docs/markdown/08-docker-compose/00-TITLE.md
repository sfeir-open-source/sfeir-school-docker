# Docker compose

Notes:
Fichier descriptif au format yaml

Permet de lancer un ensemble de containers qui interagissent entre eux

Contient toutes les options des commandes précédentes

##--##

<!-- .slide: class="sfeir-bg-white-3" -->

# Docker compose

* Gather multiple containers easily
* Skip writing verbose docker command-lines
* Time-saver for simple applications
<!-- .element: style="margin-bottom: 6rem;" -->

![h-500](./assets/images/docker-compose/kraken.png)
![h-500](./assets/images/docker-compose/whale.png) <!-- .element: style="margin-left: 6rem;" -->

##--##

<!-- .slide: class="sfeir-bg-white-3" -->

# Objective

![center](./assets/images/docker-compose/swarm_cluster.png) <!-- .element: width="100%" -->

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code big-code" -->

# Commands

```bash
docker-compose build

docker-compose up [--build] [-d]

docker-compose ps, rm, logs...
```

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code medium-code" -->

# Docker compose v2

```docker
version: '2'
volumes:

networks:


services:
```

* ~~version 1~~ is deprecated.
* Version 2 allows declaration of:
  * volumes
  * networks
  * services
* Version 3 hasn't much changes compared to v2

Notes:
v1 déprécié, on passe directement à la v2, qui permet de déclarer les volumes, les networks et les services.

La notion de service correspond à un groupe de containers identiques exposés sur un seul port.
Docker gère l’équilibrage de charge (load-balancing) des requêtes entrantes vers les différents containers du service.

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code medium-code" -->

# Docker compose v2 - 2

```docker
version: '2'
volumes:
  db_data:
networks:
  web_net:
  db_net:
services:
```

* This equivalent to using the following commands:

```docker
docker volume  create [--driver local] <prj>_db_data
docker network create [--driver local] <prj>_web_net
docker network create [--driver local] <prj>_db_net
```

Notes:
Les ressources Docker créées par docker-compose sont préfixés par le nom du projet.
Le projet prend par défaut le nom du dossier courant aka `basename $(pwd)`

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code medium-code" -->

# Docker compose v2 - 3

```docker
version: '2'
volumes:
  db_data:
networks:
  web_net:
  db_net:
services:
  db:
    image: couchdb:2.1
    volumes:
      - db_data:/opt/couchdb/data
```

* Docker command line equivalent:

```docker
docker container run  --name <prj>_db \
                      -v <prj>_db_data:/opt/couchdb/data couchdb:2.1
```

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code medium-code" -->

# Docker compose v2 - 4

```docker
version: '2'
volumes:
  db_data:
networks:
  web_net:
  db_net:
services:
  db:
    image: couchdb:2.1
    volumes:
      - db_data:/opt/couchdb/data




  back:
    build: ./back
    depends_on:
     - db



  front:
    build: ./front
    ports:
     - "80:3000"
    depends_on:
     - back
```

Notes:
Compose v2 est arrivé avec les volumes et les networks.
On parle maintenant de services, plus de containers.

On ajoute la version en en-tête de fichier.
Les containers de compose v1 se retrouvent sous la clé “services” (on décale l’indentation d’un cran).

Les services sont joignables entre eux par leur nom, les “links” ne servent plus.
Pour déclarer les dépendances entre services, on utilise la clé “depends_on”

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code medium-code" -->

# Docker compose v2 - 5

```docker
version: '2'
volumes:
  db_data:
networks:
  web_net:
  db_net:
services:
  db:
    image: couchdb:2.1
    volumes:
      - db_data:/opt/couchdb/data
    networks:
      - db_net:
          aliases:
            - couchdb
  back:
    build: ./back
    depends_on:
     - db
    networks:
      - web_net
      - db_net
  front:
    build: ./front
    ports:
     - "80:3000"
    depends_on:
     - back
    networks:
      - web_net
```

Notes:
Compose v2 supporte les réseaux et les volumes nommés

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code medium-code" -->

# Docker compose v2 - 6

```docker
...
services:
  db:
    image: couchdb:2.1
    volumes:
      - db_data:/opt/couchdb/data
    networks:
      - db_net:
          aliases:
            - couchdb
  back:
    build: ./back
    image: user/sfeir-back:1.0
    depends_on:
     - db
    networks:
      - web_net
      - db_net
  front:
    build: ./front
    image: user/sfeir-front:1.0
    ports:
     - "80:3000"
    depends_on:
     - back
    networks:
      - web_net
```

Notes:
On peut également ajouter le tag des images qu’on va builder, ainsi que les healthchecks des services
