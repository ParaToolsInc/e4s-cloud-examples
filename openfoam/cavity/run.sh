#!/bin/bash
spack load --first openfoam
/bin/rm -f */log*
./Allrun


#Check for paraview in the path or paraview+qt from spack
command -v paraview &>/dev/null || spack load paraview+qt &>/dev/null

#Set the path to the paraview plugin directory, or quit
if base_path=$(dirname "$(dirname "$(command -v paraview 2>/dev/null)")"); then
    plugin_paths=("$base_path"/lib*/paraview-*)
else
    echo "Warning: Failed to find or load paraview executable. Visualization unavailable." >&2
    return 1 2>/dev/null || exit 1
fi

if [ -d "${plugin_paths[0]}" ]; then
    export PV_PLUGIN_PATH="${plugin_paths[0]}"
    echo "PV_PLUGIN_PATH set to: $PV_PLUGIN_PATH"
else
    echo "Warning: Found ParaView at '$base_path' but could not resolve its plugin path." >&2
fi


echo "cd cavity; paraFoam" 
cd cavity
paraFoam &
