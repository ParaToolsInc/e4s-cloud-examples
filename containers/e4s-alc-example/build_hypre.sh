#!/bin/bash

in_path () {
  type "$1" >/dev/null 2>/dev/null
}

### Set up e4s-alc to be used ###
if ! in_path e4s-alc ; then
  spack load --first e4s-alc
  E4S_ALC=`spack location -i --first e4s-alc`/bin/e4s-alc
else
  E4S_ALC=$(which e4s-alc)
fi

### Pulling image and writing the definition file ###
$E4S_ALC create -f hypre-build-specs.yaml
ls $HOME/.e4s-alc/singularity_images
sed -i -e 's/curl https/curl -k https/' singularity.def
cat singularity.def

### Building the new image ###
singularity build --fakeroot ubuntu24.04_hypre.sif singularity.def


