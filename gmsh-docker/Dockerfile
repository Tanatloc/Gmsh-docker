FROM ubuntu

MAINTAINER Simon Garnotel "simon.garnotel@airthium.com"

# Update
RUN apt-get update

# Upgrade
RUN apt-get upgrade -y && apt-get clean

# Install dependencies
RUN apt-get install -y \
	liblapack-dev \
	tcl8.6-dev \
	tk8.6-dev

# Copy gmsh repository
RUN mkdir /usr/opencascade
ADD gmsh-compiled /usr/opencascade
RUN mkdir /usr/gmsh
ADD gmsh-compiled /usr/gmsh

# Add Gmsh to bashrc
RUN touch /root/.bash_aliases \
	&& echo "alias gmsh='/usr/gmsh/bin/gmsh'" > /root/.bash_aliases

ENV GLOB *.geo
CMD ["bash", "-c", "ls /data/$GLOB | xargs -I {} /usr/gmsh/bin/gmsh -3 {}"]
