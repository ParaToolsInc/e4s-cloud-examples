#!/bin/bash
spack load --first e4s-alc
E4S_ALC=`spack location -i --first e4s-alc`/bin/e4s-alc
#$E4S_ALC init -b singularity
$E4S_ALC create -f kokkos-build-specs.json
ls $HOME/.e4s-alc/singularity_images
