# docker-zeppelin-cn

Basic and clean [Docker](https://www.docker.com/what-docker) image for the chinesization of [Apache Zeppelin](http://zeppelin.apache.org), based on [Alpine](http://alpinelinux.org) and [OpenJDK](http://openjdk.java.net)

                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o Zeppelin  __/
             \    \         __/
              \____\_______/

# Overview

Dockerized single-host Zeppelin.

Deployment options out of the box:
- Standalone Zeppelin node

# Exposed ports

- 8080 - Zeppelin web application port
- 8443 - Zeppelin web application secure port

# Volumes

All below volumes can be mounted to docker host machine folders or shared folders to easy maintain data inside them. 

Zeppelin-specific:
- /opt/zeppelin/conf
- /opt/zeppelin/logs
- /opt/zeppelin/notebook
- /opt/zeppelin/local-repo
- /opt/zeppelin/helium

# Official Documentation and Guides

- [Overview](http://zeppelin.apache.org/docs/0.7.03)
- [Quick Start](http://zeppelin.apache.org/docs/0.7.3/install/install.html)
- [Interpreters](http://zeppelin.apache.org/docs/0.7.3/manual/interpreters.html)
- [Wiki](https://cwiki.apache.org/confluence/display/ZEPPELIN/Zeppelin+Home)

# Usage

This image can either be used as a base image for building on top of NiFi or just to experiment with. I personally have not attempted to use this in a production use case.

Please use corresponding branches from this repo to play with code.

# Pre-Requisites
Ensure the following pre-requisites are met (due to some blocker bugs in earlier versions). As of today, the latest Docker Toolbox and Homebrew are fine.

- Docker 1.10+

(all downloadable as a single [Docker Toolbox](https://www.docker.com/products/docker-toolbox) package as well)

# How to use from Docker CLI

1. Start Docker Quickstart Terminal
2. Run command  `docker run -d -p 8080:8080 -p 8443:8443 --name zeppelin lonly/docker-zeppelin-cn:0.7.3`
3. Check Docker Container Running Status  `docker ps -a`
4. Use IP from previous step in address bar of your favorite browser, e.g. ` http://192.168.1.1:8080/#/`

# Contact me

- Email: <lonly197@gamil.com>
