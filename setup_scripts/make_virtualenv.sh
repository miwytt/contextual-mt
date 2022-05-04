#! /bin/bash

# virtualenv must be installed on your system, install with e.g.
#pip install virtualenv

setup_scripts=`dirname "$0"`
base=$setup_scripts/..

mkdir -p $base/venvs

# python3 needs to be installed on your system

python3 -m virtualenv -p python3 $base/venvs/dummy

echo "To activate your environment:"
echo "    source $base/venvs/dummy/bin/activate"
