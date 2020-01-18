<!-- .slide: class="transition-white sfeir-bg-blue" -->

# Kubernetes
## Bonus 4 <!-- .element: class="exo" style="color: white;" -->

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

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Exécuter des applications

![center](./assets/images/bonus/k8s/k8s_cluster_2.png)
<!-- .element: width="50%" -->

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Node

![center](./assets/images/bonus/k8s/k8s_cluster_3.png)
<!-- .element: width="50%" -->

##--##

<!-- .slide: class="sfeir-bg-white-1" -->

# Pod

![center](./assets/images/bonus/k8s/k8s_pods.png)
<!-- .element: width="100%" -->

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
