#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_barriers_cycloadd
train_path=../data/barriers_cycloadd/train.csv
val_path=../data/barriers_cycloadd/val.csv
test_path=../data/barriers_cycloadd/test.csv

#Hyperparameter optimization
python $chemprop_dir/hyperparameter_optimization.py \
--dataset_type regression \
--data_path $train_path \
--separate_val_path $val_path \
--separate_test_path $val_path \
--num_iters 100 \
--epochs 200 \
--aggregation norm \
--search_parameter_keywords depth ffn_num_layers hidden_size ffn_hidden_size dropout max_lr final_lr init_lr batch_size warmup_epochs \
--config_save_path $results_dir/config.json \
--hyperopt_checkpoint_dir $results_dir \
--log_dir $results_dir \
--reaction \
--explicit_h \
--smiles_column rxn_smiles \
--target_columns G_act

#Training with optimized hyperparameters
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $train_path \
--separate_val_path $val_path \
--separate_test_path $test_path \
--epochs 200 \
--aggregation norm \
--config_path $results_dir/config.json \
--save_dir $results_dir \
--reaction \
--explicit_h \
--ensemble_size 5 \
--save_preds \
--extra_metrics mae \
--smiles_column rxn_smiles \
--target_columns G_act

