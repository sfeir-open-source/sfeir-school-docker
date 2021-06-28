# Create image from alpine:3.5
FROM alpine:3.5

# some usefull tags
LABEL image-name docker-sfeirschool-front
LABEL maintainer furgerot.f@sfeir.com
LABEL sfeirschool-date 2018-03-07

# install nodejs
RUN apk add --update nodejs

# create user and group to run my app
RUN addgroup mygroup && adduser -D -G mygroup myuser 

# Environment variable
ENV appDir /app

# declare ports listening in the container
EXPOSE 3000

# Execute shell command : here create folder /app
RUN mkdir ${appDir}

# declare /app as current default directory
WORKDIR ${appDir}

# Copy all files from "build context" to /app folder
COPY package.json package-lock.json ${appDir}/

# Build the application and clean npm cache
RUN npm install && npm cache clean

COPY server.js ${appDir}/

# fix ownership
RUN chown -R myuser:mygroup /app

# execute following instruction as myuser
USER myuser


# Declare container startup command
ENTRYPOINT node server.js
