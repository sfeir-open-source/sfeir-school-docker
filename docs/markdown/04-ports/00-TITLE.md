# Ports

Notes:
Jusqu’à maintenant l'interaction des containers avec le reste du monde était limitée à la ligne de commande interactive (`-it`) et les logs.

Dans ce chapitre nous verrons comment accéder aux processus de type serveur (web ou autre) depuis l’extérieur


##--##

<!-- .slide: class="sfeir-bg-white-6" -->

# Port binding

![center](./assets/images/ports/binding_1.png)

Notes:
Par défaut les services exposés par les containers (les processus serveurs) ne sont pas accessibles. Pour y accéder, il faut ajouter des bindings de ports de l’interface physique de l’hôte vers les ports des containers.  

C’est une association 1:1 entre un port hôte et un port d’un container. On ne peut donc pas exposer deux fois un serveur web sur le port 80.  

* -P publie tous les ports container sur des ports aléatoires du host
* -p pour spécifier les ports à publier et sur quels ports coté hosts.


##--##

<!-- .slide: class="sfeir-bg-white-6" -->

# Port binding 2

![center](./assets/images/ports/binding_2.png)

Notes:
Si l’hôte a plusieurs interfaces, on peut choisir depuis quelle interface/IP de l’hôte faire le binding (par défaut toutes les interfaces)

Use case exemple : “bastion”, le SSH n’est accessible que de l'intérieur ou en VPN, tandis que le tomcat est exposé publiquement

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Pubishing ports

Exercise 9 <!-- .element: class="exo" -->

* Pull image **couchdb** tagged **2.1** :

```docker
docker image pull couchdb:2.1
```

* Instanciate a **couchdb1** container in detached mode and expose port **5984** from inside the container to the port **5984** on the host :

```docker
docker container run --name couchdb1 -d -p 5984:5984 couchdb:2.1
```

* Open url [http://localhost:5984](http://localhost:5984) in your browser : *CouchDB* prints its version

Notes:
Attention, avec Toolbox l’url est `http://<ip_vm>:5984`
En profiter pour réexpliquer le fonctionnement de ToolBox (Windows > VirtualBox VM > Containers)

(Note privée : couchdb1 sert plus tard)


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

Notes:
dans ce chapitre, nous avons juste vu l’option pour le binding de ports
