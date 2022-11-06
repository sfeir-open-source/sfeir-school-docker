<!-- .slide: class="two-column big-code" -->

# Layer in Docker

* Layer 1. Base Ubuntu Layer

* Layer 2. Changes in apt packages

* Layer 3. Changes in pip packages

* Layer 4. Source code

* Layer 5. Entrypoint with python command

##--##

# DockerFile

```Dockerfile
# Layer 1
FROM ubuntu:18.04

# Layer 2
RUN apt-get update && apt-get –y install python 

# Layer 3
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r matplotlib

# Layer 4
COPY . /opt/source-code

# Layer 5
ENTRYPOINT python /app/app.py
```

Notes:

Speaker **Thibauld**

##==##

# Layer in Docker

* Layered architecture 
* Immutability
* **Copy-On-Write**
* Delete file are flagged in corresponding layer
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**

##--##

# Layer in Docker

## Modifying existing images

![h-400](./assets/images/30-images-containers/saving-space.png)

- New image created
- Reuse existings layer
- Perfomant 
- Disk usage optimized
<!-- .element: class="list-fragment" -->

Notes:

Enterprise : use the same base image to  optimize disk space

Cache

Speaker **Thibauld**

##--##

# Layer in Docker 

## OS dependancy 

* Binary compatibility with the host OS kernel
    - Linux / amd64 (x86)
    - Linux / ARM
    - Windows x86-64 
    - [And more](https://github.com/docker-library/official-images#architectures-other-than-amd64)
* manifest for multi-os redirection 

Notes: 

Based on Linux container LXC

Manifests:
- link to each arch 
- stored into the registry
- redirect using the docker daemon

Speaker **Thibauld**