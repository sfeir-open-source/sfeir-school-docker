<!-- .slide: -->

# Volumes

## Types

3 volumes types:

- Managed by Docker 
- Bind/mount from host
- tmpfs
<!-- .element: class="list-fragment" -->

Notes:

Speaker **Thibauld**

##--##

# Volumes

## CLI

- `docker volume create VOLUME_NAME` - create a new volume
- `docker volume ls` - list volumes
- `docker volume inspect VOLUME_NAME` - inspect a volume
- `docker volume rm VOLUME_NAME` - remove an existing volume

⚠️ Before removing a volume you must stop every container using it.

Notes:

Speaker **Thibauld**

##--##

# Volumes

## Storage - Managed by Docker

```shell
--mount source=myvol,target=/app 

-v myvol:/app
```

- Docker handle the storage location 
- Directory as a mounting point in linux 
- The user don't have to handle it (expect for cleaning issues)
- Can use a custom name

Notes:

Speaker **Thibauld**

##--##

# Volumes

## Storage - Bind on host

```shell
--mount source=/var/lib/docker,target=/app 

-v /var/lib/docker:/app
```

- Directly on the host 
- Read/Writte 
- Read only

Notes:

Speaker **Thibauld**

##--##

# Volumes

## Storage - In memory (tmpfs)

```shell
--tmpfs /test 
```

- Not specific to Docker
- Deleted when the container is removed

Notes:

Docker make easier the creation of a tmpfs into the container

Speaker **Thibauld**

