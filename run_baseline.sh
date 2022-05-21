#! /bin/bash

#adjust this path
PATH_TO_DATA=/Users/michelle/Desktop/cl/reproducibility_in_nlp/project/try/contextual-mt/data/os18_preprocessed/projects/tir1/corpora/dialogue_mt/bin/
REPO=/Users/michelle/Desktop/cl/reproducibility_in_nlp/project/try/contextual-mt/contextual_mt/
TASK=document_translation
SRC_CONTEXT_SIZE=5
TGT_CONTEXT_SIZE=5


fairseq-train $PATH_TO_DATA \
    --user-dir $REPO \
    --task $TASK \
    --source-context-size $SRC_CONTEXT_SIZE --target-context-size $TGT_CONTEXT_SIZE \
    --sample-context-size \
    --coword-dropout 0.1 \
    --log-interval 10 \
    --arch contextual_transformer --share-decoder-input-output-embed  \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.1 \
    --lr 5e-4 --lr-scheduler inverse_sqrt  --warmup-updates 4000 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 --dropout 0.3 --weight-decay 0.0001 \
    --max-tokens  4096 --update-freq 8 --patience 10 --seed 42 \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-remove-bpe sentencepiece \
    --eval-bleu-print-samples \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --save-dir ./checkpoints --no-epoch-checkpoints 