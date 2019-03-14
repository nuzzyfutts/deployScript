#!/bin/bash

echo -e "Howdy, what folder do you want to serve assets from?"
echo -e -n "\033[36m>\033[0m "
read foldrdir

echo -e "Okay, I'll read from \033[35m$foldrdir\033[0m. What do you want to name the container?"
echo -e -n "\033[36m>\033[0m "
read container

echo -e "The container will be named \033[32m$container\033[0m. What frontend rule do you want to use for traefik?"
echo -e -n "\033[36m>\033[0m "
read urlrule

echo -e "Creating container \033[32m$container\033[0m from \033[35m$foldrdir\033[0m mapped to \033[33m$urlrule\033[0m..."
return
docker run --name $container -v $PWD/$foldrdir:/usr/share/nginx/html:ro -d -l "traefik.enable=true" -l "traefik.backend=$container-static" -l "traefik.frontend.rule=Host:$urlrule" --network traefik_proxy nginx
