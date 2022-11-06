<!-- .slide: class="with-code" class="two-column" -->

# Docker compose

Use case :

5 containers.

- Back end container (worker eg Java)
- 2 différents databases 
  - high throughput database (eg. Redis / Apache Cassandra)
  - relational database (eg. myqsl / postgresql)
- 2 applications
  - to track whether someone is present in a meeting room reserved for a scheduled meeting
  - to monitor data

##--##

# Example

![center](./assets/images/70-docker-compose/application.png)

Notes:

Think of docker-compose as :
- an automated multi-container workflow
- a tool for development, testing, CI workflows, and staging environments

Speaker **Thibauld**

##==##
<!-- .slide: class="with-code" class="two-column" -->

# Docker compose

* docker run -d --name=redis redis
* docker run -d --name=postgres postgres
* docker run -d --name=worker worker
* docker run -d --name=camera camera
* docker run -d --name=monitoring monitoring

`docker-compose up`
<!-- .element: class="credits" -->

##--##

# docker-compose.yaml

```yaml
services:
    nosql_db:
        image: "redis:alpine“"
    sql_db:
        image: "postgres"
    worker:
        image: "registry/my-worker"
    camera:
        image: "camera-app"
    monitoring:
        image: "monitoring"
```

Notes:

Speaker **Thibauld**

