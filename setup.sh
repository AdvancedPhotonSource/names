#!/bin/bash

# Copyright (c) UChicago Argonne, LLC. All rights reserved.
# See LICENSE file.


# NAMES setup script for Bourne-type shells
# This file is typically sourced in user's .bashrc file

if [ -n "$BASH_SOURCE" ]; then
  input_param=$BASH_SOURCE
elif [ -n "$ZSH_VERSION" ]; then
  setopt function_argzero
  input_param=$0
else
  echo 1>&2 "Unsupported shell. Please use bash or zsh."
  exit 2
fi

myDir=`dirname $input_param`

currentDir=`pwd` && cd $myDir
if [ ! -z "$NAMES_ROOT_DIR" -a "$NAMES_ROOT_DIR" != `pwd` ]; then
    echo "WARNING: Resetting NAMES_ROOT_DIR environment variable (old value: $NAMES_ROOT_DIR)" 
fi
export NAMES_ROOT_DIR=`pwd`

if [ -z $NAMES_INSTALL_DIR ]; then
    export NAMES_INSTALL_DIR=$NAMES_ROOT_DIR/..
    if [ -d $NAMES_INSTALL_DIR ]; then
        cd $NAMES_INSTALL_DIR
        export NAMES_INSTALL_DIR=`pwd`
    fi
fi