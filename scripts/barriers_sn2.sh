#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_barriers_sn2
train_path=../data/barriers_sn2/train.csv
val_path=../data/barriers_sn2/val.csv
test_path=../data/barriers_sn2/test.csv

#Hyperparameter optimization
python $chemprop_dir/hyperparameter_optimization.py \
--dataset-type regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $val_path \
--num-iters 100 \
--epochs 200 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers hidden_size ffn_hidden_size dropout max_lr final_lr init_lr batch_size warmup_epochs \
--config-save-path $results_dir/config.json \
--hyperopt-checkpoint-dir $results_dir \
--log-dir $results_dir \
--reaction \
--explicit-h 

#Training with optimized hyperparameters
python $chemprop_dir/train.py \
--dataset-type regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--epochs 200 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir \
--reaction \
--explicit-h \
--ensemble-size 5 \
--save-preds \
--extra-metrics mae

