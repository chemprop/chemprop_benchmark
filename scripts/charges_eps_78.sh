#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_charges_eps_78
train_path=../data/charges_eps_78/train.csv
val_path=../data/charges_eps_78/val.csv
test_path=../data/charges_eps_78/test.csv
train_constraints_path=../data/charges_eps_78/train_constraints.csv
val_constraints_path=../data/charges_eps_78/val_constraints.csv
test_constraints_path=../data/charges_eps_78/test_constraints.csv

external_test_path=../data/charges_eps_78/external_test_set.csv
external_test_constraints_path=../data/charges_eps_78/external_test_set_constraints.csv

#Hyperparameter optimization
chemprop hyperopt \
-t regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $val_path \
--constraints-path $train_constraints_path \
--separate-val-constraints-path $val_constraints_path \
--separate-test-constraints-path $val_constraints_path \
--num-iters 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hyperopt-checkpoint-dir $results_dir \
--log-dir $results_dir \
--adding-h \
--is-atom-bond-targets \
--no-shared-atom-bond-ffn \
--no-adding-bond-types

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--constraints-path $train_constraints_path \
--separate-val-constraints-path $val_constraints_path \
--separate-test-constraints-path $test_constraints_path \
--epochs 50 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir \
--adding-h \
--is-atom-bond-targets \
--no-shared-atom-bond-ffn \
--no-adding-bond-types \
--ensemble-size 5 \
--save-preds \
--metrics mae

#Predict on external test set
chemprop predict \
-test-path $external_test_path \
--constraints-path $external_test_constraints_path \
--preds-path $results_dir/preds_external_test.csv \
--checkpoint-dir $results_dir
