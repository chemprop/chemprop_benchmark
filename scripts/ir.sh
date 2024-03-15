#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_ir
train_path=../data/ir/train.csv
val_path=../data/ir/val.csv
test_path=../data/ir/test.csv

#Hyperparameter optimization
# chemprop hyperopt \
-t spectra \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $val_path \
--num-iters 100 \
--epochs 200 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers hidden_size ffn_hidden_size dropout max_lr final_lr init_lr batch_size warmup_epochs \
--config-save-path $results_dir/config.json \
--hyperopt-checkpoint-dir $results_dir \
--log-dir $results_dir 

#Training with optimized hyperparameters
chemprop train \
-t spectral \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--epochs 200 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir \
--ensemble-size 5 \
--save-preds 
