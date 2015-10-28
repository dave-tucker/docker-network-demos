#!/bin/bash

set -e

# Docker Machine Setup
docker-machine create \
	-d virtualbox \
	--virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc1/boot2docker.iso \
	swl-consul

docker $(docker-machine config swl-consul) run -d \
	-p "8500:8500" \
	-h "consul" \
	progrium/consul -server -bootstrap
	
docker-machine create \
	-d virtualbox \
	--virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc1/boot2docker.iso \
	--swarm \
	--swarm-image="swarm:1.0.0-rc1" \
	--swarm-master \
	--swarm-discovery="consul://$(docker-machine ip swl-consul):8500" \
	 --engine-opt="cluster-store=consul://$(docker-machine ip swl-consul):8500" \
	swl-demo0

docker-machine create \
	-d virtualbox \
 	--virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc1/boot2docker.iso \
	--swarm \
	--swarm-image="swarm:1.0.0-rc1" \
	--swarm-discovery="consul://$(docker-machine ip swl-consul):8500" \
	--engine-opt="cluster-store=consul://$(docker-machine ip swl-consul):8500" \
        swl-demo1

# Workaround for https://github.com/docker/docker/issues/17047

docker-machine ssh swl-demo0 'sudo sh -c "set -ex; /etc/init.d/docker stop || true; sed -i '\''5i     --cluster-advertise='$(docker-machine ip swl-demo0)':0\"'\'' /var/lib/boot2docker/profile; /etc/init.d/docker start"'
docker-machine ssh swl-demo1 'sudo sh -c "set -ex; /etc/init.d/docker stop || true; sed -i '\''5i     --cluster-advertise='$(docker-machine ip swl-demo1)':0\"'\'' /var/lib/boot2docker/profile; /etc/init.d/docker start"'

