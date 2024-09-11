#!/bin/bash

### Set up e4s-alc to be used ###
spack load --first e4s-alc
E4S_ALC=`spack location -i --first e4s-alc`/bin/e4s-alc

### Pulling image and writing the definition file ###
$E4S_ALC create -f hypre-build-specs.yaml
ls $HOME/.e4s-alc/singularity_images
sed -i -e 's/curl https/curl -k https/' singularity.def
cat singularity.def

### Building the new image ###
singularity build --fakeroot ubuntu20.04_hypre.sif singularity.def


