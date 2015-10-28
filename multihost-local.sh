#!/bin/bash

set -e

# Docker Machine Setup
docker-machine create \
    -d virtualbox \
    --virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc3/boot2docker.iso \
    mhl-consul

docker $(docker-machine config mhl-consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

docker-machine create \
    -d virtualbox \
    --virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc3/boot2docker.iso \
    --engine-opt="cluster-store=consul://$(docker-machine ip mhl-consul):8500" \
    --engine-opt="cluster-advertise=eth1:0" \
    mhl-demo0

docker-machine create \
    -d virtualbox \
    --virtualbox-boot2docker-url https://github.com/tianon/boot2docker-legacy/releases/download/v1.9.0-rc3/boot2docker.iso \
    --engine-opt="cluster-store=consul://$(docker-machine ip mhl-consul):8500" \
    --engine-opt="cluster-advertise=eth1:0" \
    mhl-demo1
