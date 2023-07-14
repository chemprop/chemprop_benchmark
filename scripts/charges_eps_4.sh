#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_charges_eps_4
train_path=../data/charges_eps_4/train.csv
val_path=../data/charges_eps_4/val.csv
test_path=../data/charges_eps_4/test.csv
train_constraints_path=../data/charges_eps_4/train_constraints.csv
val_constraints_path=../data/charges_eps_4/val_constraints.csv
test_constraints_path=../data/charges_eps_4/test_constraints.csv

external_test_path=../data/charges_eps_4/external_test_set.csv
external_test_constraints_path=../data/charges_eps_4/external_test_set_constraints.csv

#Hyperparameter optimization
python $chemprop_dir/hyperparameter_optimization.py \
--dataset_type regression \
--data_path $train_path \
--separate_val_path $val_path \
--separate_test_path $val_path \
--constraints_path $train_constraints_path \
--separate_val_constraints_path $val_constraints_path \
--separate_test_constraints_path $val_constraints_path \
--num_iters 30 \
--epochs 50 \
--aggregation norm \
--search_parameter_keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config_save_path $results_dir/config.json \
--hyperopt_checkpoint_dir $results_dir \
--log_dir $results_dir \
--keeping_atom_map \
--is_atom_bond_targets \
--no_shared_atom_bond_ffn \
--no_adding_bond_types

#Training with optimized hyperparameters
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $train_path \
--separate_val_path $val_path \
--separate_test_path $test_path \
--constraints_path $train_constraints_path \
--separate_val_constraints_path $val_constraints_path \
--separate_test_constraints_path $test_constraints_path \
--epochs 50 \
--aggregation norm \
--config_path $results_dir/config.json \
--save_dir $results_dir \
--keeping_atom_map \
--is_atom_bond_targets \
--no_shared_atom_bond_ffn \
--no_adding_bond_types \
--ensemble_size 5 \
--save_preds \
--extra_metrics mae

#Predict on external test set
python $chemprop_dir/predict.py \
--test_path $external_test_path \
--constraints_path $external_test_constraints_path \
--preds_path $results_dir/preds_external_test.csv \
--checkpoint_dir $results_dir
