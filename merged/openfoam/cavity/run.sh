#!/bin/bash
source /usr/lib/openfoam/openfoam2306/etc/bashrc
/bin/rm -f */log*
./Allrun
echo "cd cavity; paraFoam" 
cd cavity
paraFoam &
