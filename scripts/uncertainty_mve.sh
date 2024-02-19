#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_uncertainty_mve
train_path=../data/uncertainty/train.csv
val_path=../data/uncertainty/val.csv
test_path=../data/uncertainty/test.csv

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
--loss-function mve

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
--loss-function mve

#Predict, analyze uncertainty
chemprop predict \
--test-path $test_path \
--preds-path $results_dir/test_preds_unc_mve.csv \
--checkpoint-dir $results_dir \
--uncertainty-method mve \
--calibration-method zscaling \
--calibration-path $val_path \
--regression-calibrator-metric stdev \
--calibration-interval-percentile 95 \
--evaluation-methods nll spearman ence miscalibration_area \
--evaluation-scores-path $results_dir/unc_eval_scores_mve.csv		

cat $results_dir/unc_eval_scores_mve.csv
