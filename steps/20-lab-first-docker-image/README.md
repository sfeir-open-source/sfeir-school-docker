# Lab 2 - Your first docker images

## Create a transitive image

### Tips

- Use the `docker commit`

### Make our image

1. Run `nginx` image detached with param `-p 80:80` named `mynginx1`
2. Check that the nginx page (localhost:80)
3. Run a shell without stopping the Container
4. Update the file `/usr/share/nginx/html/index.html` in the container
5. Check that the nginx page has been updated (localhost:80)
6. Create a transitive image named `my_awsome_image`
7. Run the new image
8. Check that the modifications are still present (localhost:80)
9. Check the layer with the `docker history` command

### Upload our image

1. Tag your image with the tag `<dockerHubId>/my_awsome_image:1.0`
2. List your docker images
   1. What do you see ?
3. Use the CLI to log into your docker account
4. Push your image
5. Check that your image is available on `https://hub.docker.com/repository/docker/<dockerHubId>/my_awsome_image/`
6. Delete the repository `https://hub.docker.com/repository/docker/<dockerHubId>/my_awsome_image/settings`