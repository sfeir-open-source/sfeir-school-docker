# Introduction

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# What is Docker ?

<div class="full-center">
    <img src="./assets/images/docker.png" width="30%" alt="">
</div>

##--##

<!-- .slide: class="sfeir-bg-white-1" -->
# What is Docker
From IBM:
> Docker is an open source containerization platform. It enables developers to package applications into containers—standardized executable components combining application source code with the operating system (OS) libraries and dependencies required to run that code in any environment. Containers simplify delivery of distributed applications, and have become increasingly popular as organizations shift to cloud-native development and hybrid multicloud environments.


## what does that even mean ?

##--##

<!-- .slide: class="sfeir-bg-white-1" -->
# What problem does it solve ?

## Packaging
> I have my application, it runs on java 8.11 (later versions not supported), it has lots of dependencies (Spring, POI, Feign, Third Party plugins)

How do I install the application on the environment ? How I'm sure everything is setup ?

##--##

<!-- .slide: class="sfeir-bg-white-1" -->
# What problem does it solve ?

## Isolation
> I have a second application, it needs a different java version (11), and run on port 8080

Will there be conflict problems if I install them both on the same machine ?



##--##

<!-- .slide: class="sfeir-bg-white-1" -->
# What problem does it solve ?

## Scaling
> Incoming traffic varies, and can't handle the load on a single machine

How to start new instances on new machines ?
How to spare resources when traffic is low ?


##--##
<!-- .slide: class="sfeir-bg-white-1" -->
# Existing solution: a Virtual Machine

VMs images with app installed and environment prepared

you still need:
* installation scripts
* Spawn the VMs

And most importantly
* VM resource Overhead


##--##
<!-- .slide: class="sfeir-bg-white-1" -->

# An analogy: intermodal container

<div class="full-center">
<img src="./assets/images/introduction/logistique.png" width="85%" alt="">
</div>

Notes:
**Analogie** avec la **logistique** :

* Une marchandise variée
* Une multitude de formats
* Différents moyens de transport

Au 19ème siècle, manutention inter-modale faite à la main par des “dockers”

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# An analogy: intermodal container

<div class="full-center">
<img src="./assets/images/introduction/logistique_and_container.png" width="85%" alt="">
</div>

Notes:
Vers 1890, le patron d’un grand groupe logistique Américain veut simplifier le chargement/déchargement des camions, bateaux et trains.

Il invente un format de packaging qui deviendra un standard : le **container**.

* **Immutabilité :** Son contenu n’est pas modifié pendant le transport
* **Portabilité :** Il s’adapte à tous les modes de transport

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Software and containers

<div class="full-center">
<img src="./assets/images/introduction/informatique_and_container.png" width="85%" alt="">
</div>

Notes:
En informatique, le **container** peut aussi embarquer une <span class="underline">grande variété de contenus</span>.
Il s’exécute à l’identique dans plusieurs environnements sans être modifié.

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# What's Docker, again ?

<div class="full-center" width="80%">
Docker can **package an application**
<br/>
with **all of its dependencies**
<br/>
within a **standardized unit:**
<br/>
<br/>
<p>**CONTAINERS**</p>
</div>

Notes:
Docker en une phrase

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Some history: Where Docker comes from?

<div class="left">
<div class="box">

<ul>
  <li>Solomon Hykes @DotCloud</li>
  <li>Programmed with Go</li>
  <li>Open source</li>
  <li>1<sup>st</sup> version : 13 march 2013</li>
</ul>

</div>
</div>

<div class="right">
<div class="box">
![center](./assets/images/introduction/develop_on_docker.jpg)
</div>
</div>

Notes:
**DotCloud :** startup qui fourni un outil (`dc`) pour simplifier la gestion de containers LXC
Utilise les principes à la base des containers docker

**Docker CE:** open source 2013

-> Docker Inc. vend du service et la solution propriétaire **Docker EE**

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

<div class="full-center">
<img src="./assets/images/introduction/docker_timeline.png" width="85%" alt="">
</div>

Notes:
Quelques dates clés :

* Année 2000 : Linux VServer, OpenVZ : hack du noyau Linux
* 2007 : Control Groups dans le noyau Linux
* 2008 : LXC (Linux Containers), uses cgroups
* 2013 : Docker
