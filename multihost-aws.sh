#!/bin/bash

set -e

#### Set Up Environment

if [ -z $AWS_ACCESS_KEY_ID]; then
    echo "Please supply your AWS_ACCESS_KEY_ID"
    exit 1
fi
if [ -z $AWS_SECRET_ACCESS_KEY]; then
    echo "Please supply your AWS_ACCESS_KEY_ID"
    exit 1
fi

group_name="docker-networking"
my_ip="$(wget -q -O- http://icanhazip.com)"
# Get the AMI for your region from this list: https://wiki.debian.org/Cloud/AmazonEC2Image/Jessie
# Paravirtual only - HVM AMI's and Docker Machine don't seem to be working well together
export AWS_AMI="ami-971a65e0"
export AWS_DEFAULT_REGION="eu-west-1"
# This is my default VPC, yours will be different
export AWS_VPC_ID="vpc-69c9a10c"
export AWS_INSTANCE_TYPE="t1.micro"
export AWS_SSH_USER="admin"


#### Set up Security Group in AWS

aws ec2 create-security-group --group-name ${group_name} --description "A Security Group for Docker Networking"
# Permit SSH, required for Docker Machine
aws ec2 authorize-security-group-ingress --group-name ${group_name} --protocol tcp --port 22 --cidr ${my_ip}/32
aws ec2 authorize-security-group-ingress --group-name ${group_name} --protocol tcp --port 2376 --cidr ${my_ip}/32
# Permit Serf ports for discovery
aws ec2 authorize-security-group-ingress --group-name ${group_name} --protocol tcp --port 7946 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name ${group_name} --protocol udp --port 7946 --cidr 0.0.0.0/0
# Permit Consul HTTP API
aws ec2 authorize-security-group-ingress --group-name ${group_name} --protocol tcp --port 8500 --cidr 0.0.0.0/0
# Permit VXLAN
aws ec2 authorize-security-group-ingress --group-name ${group_name} --protocol udp --port 4789 --cidr 0.0.0.0/0

##### Docker Machine Setup

docker-machine create \
    -d amazonec2 \
    --engine-install-url=https://test.docker.com \
    --amazonec2-security-group ${group_name} \
    mha-consul

docker $(docker-machine config mha-consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

docker-machine create \
    -d amazonec2 \
    --amazonec2-security-group ${group_name} \
    --engine-install-url=https://test.docker.com \
    --engine-opt="cluster-store=consul://$(docker-machine ip mha-consul):8500" \
    --engine-opt="cluster-advertise=eth0:0" \
    mha-demo0

docker-machine create \
    -d amazonec2 \
    --amazonec2-security-group ${group_name} \
    --engine-install-url=https://test.docker.com \
    --engine-opt="cluster-store=consul://$(docker-machine ip mha-consul):8500" \
    --engine-opt="cluster-advertise=eth0:0" \
    mha-demo1
