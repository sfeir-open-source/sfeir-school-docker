# Create image from alpine:3.5
FROM alpine:3.5

# some usefull tags
LABEL image-name docker-sfeirschool-back
LABEL maintainer furgerot.f@sfeir.com
LABEL sfeirschool-date 2018-07-23

# install nodejs
RUN apk add --update nodejs

# create user and group to run my app
RUN addgroup mygroup && adduser -D -G mygroup myuser

# Environment variable
ENV appDir /app

# declare ports listening in the container
EXPOSE 9000

# Execute shell command : here create folder /app
RUN mkdir ${appDir}

# declare /app as current default directory
WORKDIR ${appDir}

# Copy all files from "build context" to /app folder
COPY --chown=myuser:mygroup package.json package-lock.json ${appDir}/

# Build the application and clean npm cache
RUN npm install \
    && npm cache clean

COPY server.js ${appDir}

# execute following instruction as myuser
USER myuser

# Declare container startup command
ENTRYPOINT node server.js
