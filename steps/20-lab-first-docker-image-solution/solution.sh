#!/usr/bin/env bash

docker run --name mynginx1 -p 80:80 -d nginx

curl localhost:80

docker exec -it mynginx1 bash

# > echo "<p>Louis was here</p>" >> /usr/share/nginx/html/index.html
# > exit

curl localhost:80

docker container commit mynginx1 my_awsome_image

docker run --name my_awsome_image -p 81:80 -d my_awsome_image

curl localhost:81


docker history my_awsome_image:latest 

# IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
# c996944804ee   13 minutes ago   nginx -g daemon off;                            1.8kB     
# 88736fe82739   6 days ago       /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  STOPSIGNAL SIGQUIT           0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  EXPOSE 80                    0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  ENTRYPOINT ["/docker-entr…   0B        
# <missing>      6 days ago       /bin/sh -c #(nop) COPY file:e57eef017a414ca7…   4.62kB    
# <missing>      6 days ago       /bin/sh -c #(nop) COPY file:abbcbf84dc17ee44…   1.27kB    
# <missing>      6 days ago       /bin/sh -c #(nop) COPY file:5c18272734349488…   2.12kB    
# <missing>      6 days ago       /bin/sh -c #(nop) COPY file:7b307b62e82255f0…   1.62kB    
# <missing>      6 days ago       /bin/sh -c set -x     && addgroup --system -…   61.2MB    
# <missing>      6 days ago       /bin/sh -c #(nop)  ENV PKG_RELEASE=1~bullseye   0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  ENV NJS_VERSION=0.7.7        0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  ENV NGINX_VERSION=1.23.2     0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B        
# <missing>      6 days ago       /bin/sh -c #(nop)  CMD ["bash"]                 0B        
# <missing>      6 days ago       /bin/sh -c #(nop) ADD file:d08e242792caa7f84…   80.5MB    

docker history nginx:latest 
# IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
# 88736fe82739   6 days ago   /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  STOPSIGNAL SIGQUIT           0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  EXPOSE 80                    0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  ENTRYPOINT ["/docker-entr…   0B        
# <missing>      6 days ago   /bin/sh -c #(nop) COPY file:e57eef017a414ca7…   4.62kB    
# <missing>      6 days ago   /bin/sh -c #(nop) COPY file:abbcbf84dc17ee44…   1.27kB    
# <missing>      6 days ago   /bin/sh -c #(nop) COPY file:5c18272734349488…   2.12kB    
# <missing>      6 days ago   /bin/sh -c #(nop) COPY file:7b307b62e82255f0…   1.62kB    
# <missing>      6 days ago   /bin/sh -c set -x     && addgroup --system -…   61.2MB    
# <missing>      6 days ago   /bin/sh -c #(nop)  ENV PKG_RELEASE=1~bullseye   0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  ENV NJS_VERSION=0.7.7        0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  ENV NGINX_VERSION=1.23.2     0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B        
# <missing>      6 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B        
# <missing>      6 days ago   /bin/sh -c #(nop) ADD file:d08e242792caa7f84…   80.5MB 

docker tag my_awsome_image:latest <dockerHubId>/my_awsome_image:1.0

docker images

docker login

docker push <dockerHubId>/my_awsome_image:1.0