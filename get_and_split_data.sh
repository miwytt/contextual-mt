#! /bin/bash

#mkdir ./data/os18_preprocessed
# TODO: change paths as needed
cd ./data/

# has to be downloaded in the browser because of access permission
# gdown https://drive.google.com/u/0/uc?id=1N983AKGK00WrG8_9bGfgRMhSKN8ABG1c&export=download

# open tar with clean data
tar -xvf os18-enfr.tar

# TODO: change paths as needed
cd ./projects/tir1/corpora/dialogue_mt/aligned-os18-enfr

# split english data
head -n 16079288  OpenSubtitles.en-fr.aligned.en > train.en
sed -n '16079289,16089324p' OpenSubtitles.en-fr.aligned.en > valid.en
tail -n 10036 OpenSubtitles.en-fr.aligned.en > test.en

# split french data
head -n 16079288  OpenSubtitles.en-fr.aligned.fr > train.fr
sed -n '16079289,16089324p' OpenSubtitles.en-fr.aligned.fr > valid.fr
tail -n 10036 OpenSubtitles.en-fr.aligned.fr > test.fr

# split ids 
head -n 16079288  OpenSubtitles.en-fr.aligned.ids > train.ids
sed -n '16079289,16089324p' OpenSubtitles.en-fr.aligned.ids > valid.ids
tail -n 10036 OpenSubtitles.en-fr.aligned.ids > test.ids

cd ../../