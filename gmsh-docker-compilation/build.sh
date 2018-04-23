#!/usr/bin/env bash

## Get opencascade
wget https://www.dropbox.com/s/zbqlp2i2kmwwkiy/opencascade-7.2.0.tgz?dl=0

## Build the docker for Gmsh compilation
echo -e "> Building the compiled version of Gmsh"
sudo docker build --network=host --tag gmsh:compilation .
