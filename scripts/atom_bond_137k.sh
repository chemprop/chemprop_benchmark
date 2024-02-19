#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_atom_bond_137k
train_path=../data/atom_bond_137k/train.csv
val_path=../data/atom_bond_137k/val.csv
test_path=../data/atom_bond_137k/test.csv
train_constraints_path=../data/atom_bond_137k/train_constraints.csv
val_constraints_path=../data/atom_bond_137k/val_constraints.csv
test_constraints_path=../data/atom_bond_137k/test_constraints.csv

#Hyperparameter optimization
chemprop hyperopt \
--dataset-type regression \
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
--dataset-type regression \
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
--extra-metrics mae \
--show-individual-scores
