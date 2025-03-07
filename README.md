# Reproduction

This part is not part of the original README by neulab. For that, please refer to everything below "Contextual MT".

This part serves as step-by-step report of a reimplementation attempt of a subset of the experiments described in the following paper using the publicly provided code by its authors:

[Do Context-Aware Translation Models Pay the Right Attention?](https://arxiv.org/abs/2105.06977)

The reproduction includes preprocessing the SCAT (Yin et al., 2021) and OpenSubtitles2018 (en-fr) (Lison et al., 2018) datasets, training a context-aware machine translation model, training an attention regularized context-aware machine translation model on said datasets, running inference and evaluating both with the automatic translation evaluation metrics BLEU and COMET. The steps below should facilitate further reproductions of the experiments by Yin et al.

The reproduction was done in a Python==3.8 environment.

After activation of the virtual environment, forking, cloning and installation of the project, the shell scripts can be run in the following order:

1. install_packages.sh
2. get_and_split_data.sh
3. preprocess.sh
4. run_baseline.sh
5. scat_preprocess.sh
6. run_attnreg.sh
7. run_inference.sh (once for baseline with adapted path)
8. run_inference.sh (once for attn_reg with adapted path)
9. install [COMET](https://github.com/Unbabel/COMET)
10. run_evaluation (once for baseline with adapted path)
11. run_evaluation (once for attn_reg with adapted path)


Furthermore, a clean subset of the OpenSubtitles2018 (Lison et al., 2018) data, which is currently not available publicly, has to be placed at .data/os18/. Additionaly, pathnames have to be adapted according to the setup and filenames resulting from 5. scat_preprocess.sh have to be adapted and moved to .data/os18/bin/ to continue.

## References

Pierre Lison, Jörg Tiedemann, and Milen Kouylekov. 2018. OpenSubtitles2018: Statistical rescoring of sentence
alignments in large, noisy parallel corpora. In Proceedings of the Eleventh International Conference on Language
Resources and Evaluation (LREC 2018), Miyazaki, Japan. European Language Resources Association (ELRA).

Kayo Yin, Patrick Fernandes, Danish Pruthi, Aditi Chaudhary, André F. T. Martins, and Graham Neubig. 2021b. Do
Context-Aware Translation Models Pay the Right Attention? In Joint Conference of the 59th Annual Meeting of
the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language
Processing (ACL-IJCNLP).




# Contextual  MT

Implementations of context-aware models for document-level translation tasks, used in 

1. [Measuring and Incresing Context Usage in Context-Aware Machine Translation](https://arxiv.org/abs/2105.03482)
2. [Do Context-Aware Translation Models Pay the Right Attention?](https://arxiv.org/abs/2105.06977)

Currently supports:

* Training concatenation-based document-level machine translation models
* Training with CoWord dropout and dynamic context size
* Measuring CXMI for models 
* Training with attention regularization


## Requirements 

* [Fairseq](https://github.com/pytorch/fairseq) >= [add65ad](https://github.com/pytorch/fairseq/commit/add65adcc53a927f99a717d90a9672765237d937)
* [SentencePiece](https://github.com/google/sentencepiece) >= 0.1.90
* [COMET](https://github.com/Unbabel/COMET)
* Python >= 3.6

Also run 

```bash
pip install -e .
```

To have access to the entrypoints (such as the evaluation script) in your path

## Pre-processing

Preprocessing consists of training a SentencePiece model and binarizing the data
To preprocess a set of files `{train,valid,test}.{src,tgt}` run

An example prerpocessing would be

```bash
VOCAB_SIZE=32000

for lang in en fr; do
    python $REPO/scripts/spm_train.py \
        ${data_dir}/train.${lang} \
        --model-prefix ${data_dir}/prep/spm.${lang} \
        --vocab-file ${data_dir}/prep/dict.${lang}.txt \
        --vocab-size $VOCAB_SIZE
done
for split in train valid test; do
    for lang in en fr; do
        python $REPO/scripts/spm_encode.py \
            --model ${data_dir}/prep/spm.$lang.model \
                < ${data_dir}/${split}.${lang} \
                > ${data_dir}/prep/${split}.sp.${lang}
    done
done
fairseq-preprocess \
    --source-lang src --target-lang tgt \
    --trainpref ${data_dir}/prep/train.sp \
    --validpref ${data_dir}/pep/valid.sp \
    --testpref ${data_dir}/prep/test.sp \
    --srcdict ${data_dir}/prep/dict.src.txt \
    --tgtdict ${data_dir}/prep/dict.tgt.txt \
    --destdir ${data_dir}/bin
```

In addition, this repo already includes some scripts to preprocess some dataset. Please refer to `scripts/data`

## Training

### Document-level translation

You can train using fairseq's training tool. Just select the `document_translation` task with the approriate context sizes.

For example, to train a model, with `N` source context size and `M` target context size, with dynamic sampling and CoWord dropout

```bash
fairseq-train \
    ${bin_dir} --user-dir $REPO/contextual_mt \
    --task document_translation \
    --source-context-size $N --target-context-size $M \
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
    --save-dir ${checkpoint_dir} --no-epoch-checkpoints
```

To apply attention regularization during training, select the `attention_regularization` task:

```bash
fairseq-train \
    ${bin_dir} --user-dir $REPO/dialogue_mt \
    --task attention_regularization \
    --source-context-size $N --target-context-size $M \
    --source-lang en --target-lang fr \
    --log-interval 10 \
    --arch attn_reg_transformer --share-decoder-input-output-embed  \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.1 \
    --lr 5e-4 --lr-scheduler inverse_sqrt  --warmup-updates 4000 \
    --criterion attention_loss --label-smoothing 0.1 --dropout 0.3 --weight-decay 0.0001 \
    --regularize-heads 0 --regularize-attention enc cross self \
    --enc-alignment-layer --cross-alignment-layer 0 --self-alignment-layer 5 \
    --highlight-sample 0.2 --kl-lambda 10 \
    --max-tokens  4096 --max-tokens-valid 1024 --update-freq 8 --seed 42 \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-remove-bpe sentencepiece \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --save-dir ${checkpoint_dir} --no-epoch-checkpoints
```

## Inference and Evaluation

You can then run inference

```bash
cp ${data_dir}/dict.*txt ${data_dir}/spm* $CHECKPOINTS_DIR

python contextual_mt/docmt_translate.py \
    --path $checkpoint_dir \
    --source-lang src --target-lang tgt \
    --source-file ${data_dir}/test.src \
    --predictions-file ${predictions_dir}/test.pred.tgt \
    --docids-file ${data_dir}/test.docids \

    --beam 5 
```

To score the predictions, a helper script is provided

```bash
python scripts/score.py ${predictions_dir}/test.pred.tgt ${data_dir}/test.tgt \
    --src ${data_dir}/test.src \
    --comet-model wmt-large-da-estimator-1719 \
    --comet-path $COMET_DIR
```

## Measuring CXMI

To measure the CXMI for a model with a specific context size, run:

```bash
python contextual_mt/docmt_cxmi.py \
    --path $checkpoint_dir \
    --source-lang src --target-lang tgt \
    --source-file ${data_dir}/test.src \
    --reference-file ${data_idr}/test.tgt \
    --docids-file ${data_dir}/test.docids \
    --source-context-size $N \
    --target-context-isze $M
```

For the more detailed analyises, please refer to the notebook `notebooks/measuring_context_usage.ipynb`

## Contrastive evaluation

To run contrastive evaluation on ContraPro or Bawden's dataset

```bash
python contextual_mt/docmt_contrastive_eval.py \
    --source-lang src --target-lang tgt \
    --source-file $source_contr \
    --src-context-file $source_ctx_contr \
    --target-file $target_contr \
    --tgt-context-file $target_ctx_contr
```

# Workflows

To facilitate reproducing the paper results, we include files to run the whole trainign and evaluation pipelines.

Start by install [ducttape](https://github.com/jhclark/ducttape). 

## *Measuring and Increasing Context Usage*

Start by modifying the relevant paths in `tapes/cxmi_paper.tconf`. 
Also modify the `submitter` to the one best suited for you system. 
The original work used the `slurm` submitter.

```
ducttape tapes/cxmi_paper.tape -C tapes/cxmi_paper.tconf -j $num_parallel_jobs
```

To obtain a summary of the experimental results, run
```
ducttape tapes/cxmi_paper.tape -C tapes/cxmi_paper.tconf summary
```
