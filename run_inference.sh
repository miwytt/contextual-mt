#! /bin/bash

DATA_DIR=./data/os18/bin
#if bin does not work use the following:
#DATA_DIR=./data/os18/prep

#checkpoints for baseline
CHECKPOINT_DIR=./checkpoints_baseline
#checkpoints for attnreg
#CHECKPOINT_DIR=./checkpoints_attnreg

# do gold if time
#PREDICTION_DIR=./predictions_baseline_gold
PREDICTION_DIR=./predictions_baseline_nongold
#PREDICTION_DIR=./predicitons_attnreg_gold
PREDICTION_DIR=./predictions_attnreg_nongold

python contextual_mt/docmt_translate.py \
    --path $CHECKPOINT_DIR \
    --source-lang en --target-lang fr \
    --source-file $DATA_DIR/test.en \
    --predictions-file $PREDICTION_DIR/test.pred.en \
    --docids-file $DATA_DIR/test.docids \
    --beam 5
#do gold if time    
#--gold-target-context
