# Networks

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Networks

<div class="left">
<div class="box">

<p>Network connect containers together.</p>

<p>They behave like network bridges.</p>

<p>3 network types available:</p>

<ul>
  <li>none</li>
  <li>host</li>
  <li>bridge</li>
</ul>

</div>
</div>
<div class="right">
<div class="box">
![h-700 center](./assets/images/networks/network_line.png)
</div>
</div>

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Network "none"

* Container is isolated and can't access any network.

![h-700 center](./assets/images/networks/network_none.png)

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# "host" networks

* The container directly access your host machine network, it can communicate with everything you use outside Docker
* A server running on port 80 in the container will be reachable on your host on port 80 (without port binding involved)

![h-600 center](./assets/images/networks/network_host.png)

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# "default bridge" network

* Interface “docker0”
* That's the default network containers are connected to

![h-650 center](./assets/images/networks/network_bridge.png)

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Custom networks

* Gives control over containers network isolation
* A container can be connected to several networks

![h-800 center](./assets/images/networks/network_perso.png)

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# "frontend" Image

Exercise 15 <!-- .element: class="exo" -->

* Step into **assignment-material/front**
* Construisez puis pushez l’image :

```docker
docker image build -t <dockerId>/docker-training-front:1.0 .
docker image push <dockerId>/docker-training-front:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Networks

Exercise 16 <!-- .element: class="exo" -->

* Create networks **db_net** et **web_net** :

```docker
docker network create db_net
docker network create web_net
```

* Connect container **couchdb1** to network **db_net** with alias **couchdb** :

```docker
docker network connect db_net --alias couchdb couchdb1
```

* Start a new back container connected to **db_net** :

```docker
docker container run -d --name back -p 9000:9000 \
  --network=db_net <dockerId>/docker-training-back:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Networks 2

Exercise 17 <!-- .element: class="exo" -->

* Attach the container **back** to network **web_net** :

```docker
docker network connect web_net back
```

* Start a new **front** container attached to network **web_net** :

```docker
docker container run -d --name front -p 3000:3000 \
  --network=web_net <dockerId>/docker-training-front:1.0
```

* Open URL [http://localhost:9000/call/test](http://localhost:9000/call/test)
* Open URL [http://localhost:3000](http://localhost:3000)

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Oui Maître

Exercise 18 <!-- .element: class="exo" -->

* Stop container **couchdb1** :

```docker
docker container stop couchdb1
```

* Start a container **couchdb** attached to network **db_net** using volume  **couchdb_vol** :

```docker
docker container run -d --name couchdb -v couchdb_vol:/opt/couchdb/data \
  --network=db_net couchdb:2.1
```

* Refresh the front page
* You can now delete all containers

Notes:
Vous pouvez expliquer ici comment mettre à jour une db (éventuellement à chaud) en démarrant un container sur le même volume.

ATTENTION: couchdb ne supporte pas l’écriture concurrent, il faut absolument arrêter le premier container d’abord.
