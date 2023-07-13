#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_uncertainty_evidential
train_path=../data/uncertainty/train.csv
val_path=../data/uncertainty/val.csv
test_path=../data/uncertainty/test.csv

#Hyperparameter optimization
python $chemprop_dir/hyperparameter_optimization.py \
--dataset_type regression \
--data_path $train_path \
--separate_val_path $val_path \
--separate_test_path $val_path \
--num_iters 30 \
--epochs 50 \
--aggregation norm \
--search_parameter_keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config_save_path $results_dir/config.json \
--hyperopt_checkpoint_dir $results_dir \
--log_dir $results_dir \
--loss_function evidential

#Training with optimized hyperparameters
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $train_path \
--separate_val_path $val_path \
--separate_test_path $test_path \
--epochs 50 \
--aggregation norm \
--config_path $results_dir/config.json \
--save_dir $results_dir \
--loss_function evidential

#Predict, analyze uncertainty
python $chemprop_dir/predict.py \
--test_path $test_path \
--preds_path $results_dir/test_preds_unc_evidential.csv \
--checkpoint_dir $results_dir \
--uncertainty_method evidential_total \
--calibration_method zscaling \
--calibration_path $val_path \
--regression_calibrator_metric stdev \
--calibration_interval_percentile 95 \
--evaluation_methods nll spearman ence miscalibration_area \
--evaluation_scores_path $results_dir/unc_eval_scores_evidential.csv		

cat $results_dir/unc_eval_scores_evidential.csv
