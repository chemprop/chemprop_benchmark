#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_multi_molecule
train_path=../data/multi_molecule/train.csv
val_path=../data/multi_molecule/val.csv
test_path=../data/multi_molecule/test.csv

#Hyperparameter optimization
chemprop hyperopt \
--dataset-type regression \
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
--number-of-molecules 2

#Training with optimized hyperparameters
chemprop train \
--dataset-type regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--epochs 50 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir \
--number-of-molecules 2 \
--ensemble-size 5 \
--save-preds \
--extra-metrics mae r2

