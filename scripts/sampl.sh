#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_sampl
results_dir2=results_sampl_production
train_path=../data/logP/train.csv
val_path=../data/logP/val.csv
test_path=../data/logP/test.csv
path=../data/logP/logP_without_overlap.csv

#Hyperparameter optimization
#python $chemprop_dir/hyperparameter_optimization.py \
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
--log_dir $results_dir 

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
--ensemble_size 5 \
--save_preds \
--extra_metrics mae

#Train production model
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $path \
--separate_val_path $path \
--separate_test_path $path \
--epochs 40 \
--aggregation norm \
--config_path $results_dir/config.json \
--save_dir $results_dir2 \
--ensemble_size 5 

#Predict on Sample 6
python $chemprop_dir/predict.py \
--test_path "../data/logP/sampl6_experimental.csv" \
--preds_path $results_dir2/pred_SAMPL6.csv \
--checkpoint_dir $results_dir2 \
--smiles_column "Isomeric SMILES"

echo SAMPL6  >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL6.csv")["logP"],pd.read_csv("../data/logP/sampl6_experimental.csv")["logP mean"],squared=False))' >> $results_dir2/sampl.csv

#Predict on Sample 7
python $chemprop_dir/predict.py \
--test_path "../data/logP/sampl7_experimental.csv" \
--preds_path $results_dir2/pred_SAMPL7.csv \
--checkpoint_dir $results_dir2 \
--smiles_column "Isomeric SMILES"

echo SAMPL7 >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL7.csv")["logP"],pd.read_csv("../data/logP/sampl7_experimental.csv")["logP mean"],squared=False))' >> $results_dir2/sampl.csv

#Predict on Sample 9
python $chemprop_dir/predict.py \
--test_path "../data/logP/sampl9_experimental.csv" \
--preds_path $results_dir2/pred_SAMPL9.csv \
--checkpoint_dir $results_dir2 \
--smiles_column smiles

echo SAMPL9 >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL9.csv")["logP"],pd.read_csv("../data/logP/sampl9_experimental.csv")["new_logPexp_reviewed"],squared=False))' >> $results_dir2/sampl.csv

echo "Saved results to" $results_dir2"/sampl.csv"
cat  >> $results_dir2/sampl.csv
