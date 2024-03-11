#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_bde
train_path=../data/bde/train.csv
val_path=../data/bde/val.csv
test_path=../data/bde/test.csv

#Hyperparameter optimization
# chemprop hyperopt \
-t regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $val_path \
--num-iters 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hyperopt-checkpoint-dir $results_dir \
--log-dir $results_dir \
--adding-h \
--is-atom-bond--targets \
--no-shared-atom-bond-ffn \
--no-adding-bond--types

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--epochs 50 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir \
--adding-h \
--is-atom-bond--targets \
--no-shared-atom-bond-ffn \
--no-adding-bond--types \
--ensemble-size 5 \
--save-preds \
--metrics mae

