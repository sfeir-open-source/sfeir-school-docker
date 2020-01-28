<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Kubernetes
## Bonus 4 <!-- .element: class="bonus" style="color: white;" -->

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Concepts

![center](./assets/images/bonus/k8s/k8s_concepts.png)
<!-- .element: width="80%" -->

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Cluster

![center](./assets/images/bonus/k8s/k8s_cluster.png)
<!-- .element: width="50%" -->

Notes:

* Un cluster est un ensemble de machines qui collaborent entre elles.
* Sur Kubernetes, on distingue le master des noeuds (nodes).

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Exécuter des applications

![center](./assets/images/bonus/k8s/k8s_cluster_2.png)
<!-- .element: width="50%" -->

Notes:

* Le master est responsable de d’essentiel de la partie “contrôle” (control plane) du cluster.
* Les noeuds (nodes) sont responsable de l’exécution des applications.

Les fonctions de master et de node sont habituellement déployées sur des machines différentes.

En dev ces deux fonctions peuvent être déployées sur une unique machine (ex: Minikube)

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Node

![center](./assets/images/bonus/k8s/k8s_cluster_3.png)
<!-- .element: width="50%" -->

Notes:
Les noeuds exécutent les applications packagées dans des containers regroupés dans des **Pods**.

L’exécution des Pods est gérée par les **kubelet**.

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Pod

![center](./assets/images/bonus/k8s/k8s_pods.png)
<!-- .element: width="100%" -->

Notes:
Pod :

* 1 ou plusieurs containers
  * en général un seul
* partageant :
  * une seule IP
  * un ou plusieurs volumes

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# YAML

```yaml
apiVersion: v1 # API Version de la resource
kind: Pod # Type de la resource : Pod
metadata:
  name: my-app # Nom du Pod
spec:
  containers: # 2 containers
  - name:  my-app
    image: my-app
  - name:  nginx-ssl
    image: nginx
    ports: # Nginx front end sur 2 ports
    - containerPort: 80
    - containerPort: 443
```

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Kubernetes Objects

![center](./assets/images/bonus/k8s/k8s_objects.png)
<!-- .element: width="90%" -->

Notes:
**Objectif du slide :** premier aperçu des objets Kubernetes. **Ne pas détailler plus que les commentaires ci-dessous !**

On parle d’objets Kubernetes, de *resources*.
Chaque ressource représente une API.

ReplicaSet :

* maintient le nombre demandé de pods identiques
* la plupart du temps créé par le Deployment

Deployment :

* gère le cycle de vie des pods : versions, mise à jour continue (sans interruption)

Service :

* load-balancer interne vers un ensemble de pods
* accessible par IP ou par dns interne

Ingress :

* Point d’entrée HTTP(S)
* routage par Path ou par Virtualhost

Namespace :

* pour isoler des ressources

On reverra plus en détails ces objets et d’autres : ConfigMap, DaemonSet, Job, ...

##--##

<!-- .slide: class="sfeir-bg-white-1 with-code big-code" -->

# Play with Kubernetes

[https://labs.play-with-k8s.com](https://labs.play-with-k8s.com)
<!-- .element: class="center" -->

<span class="underline">Initialisation :</span>

```bash
kubeadm init --apiserver-advertise-address $(hostname -i)
kubectl apply -n kube-system -f \
  "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
