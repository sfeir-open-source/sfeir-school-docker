<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Docker compose

##--##

<!-- .slide: class="sfeir-bg-white-3" -->

# Docker compose

* Réunir plusieurs instances d'images facilement
* Évite de passer son temps à taper uniquement des commandes verbeuses
* Gain de temps pour déployer de simples applications
<!-- .element: style="margin-bottom: 6rem;" -->

![h-500](./assets/images/docker-compose/kraken.png)
![h-500](./assets/images/docker-compose/whale.png) <!-- .element: style="margin-left: 6rem;" -->

##--##

<!-- .slide: class="sfeir-bg-white-3" -->

# Objectif

![center](./assets/images/docker-compose/swarm_cluster.png) <!-- .element: width="100%" -->

##--##

<!-- .slide: class="sfeir-bg-white-3 with-code big-code" -->

# Commandes

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

* La ~~version 1~~ est dépréciée.
* La version 2 permet la déclaration :
  * de volumes
  * de networks
  * de services

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

* En ligne de commande avec docker on aurait :

```docker
docker volume  create [--driver local] <prj>_db_data
docker network create [--driver local] <prj>_web_net
docker network create [--driver local] <prj>_db_net
```

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

* En ligne de commande avec docker on aurait :

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
