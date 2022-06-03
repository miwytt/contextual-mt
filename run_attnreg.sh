#! /bin/bash

# adjust this path to lead to split and binarized data as well as docids
PATH_TO_DATA=./data/os18/bin/
# path to repo has to be at the right level otherwise fairseq tasks won't be recognized
REPO=./contextual_mt/
TASK=attention_regularization
SRC_CONTEXT_SIZE=5
TGT_CONTEXT_SIZE=5


fairseq-train $PATH_TO_DATA \
    --user-dir $REPO \
    --task $TASK \
    --source-context-size $SRC_CONTEXT_SIZE --target-context-size $TGT_CONTEXT_SIZE \
    --source-lang en --target-lang fr \
    --log-interval 10 \
    --arch attn_reg_transformer --share-decoder-input-output-embed  \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.1 \
    --lr 5e-4 --lr-scheduler inverse_sqrt  --warmup-updates 4000 \
    --criterion attention_loss --label-smoothing 0.1 --dropout 0.3 --weight-decay 0.0001 \
    --regularize-heads 0 --regularize-attention enc cross self \
    --enc-alignment-layer 0 --cross-alignment-layer 0 --self-alignment-layer 5 \
    --highlight-sample 0.2 --kl-lambda 10 \
    --max-tokens  4096 --max-tokens-valid 1024 --update-freq 8 --seed 42 \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-remove-bpe sentencepiece \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --save-dir ./checkpoints_attnreg --no-epoch-checkpoints \
