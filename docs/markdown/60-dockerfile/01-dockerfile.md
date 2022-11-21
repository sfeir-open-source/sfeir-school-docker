<!-- .slide: class="with-code" -->

# Dockerfile

## Basics

Images as code.

```Dockerfile[1,2|3,4|5,6|7,8|9,10|11,12|13-15]
# Create image with you nodejs image (replace zbbfufu by your docker id)
FROM zbbfufu/nodejs:1.0
# Declare listening ports in the container
EXPOSE 9000
# Define environment variables
ENV appDir=/app
# Define current working directory (build & run)
WORKDIR ${appDir}
# Copy all files from “build context” to /app folder
COPY . /app
# Build the application
RUN npm install
# Declare container startup command and options
ENTRYPOINT node
CMD server.js
```

Notes:

Speaker **Thibauld**

##--##

# Dockerfile

## Lifecycle

- Every instruction create a new layer 
- Reuse of existing features 
  - Run of a container
  - Execution of an instruction (trigger the **Copy-On-Write**)
  - Commit of the container state to create a transitive images
  - Remove of the intermediate container

Notes:

Speaker **Thibauld**

##--##

# Dockerfile

## Build output example 

```[1-3|5-8|10-13|15-19|21-22]
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM busybox
 ---> d8233ab899d4

Step 2/4 : ARG CONT_IMG_VER
 ---> Running in 1e56aa344f65
Removing intermediate container 1e56aa344f65
 ---> 3a8255d58f7a

Step 3/4 : ENV CONT_IMG_VER ${CONT_IMG_VER:-v1.0.0}
 ---> Running in f40cdd5a551a
Removing intermediate container f40cdd5a551a
 ---> b80dbb9af46d

Step 4/4 : RUN echo $CONT_IMG_VER
 ---> Running in 15966b838883
v1.0.0
Removing intermediate container 15966b838883
 ---> 40a0d16a7d2a

Successfully built 40a0d16a7d2a
Successfully tagged test-arg:latest
```

Notes:

Speaker **Thibauld**

##--##

# Dockerfile

## Lifecycle

Docker use a cache to be more performant unless you use `--no-cache=true` option.

Docker may invalid the cache in some case:
- Comparison between the child image and the parent image
- `ADD` and `COPY` instruction - use of the checksum
- commit of a new transitive image

Cache check doesn't apply on internal file of the container.

Notes:

Once the cache is invalidated, all subsequent Dockerfile commands generate new images and the cache is not used.

Speaker **Thibauld**