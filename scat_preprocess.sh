#! /bin/bash

VOCAB_SIZE=32000
#DATA_DIR=./data/scat

# TODO: change paths as needed
DATA_DIR=repro/contextual-mt/data/scat

# TODO: change paths as needed
mkdir ./data/scat/prep
mkdir ./data/scat/bin
mkdir ./data/scat/bin_context

for lang in en fr; do
    python ./scripts/spm_train.py \
        $DATA_DIR/highlighted.train.${lang} \
        --model-prefix $DATA_DIR/prep/spm.${lang} \
        --vocab-file $DATA_DIR/prep/dict.${lang}.txt \
        --vocab-size $VOCAB_SIZE
done
for split in highlighted.train highlighted.valid highlighted.test highlighted.train.context highlighted.valid.context highlighted.test.context; do
    for lang in en fr; do
        python ./scripts/spm_encode.py \
            --model $DATA_DIR/prep/spm.$lang.model \
                < $DATA_DIR/${split}.${lang} \
                > $DATA_DIR/prep/${split}.sp.${lang}
    done
done

fairseq-preprocess \
    --source-lang en --target-lang fr \
    --trainpref $DATA_DIR/prep/highlighted.train.context.sp \
    --validpref $DATA_DIR/prep/highlighted.valid.context.sp \
    --testpref $DATA_DIR/prep/highlighted.test.context.sp \
    --srcdict $DATA_DIR/prep/dict.en.txt \
    --tgtdict $DATA_DIR/prep/dict.fr.txt \
    --destdir $DATA_DIR/bin_context

fairseq-preprocess \
    --source-lang en --target-lang fr \
    --trainpref $DATA_DIR/prep/highlighted.train.sp \
    --validpref $DATA_DIR/prep/highlighted.valid.sp \
    --testpref $DATA_DIR/prep/highlighted.test.sp \
    --srcdict $DATA_DIR/prep/dict.en.txt \
    --tgtdict $DATA_DIR/prep/dict.fr.txt \
    --destdir $DATA_DIR/bin


