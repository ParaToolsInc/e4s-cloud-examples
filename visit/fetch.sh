#!/bin/bash -e

M=https://cache.e4s.io/examples
for f in "example.silo" "visit.nc" ; do
  wget -q $M/$f
done
