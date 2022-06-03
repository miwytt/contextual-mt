#! /bin/bash

mkdir ../reqs
cd ../reqs

# required packages for contextual-mt:
# Fairseq >= add65ad
# SentencePiece >= 0.1.90
# COMET

# ensure that pip is current 
pip install --upgrade pip

# install fairseq
#  + required packages for fairseq
pip install tensorboardX

#pip install torch==1.10.0 torchvision==0.11.2 torchaudio==0.10.1

git clone https://github.com/pytorch/fairseq
cd fairseq

# for mac
#CFLAGS="-stdlib=libc++" pip install --editable ./

# for everything else
pip install --editable ./

# go pack to reqs folder (path has to be adjusted)
cd ..

# sentence piece
pip install sentencepiece

# comet
## has to be done in a later step since torch reqs don't work out
#  + required packages for comet
pip install pandas==1.1.5
pip install transformerssacrebleu>=2.0.0 # installation has not worked – check if actually necessary
pip install pytorch-lightning==1.6.0
pip install jsonargparse==3.13.1
#pip install numpy>=1.20.0
pip install torchmetrics
#>=0.7
#pip install sacrebleu>=2.0.0
pip install scipy
#>=1.5.4

#pip install unbabel-comet


# bawden repo for paths needed on ducttape
# git clone https://github.com/miwytt/discourse-mt-test-sets

# since python3.9 some google cloud client libraries break, that's why the following is needed to downgrade protobuf 
pip install protobuf==3.20.1


# to monitor what is happening with GPUs
pip install gpustat



# TODO: adjust path as needed
cd ./contextual-mt


# cloning the contextual-mt repository and installing the project (adjust the link if new fork was created)
echo "install the project in editable mode:"
echo "cd ./contextual-mt && pip install -e ."
#git clone https://github.com/miwytt/contextual-mt.git
#cd ./contextual-mt
#pip install -e . # To have access to the entrypoints (such as the evaluation script) in your path

