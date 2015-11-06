# docker-network-demos
Demos of Docker's New Networking

This repo contains a bunch of scripts for you to get started with Docker's new networking features 

## Pre-Requsites

These scripts assume the following

1) You have Docker Machine installed
2) You are using Docker 1.9 or later

Both of these components can be installed using the [Docker Toolbox](https://www.docker.com/docker-toolbox)

## What's what?

| Environment                            | Script Name          |
|----------------------------------------|----------------------|
| Multi-host Networking using Virtualbox | `multihost-local.sh` |
| Multi-host Networking using Amazon EC2 | `multihost-aws.sh`   |
| Swarm w/ Networking on Virtualbox      | `swarm-local.sh`     |
| Swarm w/ Networking on Amazon EC2      | `swarm-aws.sh`       |

## Adapting to your environment

So you want to use a different Docker Machine driver! Cool.
Here are some things you might want to know

- You can "borrow" the security group configuration from the AWS scripts
- You *MUST* check the interface name used for `cluster-advertise`. Pick the wrong name and your daemon won't start

## What to do next

Check out the [docs](http://docs.docker.com/engine/userguide/networking/dockernetworks/)
Have fun!

## Contributing?

Made changes? Want to contribute a new script for another cloud provider... or even for networking across clouds?
Raise a PR!

## License

Apache 2.0
https://www.apache.org/licenses/LICENSE-2.0.txt
