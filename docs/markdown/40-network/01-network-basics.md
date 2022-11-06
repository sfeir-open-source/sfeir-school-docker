<!-- .slide: -->

# Network

## Default Network 

- Bridge : `docker run busybox`
  - Virtual network for docker application, isolated
  - `docker0` interface 
  - default
- Host : `docker run busybox`
  - host network, not isolated, can't bind same application on same port
- none
<!-- .element: class="list-fragment" -->
  - not attachd to any network, isolated
<!-- .element: class="list-fragment" -->

Notes:

Bridge no port binded
host automatic bind

Speaker **Thibauld**

##--##

<!-- .slide: -->

# Network

## Custom Network 

```sh
docker network create –-driver [bridge|overlay] -–subnet [subnet] NETWORK
```

- Isolated container
- multi-network container

Notes:

Do not use overlay for driver - require a zookeeper or a etcd etc 

Speaker **Thibauld**

##--##

<!-- .slide: class="with-code alone" -->

# Network

## Inspect Network 

```bash [1,7|18,19,24]
docker inspect [NETWORK|CONTAINER]

[
    {
        "Id": "0d9a61f653bc6554e77cdc2ea7dd4af7ba4c657b9bff26d3bbd69335648dbd92",
        "State": { },
        "Name": "/busybox",
        "RestartCount": 0,
        "Platform": "linux",
        ...
        "HostConfig": {},
        "NetworkSettings": {
           ...
            "Networks": {
                "bridge": {
                    "NetworkID": "e4df9c785a4d062e220f706ba9ab5995c64aa629c1d2b7cffdf6a6d4c8eed261",
                    "EndpointID": "7b91628ce599207cc0a43b109776d15d91a6d041ebfb919c436da2495b388be0",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```
 
Notes:

Do not use overlay for driver - require a zookeeper or a etcd etc 

Speaker **Thibauld**

##--##

# Network

## Port

- Not accessible by default
- 1 : 1 assocation
- Access container on **bridge** network
- Bind any port from the **container** to any free port on **host**
- can bind port on specifics interfaces/IP

Notes: 

Use case example : “bastion”
SSH only accessible from vpn or internal
Tomcat exposed to 0.0.0.0

Speaker **Thibauld**

##--##

# Network

## Port binding

```shell
-p HOST_PORT:CONTAINER_PORT
```

- On `docker create` or `docker run` commandes.
- Must be on a free port
- Can specified `tcp`or `upd` 
- Can specified the interface/ip to use

Notes: 

Speaker **Thibauld**

##--##

# Network

## DNS

- Embded DNS under the hood 
- can refer to IP or container name

Notes: 

Speaker **Thibauld**