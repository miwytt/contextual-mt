#! /bin/bash

DATA_DIR=./data/os18/bin_actual
# eval baseline with gold data
#PREDICTION_DIR=./predictions_baseline_gold
# eval baseline with non gold data
#PREDICTION_DIR=./predictions_baseline_nongold
# eval attnreg with gold data
PREDICTION_DIR=./predictions_attnreg_gold
# eval attnreg with non gold
#PREDICTION_DIR=./predictions_attnreg_nongold
COMET_DIR=python3.8/site-packages/unbabel_comet-1.0.0rc8.dist-info/

python scripts/score.py $PREDICTION_DIR/test.pred.fr $DATA_DIR/test.fr \
       	--src $DATA_DIR/test.en \
       	--comet-model wmt20-comet-da \
	--comet-path $COMET_DIR 
