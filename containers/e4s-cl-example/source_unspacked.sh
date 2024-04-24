#!/bin/bash

<< UNSPACKING
                                  _    _       _
 _   _ _ __  ___ _ __   __ _  ___| | _(_)_ __ ( )
| | | | '_ \/ __| '_ \ / _' |/ __| |/ / | '_ \|/
| |_| | | | \__ \ |_) | (_| | (__|   <| | | | |
 \__,_|_| |_|___/ .__/ \__,_|\___|_|\_\_|_| |_|
                |_|

This script is a step on the way to convert spack calls (https://spack.io)
to pure enviroment manipulation equivalents. Run this script in an enviroment
with spack accessible and it will overwrite itself with an 'unspacked'
version of the input.
UNSPACKING

# If the original script had a spack source directive, we'll start with it
. /spack/share/spack/setup-env.sh

# Check that spack is either loaded or available
if [ $? -ne 0 ] || ! type spack &>/dev/null ; then
    echo "spack not found, aborting script creation" >&2
    exit 1
fi

# Avoid contamination by unloading all packages first
spack unload

# Output file; will then be sourced and overwrite this file
BUFFER=$(mktemp --suffix=.sh -q)
BUFFER=${BUFFER:=.unspacked.sh.tmp}

# The path towards this script; use BASH_SOURCE in case we are being sourced
THIS=${BASH_SOURCE[0]}

# The template of load_fff functions
__unspacked_rs_compile() { cat <<- EOF >> $BUFFER
	$HASH() {
	# Output of '$@'
	$($@)
	}

EOF

# Once the call has been staged, execute it for the next staging to be in a
# genuine environment
$(echo "$@" | sed -e 's:--sh::g')
};

# Heredoc for the rest of the script to put in the final script
read -r -d '' SCRIPT <<'UNSPACKING_VERY_SPECIAL_HEREDOC'
load_59046c6b9057c4ee54f3d23317713a05e1e1415fcad47be0b92a9e38433c2f8d

# vim: nowrap
UNSPACKING_VERY_SPECIAL_HEREDOC

HASH=load_59046c6b9057c4ee54f3d23317713a05e1e1415fcad47be0b92a9e38433c2f8d __unspacked_rs_compile spack load --sh --first trilinos@13.0.1 %gcc

echo -e "$SCRIPT" >> $BUFFER

source $BUFFER
mv $BUFFER $THIS

