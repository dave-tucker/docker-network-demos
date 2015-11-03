#!/bin/bash

set -e

# Docker Machine Setup
docker-machine create \
    -d virtualbox \
    mhl-consul

docker $(docker-machine config mhl-consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

docker-machine create \
    -d virtualbox \
    --engine-opt="cluster-store=consul://$(docker-machine ip mhl-consul):8500" \
    --engine-opt="cluster-advertise=eth1:0" \
    mhl-demo0

docker-machine create \
    -d virtualbox \
    --engine-opt="cluster-store=consul://$(docker-machine ip mhl-consul):8500" \
    --engine-opt="cluster-advertise=eth1:0" \
    mhl-demo1
