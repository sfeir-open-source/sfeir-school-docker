<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Docker Swarm
## Bonus 1 <!-- .element: class="bonus" style="color: white;" -->

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Orchestrateurs

![h-600](./assets/images/bonus/docker-swarm/swarm.png)
<!-- .element: style="position: absolute; left: 10rem; top: 10rem;" -->
![h-200](./assets/images/bonus/docker-swarm/kubernetes.png)
<!-- .element: style="position: absolute; right: 10rem; top: 20rem;" -->
![center](./assets/images/bonus/docker-swarm/rancher.png)
<!-- .element: style="position: absolute; left: 50rem; bottom: 10rem;" -->

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Docker Swarm

![center](./assets/images/bonus/docker-swarm/swarm_worker.png)
<!-- .element: width="80%" -->

Notes:
Topologies classiques :

* 1 manager / 3 workers (sans HA)
* 3 managers / 5 workers (avec HA)
* 5 managers / 12+ workers

Testé sur des cluster de 2000~3000 noeuds

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Docker Swarm & tools

![center](./assets/images/bonus/docker-swarm/swarm_compo.png)
<!-- .element: width="70%" -->

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Infrastructure

![center](./assets/images/bonus/docker-swarm/swarm_infra.png)
<!-- .element: width="70%" -->

Notes:
à faire avec docker-machine sur Virtualbox si RAM du host >= 4Go, sinon sur https://labs.play-with-docker.com

##--##

<!-- .slide: class="sfeir-bg-white-5" -->

# Topologie

![center](./assets/images/bonus/docker-swarm/swarm_topo.png)
<!-- .element: width="70%" -->

##--##

<!-- .slide: class="sfeir-bg-white-5 with-code big-code" -->

# Docker compose v3 - 1

```docker
version: '3.3'
volumes:
  db_data:
networks:
  web_net:
  db_net:
configs:
  appconfig:
    file: app.properties
secrets:
  dbcreds:
    file: dbcreds.prop
services:
  front:
    [...]
  back:
    [...]
    configs:
      - appconfig
    healthcheck:
      test: 'curl http://localhost:3000'
  db:
    [...]
```

Notes:
**TODO: vérifier fonctionnement “configs”**

Compose v3 apporte le support de Docker Swarm et du déploiement de stacks.
Il y a 2 modes de déploiement :

* `docker-compose up`
* `docker stack deploy -c docker-compose.yml <stackname>`

##--##

<!-- .slide: class="sfeir-bg-white-5 with-code big-code" -->

# Docker compose v3 - 2

```docker
version: '3.3'
  [...]
back:
  [...]
  deploy:
    replicas: 5
    resources:
      limits: …
      reservations: …
db:
  image: couchdb:2.1
  volumes:
    - db_data:/opt/couchdb/data
  networks:
    - db_net
  deploy:
    placement:
      contraints:
        - node.hostname = "manager"
```

Notes:
Certaines clés de configuration sont ignorées selon le mode

* `depends_on` est ignoré par le mode swarm. Il n’y a plus d’ordre de démarrage, c’est à l’application de gérer les `retry` de connexion.
* toute la section `deploy` des services est spécifique à Swarm

##--##

<!-- .slide: class="sfeir-bg-white-5 with-code big-code" -->

# Compose & Swarm

```bash
docker-compose up
```
<!-- .element: style="margin-bottom: 3rem;" -->

<span class="warning">WARNING:</span> The Docker Engine you're using is running in swarm mode.

Compose does not use swarm mode to deploy services to multiple nodes in a swarm. All containers will be scheduled on the current node.

To deploy your application across the swarm, use <span class="danger">`docker stack deploy`</span>.

Notes:
`docker-compose up` sur un daemon swarm affiche un warning ⇒ il faut utiliser `stack deploy` pour profiter du cluster swarm

##--##

<!-- .slide: class="sfeir-bg-white-5 with-code big-code" -->

# Docker Swarm

* Swarm init :
  * initialisation du premier manager avec **docker swarm init**
  * rattachement des 2 autres vms avec la command join
  * docker node ls
* Vizualizer :

```docker
docker service  create \
                --name=viz \
                --publish=8080:8080/tcp \
                --constraint=node.role==manager \
                --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
                dockersamples/visualizer
```

##--##

<!-- .slide: class="sfeir-bg-white-5 with-code big-code" -->

# Compose v3 & Stacks

* La **version 3** est concue pour être <span class="underline">compatible</span> avec **Swarm**.

```docker
docker stack deploy --compose-file=docker-compose.yml stack-training
```

* Nouveau noeud : `deploy`

```docker
version : ‘3’
services:
  deploy:
    replicas: N
```
