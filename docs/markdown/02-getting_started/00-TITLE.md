<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Getting started

##--##

<!-- .slide: class="sfeir-bg-white-2 with-code-dark big-code" -->

# Images **vs** containers

<div class="center">
classes **vs** instance
</div>

```java
public class Point2D {
    private final int x;
    private final int y;

    public Point2D(int x, int y) {
        this.x = x;
        this.y = y;
    }
}
```

**VS** <!-- .element: class="center" -->

```java
public class Main {
    public static void main(String[] args) {
        Point2D point2D = new Point2D(2, 4);
    }
}
```

Notes:
IMPORTANT !

* On **package** un logiciel dans une **Image** ( == classe Java )
* On **exécute** un processus dans un **Container** ( == instance )

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Docker Store et Registry

<div class="left">
<div class="box">
Docker Hub / Docker Store
![h-700 center](./assets/images/getting_started/docker_store.jpg)
</div>
</div>
<div class="right">
<div class="box">
Kitematic
![h-700 center](./assets/images/getting_started/kitematic.jpg)
</div>
</div>

Notes:
Les images sont stockées dans une registry

Registry publique : *Kitematic* == *Docker Store* (images officielles vendors aprouvés) == *Docker Hub* (communautaire)

Registry privées : gcr.io sur la *GCP*, *Nexus 3*, *Artifactory*, *Docker EE*, …

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Les images

Exo 1 <!-- .element: class="exo" -->

* Listez les images présentes sur votre machine :

```docker
docker image ls
```

* Récupérez l'image `busybox` :

```docker
docker image pull busybox
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Premières exécutions

Exo 2 <!-- .element: class="exo" -->

* Instanciez un container *Hello world* à partir de l'image **busybox** :

```docker
docker container run busybox echo "Hello World"
```

* Instanciez un shell interactif à partir de l'image **busybox** :

```docker
docker container run -i -t busybox
```

* Exécutez un *Hello world* dans ce shell puis quittez le container :

```bash
echo "Hello World"
exit
```

Notes:
## mode “one shot”
interactif
-i = input / stdin
-t = tty / stdout+stderr

```docker
docker container run --help
  -i, --interactive                    Keep STDIN open even if not attached
  -t, --tty                            Allocate a pseudo-TTY
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Mode détaché

Exo 3 <!-- .element: class="exo" -->

* Instanciez un container en détaché (**-d**) à partir de l'image **busybox** :

```docker
docker container run -d busybox \
  sh -c 'while true; do echo Hello sfeir school; sleep 1; done'
```

* Listez les containers et trouvez l'id et le nom de votre container :

```docker
docker container ls
```

![center](./assets/images/getting_started/docker_container_ls.jpg)

* Affichez les logs du container :

```docker
docker container logs -f thirsty_elion
```

Notes:
## Mode détaché, s’exécute en tâche de fond (background)

Containers identifiables par ID ou par NAME

`logs -f` : comme tail, Ctrl+C pour sortir

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Stop !!!!

Exo 4 <!-- .element: class="exo" -->

* Listez les containers puis arrêtez le container détaché :

```docker
docker container stop thirsty_elion
```

* Listez les containers arrêtés puis supprimez le container :

```bash
docker container ls -a
docker container rm 3b8fbec97873
```

* Supprimez tous les containers arrêtés. <span class="danger">Attention, danger</span> :

```docker
docker container prune
```

Notes:
Containers identifiables par ID ou par NAME

docker container --help

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Containers éphémères

Exo 5 <!-- .element: class="exo" -->

* Instanciez un container **busybox** intéractif, supprimé à l'arrêt (**--rm**) :

```docker
docker container run --rm -it busybox
```

* Dans ce container, créez des fichiers, puis quittez :

```bash
echo "hello" > /docker-test.txt
exit
```

* Recréez un container identique et affichez le contenu du fichier :

```docker
docker container run --rm -it busybox
cat /docker-test.txt
```

Notes:
Le container est <span class="underline">supprimé à chaque fois</span>. Bien qu’il porte le même nom le fichier `docker-test.txt` n’est pas conservé.

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Nettoyage des images

Exo 6 <!-- .element: class="exo" -->

* Listez les images puis supprimez l'image **busybox** :

```docker
docker image ls
docker image rm busybox
```

* <span class="danger">Pour info</span>, pour supprimer toutes les images non utilisées par des containers :

```bash
docker image prune
```

##--##

<!-- .slide: class="sfeir-bg-white-2" -->

# Conclusion

<div class="full-center">
<img src="./assets/images/getting_started/conclusion.png" width="65%" alt="">
</div>

Notes:
Pour récapituler :

* docker en docker client ⇒ docker daemon
* **image pull** récupère une image d’une registry vers le daemon
* **container run** instancie un container à partir d’une image

##--##

<!-- .slide: class="sfeir-bg-white-2 with-code big-code" -->

# Docker "management commands"

```bash
docker ${OBJECT} ${COMMAND}
```

## With <!-- .element: style="margin-top: 5rem; margin-bottom: 5rem;" -->

| OBJECT | COMMAND | Description |
|--|--|--|
| <span class="warning">image</span>      | ls, pull, rm, prune | <span class="dark">Manage images</span>     |
| <span class="warning">container</span>  | ls, run, stop, rm, prune   | <span class="dark">Manage containers</span> |
|  |  |  |

Notes:
Ce slide montre les commandes découvertes jusqu’à maintenant

Syntaxe 2017 : `docker <obj> <cmd>`
Simplifie la compréhension de l’ensemble

Anciennes commandes :

* docker pull ⇒ docker image pull
* docker run ⇒ docker container run
* docker ps ⇒ docker container ls
* docker images ⇒ docker image ls
