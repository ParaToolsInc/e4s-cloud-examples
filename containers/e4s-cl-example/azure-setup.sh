#!/bin/bash

E4SCL=$(spack find --format /{hash:7} e4s-cl | head -c7)
PYTHON_HASH=$(spack dependencies -it ${E4SCL} | grep python@ | cut -d' ' -f1)
export PATH=$(spack location -i /$PYTHON_HASH)/bin:$PATH
export PYTHONPATH=$(spack load --sh ${E4SCL} | grep PYTHONPATH | cut -d= -f2)
export PATH=$(spack location -i ${E4SCL})/bin:$PATH
which e4s-cl

e4s-cl --print-config > ~/.config/e4s-cl.yaml

sed -i 's/preload_root_libraries: true/preload_root_libraries: false/g' ~/.config/e4s-cl.yaml
