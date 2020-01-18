<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Ports

##--##

<!-- .slide: class="sfeir-bg-white-6" -->

# Port binding

![center](./assets/images/ports/binding_1.png)

##--##

<!-- .slide: class="sfeir-bg-white-6" -->

# Port binding 2

![center](./assets/images/ports/binding_2.png)

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Publication de ports

Exo 9 <!-- .element: class="exo" -->

* Récupérez l'image **couchdb** taguée **2.1** :

```docker
docker image pull couchdb:2.1
```

* Instanciez un container **couchdb1** détaché en exposant le port **5984** sur le port **5984** du host :

```docker
docker container run --name couchdb1 -d -p 5984:5984 couchdb:2.1
```

* Ouvrez votre navigateur sur l'url [http://localhost:5984](http://localhost:5984) : *CouchDB* affiche sa version

##--##

<!-- .slide: class="sfeir-bg-white-6 with-code big-code" -->

# Docker "management commands"

```bash
docker ${OBJECT} ${COMMAND}
```

## With <!-- .element: style="margin-top: 5rem; margin-bottom: 5rem;" -->

| OBJECT | COMMAND | Description |
|--|--|--|
| <span class="warning">image</span>      | ls, pull, rm, prune, push, tag | <span class="dark">Manage images</span>     |
| <span class="warning">container</span>  | ls, run **-p**, stop, rm, prune, commit   | <span class="dark">Manage containers</span> |
|  |  |  |
