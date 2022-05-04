#! /bin/bash

setup_scripts=`dirname "$0"`
base=$setup_scripts/..

#tools=$base/tools
#mkdir -p $tools

echo "Make sure this script is executed AFTER you have activated a virtualenv"

# requires Python >= 3.6
# install required packages

pip install fairseq

pip install sentencepiece

pip install --upgrade pip  # ensures that pip is current 
pip install unbabel-comet

# in order to run ducttapes
wget http://www.cs.cmu.edu/~jhclark/downloads/ducttape-0.3.tgz
tar -xvzf ducttape-0.3.tgz
cd ducttape 0.3
export PATH=$PWD/ducttape-0.3:$PATH
cd ducttape-0.3/tutorial
ducttape 01-01-hello-world.tape

# Also run
cd ../../
cd ./contextual-mt
pip install -e .

# To have access to the entrypoints (such as the evaluation script) in your path

