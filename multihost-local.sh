#!/bin/bash

set -e

# Docker Machine Setup
docker-machine create \
	-d virtualbox \
	--virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc1/boot2docker.iso \
	mhl-consul

docker $(docker-machine config mhl-consul) run -d \
	-p "8500:8500" \
	-h "consul" \
	progrium/consul -server -bootstrap
	
docker-machine create \
	-d virtualbox \
	--virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc1/boot2docker.iso \
        --engine-opt="cluster-store=consul://$(docker-machine ip mhl-consul):8500" \
	mhl-demo0

docker-machine create \
	-d virtualbox \
      	--virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc1/boot2docker.iso \
	--engine-opt="cluster-store=consul://$(docker-machine ip mhl-consul):8500" \
        mhl-demo1

# Workaround for https://github.com/docker/docker/issues/17047

docker-machine ssh mhl-demo0 'sudo sh -c "set -ex; /etc/init.d/docker stop || true; sed -i '\''5i     --cluster-advertise='$(docker-machine ip mhl-demo0)':0\"'\'' /var/lib/boot2docker/profile; /etc/init.d/docker start"'
docker-machine ssh mhl-demo1 'sudo sh -c "set -ex; /etc/init.d/docker stop || true; sed -i '\''5i     --cluster-advertise='$(docker-machine ip mhl-demo1)':0\"'\'' /var/lib/boot2docker/profile; /etc/init.d/docker start"'

# Create an overlay network
docker $(docker-machine config mhl-demo0) network create -d overlay my-net

# It's on both hosts!
docker $(docker-machine config mhl-demo0) network ls
docker $(docker-machine config mhl-demo1) network ls

# Let's try it out
docker $(docker-machine config mhl-demo0) run -itd --net=my-net --name=web nginx
docker $(docker-machine config mhl-demo1) run -it --rm --net=my-net busybox wget -O- http://web
