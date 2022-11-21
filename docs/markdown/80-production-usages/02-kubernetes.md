<!-- .slide: class="with-code" -->

# Kubernetes

## Container Orchestration

* deployment automation
* Container management
* Connectivity orchestration
* Automatically scale up or down
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**

##--##

# Kubernetes

## Orchestration Technologies

* Docker Swarm
* Windows Containers
* Kubernetes
* Mesos / Marathon
* Nomad
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**

##--##

# Kubernetes

## Why kubernetes?

* Auto-scaling of infrastructure (vertical and horizontal scaling)
* Automated Scheduling
* Easy rollbacks of application
* Self-healing
* Highly available
* Load balancing
<!-- .element: class="list-fragment" -->

Notes:

A matter of second 

Speaker **Thibauld**

##--##

# Kubernetes

## Architecture basics

* Composed of Nodes
  * Master - handle kubernetes components
  * Worker - handle containers/app

Notes:

A matter of second 

Speaker **Thibauld**

##--##

# Kubernetes

## Architecture basics - cluster

![center](./assets/images/80-production-usages/k8s.svg)

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## Architecture basics - worker nodes

* deployment
* replicaset
* pods
* services
* and more

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## Architecture basics - pods

![center h-800](./assets/images/80-production-usages/pod.svg)

Notes:

smaller resource that can exists

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## Architecture basics - Deployment

![center h-200](./assets/images/80-production-usages/deployment.png)

Notes:

Explain his role : 
* update pod
* scale
* self healing 
* ...

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## Infra as code - basics

> Infrastructure as Code (IaC) is the managing and provisioning of infrastructure through code instead of through manual processes.

* Declarative approach
* Increase in speed of deployments
* Reduce errors 
* Improve infrastructure consistency
* Eliminate configuration drift
<!-- .element: class="list-fragment" -->


Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## YAML - pods


```yaml
apiVersion: v1 # API Version de la resource
kind: Pod # Type de la resource : Pod
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

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## CLI - kubectl


> `kubectl [commande] [TYPE] [NOM] [flags]`

* `kubectl get pods`
* `kubectl get services`
* And more

[Cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
<!-- .element: class="credits" -->

Notes:

Speaker **Thibauld**

##--##
<!-- .slide: class="with-code" -->

# Kubernetes

## Playground

> [Play with kubernetes](https://labs.play-with-k8s.com/)

- create 3 instances. 1 master, 2 worker

```bash
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

kubectl get nodes 
```

[Cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
<!-- .element: class="credits" -->

Notes:

when nodes ready you should have a command to join cluster as node 
Speaker **Thibauld**

