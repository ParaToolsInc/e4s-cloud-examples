#!/bin/bash -e

M=https://cache.e4s.io/examples
for f in "output.e" ; do
  wget -q $M/$f
done
