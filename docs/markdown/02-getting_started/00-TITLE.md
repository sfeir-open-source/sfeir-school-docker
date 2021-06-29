# Getting started



##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Images

Exercise 1 <!-- .element: class="exo" -->

* List docker images on your machine :

```docker
docker image ls
```

* Download the `busybox` image:

```docker
docker image pull busybox
```

* List docker images, again:

```docker
docker image ls
```



##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# First runs

Exercise 2 <!-- .element: class="exo" -->

* Instanciate a container *Hello world* from image **busybox**:

```docker
docker container run busybox echo "Hello World"
```

* Instanciate an interactive shell from image **busybox**:

```docker
docker container run -i -t busybox
```

* Run *Hello world* inside this shell then quit:

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

# Detached Mode

Exercise 3 <!-- .element: class="exo" -->

* Instanciate a container in detached mode (**-d**) from image **busybox** :

```docker
docker container run -d busybox \
  sh -c 'while true; do echo Hello sfeir school; sleep 1; done'
```

* List containers then find your id and container name:

```docker
docker container ls
```

![center](./assets/images/getting_started/docker_container_ls.jpg)

* Print container logs:

```docker
docker container logs -f thirsty_elion
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Stop !!!!

Exo 4 <!-- .element: class="exo" -->

* List containers then stop the detached container:

```docker
docker container stop thirsty_elion
```

* List stopped containers then delete it:

```bash
docker container ls -a
docker container rm 3b8fbec97873
```

* Delete all stopped containers :

```docker
docker container prune
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Ephemeral Containers

Exercise 5 <!-- .element: class="exo" -->

<!-- * Instanciate an interactive **busybox** container, removed on stop (**--rm**) :

```docker
docker container run --rm -it busybox
``` -->

* Instanciate an interactive **busybox** container :

```docker
docker container run -it busybox
```

* From there, create files then exit:

```bash
echo "hello" > /docker-test.txt
exit
```

* Recreate an identical container, then try to print the contents of the file:

```docker
docker container run --rm -it busybox
cat /docker-test.txt
```

##--##

<!-- .slide: class="sfeir-bg-white-4 with-code big-code" -->

# Image cleanup

Exercise 6 <!-- .element: class="exo" -->

* List images then delete image **busybox** :

```docker
docker image ls
docker image rm busybox
docker image ls
```

* <span class="danger">Tip</span>: to delete all unused images:

```bash
docker image prune
```

##--##

<!-- .slide: class="sfeir-bg-white-2 d-with-code-dark big-code" -->

# Images **vs** containers

<div class="center">
classes **vs** instances
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

* One **packages** software inside an **Image** ( ~= Java class)
* On **execute** a process inside a **Container** ( ~= instance )

##--##


<!-- .slide: class="sfeir-bg-white-2 with-code big-code" -->

# Docker "management commands"

```bash
docker ${OBJECT} ${COMMAND}
```

## With <!-- .element: style="margin-top: 5rem; margin-bottom: 5rem;" -->

| OBJECT | COMMAND | Description |
|--|--|--|
| <span class="warning">image</span> | ls, pull, rm, prune | <span class="dark">Manage images</span> |
| <span class="warning">container</span> | ls, run, stop, rm, prune | <span class="dark">Manage containers</span> |

Notes:
Ce slide montre les commandes découvertes jusqu’à maintenant

Syntaxe 2017 : `docker <obj> <cmd>`
Simplifie la compréhension de l’ensemble

Anciennes commandes :

* docker pull ⇒ docker image pull
* docker run ⇒ docker container run
* docker ps ⇒ docker container ls
* docker images ⇒ docker image ls
