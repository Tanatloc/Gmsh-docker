#!/usr/bin/env bash

## Build the docker for FreeFEM compilation
echo -e "> Building Gmsh Docker image"
sudo docker build --network=host --tag gmsh .
