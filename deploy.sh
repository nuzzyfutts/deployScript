#!/bin/bash

echo -e "\033[35mDirectory\033[0m (relative to working directory) of assets you want to serve?"
echo -e -n "\033[36;1m>\033[35m "
read folderDirectory

if [ ! -d $folderDirectory ]
then
	echo -e "\033[31mERROR:\033[0m The directory you specified does not exist!"
	exit 127
fi

echo -e "\033[0mOkay, I'll read from \033[35m$folderDirectory\033[0m."
echo -e "What do you want to\033[32m name the container\033[0m?"
echo -e -n "\033[36;1m>\033[32m "
read containerName

if docker ps -a --format '{{.Names}}' | grep -Eq "^${containerName}\$"; 
then
	echo -e "\033[31mERROR:\033[0m A container already exists with that name!"
	exit 1
fi

echo -e "\033[0mThe container will be named \033[32m$containerName\033[0m."
echo -e "What \033[33;1;4mURL\033[0m do you want to serve this site at? (frontend rule for traefik)"
echo -e -n "\033[36;1m> \033[33;1;4m"
read frontendURL

echo -e "\033[0m\033[34mCreating container...\033[0m"

docker run --name $containerName -v $PWD/$folderDirectory:/usr/share/nginx/html:ro -d -l "traefik.enable=true" -l "traefik.backend=$containerName-static" -l "traefik.frontend.rule=Host:$frontendURL" --network traefik_proxy nginx

echo -e "\033[32mCreation successful!\033[0m"

echo -e "Asset Direcotry: \033[35;1m$folderDirectory\033[0m"
echo -e "Container Name: \033[32;1m$containerName\033[0m"
echo -e "URL: \033[33;1;4m$frontendURL\033[0m"

exit 0
