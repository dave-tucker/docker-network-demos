#!/bin/bash

set -e

# Docker Machine Setup
docker-machine create \
    -d virtualbox \
    --virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc3/boot2docker.iso \
    swl-consul

docker $(docker-machine config swl-consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

docker-machine create \
    -d virtualbox \
    --virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc3/boot2docker.iso \
    --virtualbox-disk-size 50000 \
    --swarm \
    --swarm-image="swarm:1.0.0-rc2" \
    --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip swl-consul):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip swl-consul):8500" \
    --engine-opt="cluster-advertise=eth1:0" \
    swl-demo0

docker-machine create \
    -d virtualbox \
    --virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc3/boot2docker.iso \
    --virtualbox-disk-size 50000 \
    --swarm \
    --swarm-image="swarm:1.0.0-rc2" \
    --swarm-discovery="consul://$(docker-machine ip swl-consul):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip swl-consul):8500" \
    --engine-opt="cluster-advertise=eth1:0" \
    swl-demo1
