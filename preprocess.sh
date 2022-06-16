#! /bin/bash

VOCAB_SIZE=32000


# TODO: change paths as needed
DATA_DIR=./data/os18

# TODO: change paths as needed
mkdir ./data/os18/prep

for lang in en fr; do
    python ./scripts/spm_train.py \
        $DATA_DIR/train.${lang} \
        --model-prefix $DATA_DIR/prep/spm.${lang} \
        --vocab-file $DATA_DIR/prep/dict.${lang}.txt \
        --vocab-size $VOCAB_SIZE
done
for split in train valid test; do
    for lang in en fr; do
        python ./scripts/spm_encode.py \
            --model $DATA_DIR/prep/spm.$lang.model \
                < $DATA_DIR/${split}.${lang} \
                > $DATA_DIR/prep/${split}.sp.${lang}
    done
done

fairseq-preprocess \
    --source-lang en --target-lang fr \
    --trainpref $DATA_DIR/prep/train.sp \
    --validpref $DATA_DIR/prep/valid.sp \
    --testpref $DATA_DIR/prep/test.sp \
    --srcdict $DATA_DIR/prep/dict.en.txt \
    --tgtdict $DATA_DIR/prep/dict.fr.txt \
    --destdir $DATA_DIR/bin
