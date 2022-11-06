<!-- .slide: -->

# Container Runtimes 

> Runtimes is responsible of create and run a container.

Notes: 

Speaker **Thibauld**

##--##

<!-- .slide: -->

# Container Runtimes 

* Docker
* Podman
* Containerd
* Cri-o
* And more

<!-- .element: class="list-fragment" -->

Notes: 

Issue : 

Docker use `containerd` that use itself `runc`.

Docker utilise donc containerd qui va lui même utiliser runc

Speaker **Thibauld**

##--## 

<!-- .slide: -->

# Container Runtimes 

* Runtimes Low-Level, run container following the [Open Container Initiative](https://opencontainers.org/) format
* Runtimes High-Level,use Low-Level but implement feature like image management and APIs on top

Notes: 

Low-Level: Execute container as OCI container
High-Level: More abstractions layer like API, push feature, pull feature etc.