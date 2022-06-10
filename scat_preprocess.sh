#! /bin/bash

VOCAB_SIZE=100
#DATA_DIR=./data/scat

# TODO: change paths as needed
DATA_DIR=/Users/michelle/Desktop/cl/reproducibility_in_nlp/project/repro/contextual-mt/data/scat_short

# TODO: change paths as needed
mkdir ./data/scat_short/prep
mkdir ./data/scat_short/bin
mkdir ./data/scat_short/bin_context

#for lang in en fr; do
#    python ./scripts/spm_train.py \
#        $DATA_DIR/highlighted.train.${lang} \
#        --model-prefix $DATA_DIR/prep/spm.${lang} \
#        --vocab-file $DATA_DIR/prep/dict.${lang}.txt \
#        --vocab-size $VOCAB_SIZE
#done
#for split in highlighted.train highlighted.valid highlighted.test highlighted.train.context highlighted.valid.context #highlighted.test.context; do
#    for lang in en fr; do
#        python ./scripts/spm_encode.py \
#            --model $DATA_DIR/prep/spm.$lang.model \
#                < $DATA_DIR/${split}.${lang} \
#                > $DATA_DIR/prep/${split}.sp.${lang}
#    done
#done

fairseq-preprocess \
    --source-lang en --target-lang fr \
    --trainpref $DATA_DIR/highlighted.train.context \
    --validpref $DATA_DIR/highlighted.valid.context \
    --testpref $DATA_DIR/highlighted.test.context \
    --destdir $DATA_DIR/bin_context

fairseq-preprocess \
    --source-lang en --target-lang fr \
    --trainpref $DATA_DIR/highlighted.train \
    --validpref $DATA_DIR/highlighted.valid \
    --testpref $DATA_DIR/highlighted.test \
    --destdir $DATA_DIR/bin


#