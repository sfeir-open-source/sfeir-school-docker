<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Introduction

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Qu'est-ce que Docker ?

<div class="full-center">
    <img src="./assets/images/docker.png" width="30%" alt="">
</div>

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# La logistique

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

# La logistique et les containers

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

# L'informatique et les containers

<div class="full-center">
<img src="./assets/images/introduction/informatique_and_container.png" width="85%" alt="">
</div>

Notes:
En informatique, le **container** peut aussi embarquer une <span class="underline">grande variété de contenus</span>.
Il s’exécute à l’identique dans plusieurs environnements sans être modifié.

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Qu'y mettons-nous ?

<div class="full-center">
<img src="./assets/images/introduction/all_in_docker.png" width="85%" alt="">
</div>

Notes:
Une variété de **runtimes**

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Qu'est-ce que Docker ?

<div class="full-center" width="80%">
Docker permet de **packager une application**
<br/>
avec **l’ensemble de ses dépendances**
<br/>
dans une **unité standardisée**
<br/>
pour le déploiement de logiciels :
<br/>
<p>
les **CONTAINERS**
</p>
</div>

Notes:
Docker en une phrase

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# D'où vient Docker ?

<div class="left">

<div class="box">

<ul>
  <li>Solomon Hykes @DotCloud</li>
  <li>Programmé en Go</li>
  <li>Open source</li>
  <li>1<sup>ère</sup> version : 13 mars 2013</li>
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

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Ce que vous allez mettre en place

<div class="center">
<img src="./assets/images/introduction/architecture.png" width="75%" alt="">
</div>

Notes:
Cluster Swarm :

* une application **front** scalable
* une application **back** scalable
* une base **couchdb** sur un seul noeud.

Le tout avec une séparation réseau 3 tiers
