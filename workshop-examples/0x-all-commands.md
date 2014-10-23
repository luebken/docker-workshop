Siehe auch: https://github.com/wsargent/docker-cheat-sheet

# Checking Docker installation
 * `docker version` Docker version information
 * `docker info` Information about the Docker installation
 * `docker help` Usage information

# Starting a container
* `docker run [OPTIONS] IMAGE [COMMAND] [ARG...]` Start a container with a command
* `docker run -i -t ubuntu /bin/bash` Start a bash in the ubuntu container and have it enabled to accept commands via STDIN 
* `docker ps` List running containers
* `docker ps -a` List all containers

# Stopping and restarting a container
* `docker stop CONTAINER` Stop a container (SIGTERM)
* `docker kill CONTAINER` Kill a container (SIGKILL)
* `docker run --name mycontainer -i -t ubuntu /bin/bash` Naming the container
* `docker start CONTAINER` Starting a stopped container by name or id

# Attaching
* `docker run -i -t --name mycontainer -d ubuntu /bin/bash -c "while true; do echo hello; sleep 1; done"` Start a container in the background with an endless loop
* `docker attach CONTAINER` Attaching to a container
* `Ctrl-p + Ctrl-q` Detach from a container

# Information about a container
* `docker logs --follow mycontainer` Show and follow STDOUT and STDERR
* `docker top mycontainer` Show running processes
* `docker inspect mycontainer` More information about a container

# Container management
* `docker rm CONTAINER` Remove a container
* `docker rm $(docker ps -a -q)` Remove all container

# Images
* `docker images` Available images on the host
* `docker rmi IMAGE` Delete an image
* `docker pull IMAGE` Pull an image from an repository
* `docker commit CONTAINER` Create a new image from a container's changes
* `docker diff CONTAINER` Inspect changes on a container's filesystem
* `docker history IMAGE` Show the history of an image
* `docker images -viz | dot -Tpng -o docker.png` dependency graph
* `docker build PATH` Build a new image from the source path


# A Dockerfile
```
FROM        ubuntu:14.04
MAINTAINER  Matthias Luebken <matthias@giantswarm.io>

# To manually trigger cache invalidation
ENV build_date 2014-09-01

RUN apt-get update
RUN apt-get install -y nginx

RUN echo 'Hello world' > /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
```

# Dockerfile instructions
* `FROM` the parent image
* `MAINTAINER` the maintainer of this Dockerfile (optional)
* `RUN <command>` run the command during build time with '/bin/sh -c'
* `RUN ["<command>", "<arg 1>", "<arg 2>"]` run the command during build time as is (exec format)
* `EXPOSE <port>` expose a specific port on the container
* `CMD ["<command>", "<arg 1>", "<arg 2>"]` run the commands when container is launched. Can be overwritten via the command line
* `ENTRYPOINT ["<command>", "<arg 1>", "<arg 2>"]` run the commands when container is launched. Command line args will be passed on.
* `WORKDIR <dir>` set the working directory for `RUN` and `CMD/ENTRYPOINT`
* `ENV <variable>` set environment variables
* `USER <user>` specifies the USER 
* `VOLUME ["<dir>"]` adds a volume to a container
* `ADD <files>` add files from the build environment into the image with tar extraction
* `COPY <files>` same as ADD without the extraction
* `ONBUILD <build instruction>` execute the instruction when child image is build


# Run options
* `docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
* `-i -t` Keep STDIN open attach a pseudo-TTY
* `-p <hostport>:<containerport` Publish a specfic port
* `-P` Publish all exposed ports to the host interfaces
* `-t` Tag a build
* `-d` Detached mode: run container in the background
* `-e` Set environment variables

# Linking container
* `docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
* `--name <name for a container``
* `--link <container name>:<alias>``

# Volume
* For persisted and shared data
* A special directory that bypasses the Union File System
* Volumes can be shared between containers
* Changes to a volume are immediate
* Volumes persist until no containers uses them