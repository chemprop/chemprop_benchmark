#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

results_dir=results_sampl
results_dir2=results_sampl_production
train_path=../data/logP/train.csv
val_path=../data/logP/val.csv
test_path=../data/logP/test.csv
path=../data/logP/logP_without_overlap.csv

#Hyperparameter optimization
# chemprop hyperopt \
-t regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $val_path \
--num-iters 30 \
--epochs 50 \
--aggregation norm \
--search-parameter-keywords depth ffn_num_layers  hidden_size ffn_hidden_size dropout \
--config-save-path $results_dir/config.json \
--hyperopt-checkpoint-dir $results_dir \
--log-dir $results_dir 

#Training with optimized hyperparameters
chemprop train \
-t regression \
--data-path $train_path \
--separate-val-path $val_path \
--separate-test-path $test_path \
--epochs 50 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir \
--ensemble-size 5 \
--save-preds \
--metrics mae

#Train production model
chemprop train \
-t regression \
--data-path $path \
--separate-val-path $path \
--separate-test-path $path \
--epochs 40 \
--aggregation norm \
--config-path $results_dir/config.json \
--save-dir $results_dir2 \
--ensemble-size 5 

#Predict on Sample 6
chemprop predict \
--test-path "../data/logP/sampl6_experimental.csv" \
--preds-path $results_dir2/pred_SAMPL6.csv \
--checkpoint-dir $results_dir2 \
--smiles-column "Isomeric SMILES"

echo SAMPL6  >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL6.csv")["logP"],pd.read_csv("../data/logP/sampl6_experimental.csv")["logP mean"],squared=False))' >> $results_dir2/sampl.csv

#Predict on Sample 7
chemprop predict \
--test-path "../data/logP/sampl7_experimental.csv" \
--preds-path $results_dir2/pred_SAMPL7.csv \
--checkpoint-dir $results_dir2 \
--smiles-column "Isomeric SMILES"

echo SAMPL7 >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL7.csv")["logP"],pd.read_csv("../data/logP/sampl7_experimental.csv")["logP mean"],squared=False))' >> $results_dir2/sampl.csv

#Predict on Sample 9
chemprop predict \
--test-path "../data/logP/sampl9_experimental.csv" \
--preds-path $results_dir2/pred_SAMPL9.csv \
--checkpoint-dir $results_dir2 \
--smiles-column smiles

echo SAMPL9 >> $results_dir2/sampl.csv
python -c 'import pandas as pd; from sklearn import metrics; print("rmse", metrics.mean_squared_error(pd.read_csv("results_sampl_production/pred_SAMPL9.csv")["logP"],pd.read_csv("../data/logP/sampl9_experimental.csv")["new_logPexp_reviewed"],squared=False))' >> $results_dir2/sampl.csv

echo "Saved results to" $results_dir2"/sampl.csv"
cat  >> $results_dir2/sampl.csv
