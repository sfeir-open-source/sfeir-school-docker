<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Networks

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Réseaux

<div class="left">
<div class="box">

<p>Les réseaux permettent de relier les containers et de contrôler l’isolation de plusieurs groupes de containers.</p>

<p>Ils fonctionnent comme des switchs (bridges en anglais).</p>

<p>3 réseaux pré-définis :</p>

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

# Réseaux "none"

* Le container est indépendant et n'a accès à aucun réseau.

![h-700 center](./assets/images/networks/network_none.png)

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Réseaux "host"

* Le container a directement accès à l’interface physique du host, et donc à tous les réseaux qui y sont connectés.
* Un serveur tournant sur le port 80 du container est directement accessible sur le port 80 du host.

![h-600 center](./assets/images/networks/network_host.png)

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Réseaux "bridge"

* Interface “docker0”
* C’est le réseau par défaut sur lequel sont connectés les containers.

![h-650 center](./assets/images/networks/network_bridge.png)

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Réseaux "personnalisés"

* Pour isoler les containers
* Un container peut être attaché à plusieurs réseaux

![h-800 center](./assets/images/networks/network_perso.png)

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Image du "front"

Exo 15 <!-- .element: class="exo" -->

* Allez dans le dossier **docker-sfeirschool-2018/front**
* Construisez puis pushez l’image :

```docker
docker image build -t <dockerId>/docker-sfeir-front:1.0 .
docker image push <dockerId>/docker-sfeir-front:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Réseaux

Exo 16 <!-- .element: class="exo" -->

* Créez les réseaux **db_net** et **web_net** :

```docker
docker network create db_net
docker network create web_net
```

* Connectez le container **couchdb1** au réseau **db_net** avec l’alias **couchdb** :

```docker
docker network connect db_net --alias couchdb couchdb1
```

* Démarrez un nouveau container back connecté au réseau **db_net** :

```docker
docker container run -d --name back -p 9000:9000 \
  --network=db_net <dockerId>/docker-sfeir-back:1.0
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Réseaux 2

Exo 17 <!-- .element: class="exo" -->

* Attachez le container **back** au réseau **web_net** :

```docker
docker network connect web_net back
```

* Démarrez un nouveau container **front** attaché au réseau **web_net** :

```docker
docker container run -d --name front -p 3000:3000 \
  --network=web_net <dockerId>/docker-sfeir-front:1.0
```

* Ouvrez l’adresse [http://localhost:9000/call/test](http://localhost:9000/call/test)
* Ouvrez l’adresse [http://localhost:3000](http://localhost:3000)

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Oui Maître

Exo 18 <!-- .element: class="exo" -->

* Arrêtez le container **couchdb1** :

```docker
docker container stop couchdb1
```

* Démarrez un container **couchdb** attaché au réseau **db_net** et utilisant le volume  **couchdb_vol** :

```docker
docker container run -d --name couchdb -v couchdb_vol:/opt/couchdb/data \
  --network=db_net couchdb:2.1
```

* Rafraîchissez la page front
* Vous pouvez maintenant supprimer tous les containers
