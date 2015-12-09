#!/bin/bash

PREFIX=$1
if [ -z "$PREFIX" ];
then
    PREFIX=$HOME
fi

error () {
    echo "Error: $@"
    exit 1
}

echo "Installing proot binary..."
curl -skL -o "bin/proot_x86_64" "http://portable.proot.me/proot-x86_64"
# Check that a binary was downloaded, not a text redirect
if [[ -f "bin/proot_x86_64" ]];
then
    chmod u+x "bin/proot_x86_64"
else
    error "Doesn't appear that proot_x86_64 was downloaded"
fi
# Check that a binary was downloaded, not a text redirect
ftype=$(echo $(file bin/proot_x86_64) | grep -o 'executable')
if [ "$ftype" != "executable" ];
then
    error "proot_x86_64 doesn't appear to be a binary"
fi

TACC_PROOT_BASE=$PREFIX/tacc-proot-data/
echo "User $USER data directory: $TACC_PROOT_BASE"
echo "$TACC_PROOT_BASE" > $HOME/.tacc-proot.rc
mkdir -p bin $TACC_PROOT_BASE/images $TACC_PROOT_BASE/tmp $TACC_PROOT_BASE/templates
echo "TACC_PROOT_BASE = $TACC_PROOT_BASE"

echo "Installing default images..."
echo "To update or change, edit $TACC_PROOT_BASE/registry.tsv and re-run bin/templates-install"

bin/templates-install registry.tsv
cp --backup registry.tsv $TACC_PROOT_BASE/
