#!/bin/bash
spack load --first openfoam
/bin/rm -f */log*
./Allrun
echo "cd cavity; paraFoam" 
cd cavity
paraFoam &
