#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

save_dir=results_timing
data_dir=../data/timing

#100k
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $data_dir/qm9_100k.csv \
--save_dir $save_dir/qm9_100k \
--aggregation norm \
--depth 4 \
--ffn_num_layers 2 \
--hidden_size 1000 \
--ffn_hidden_size 1000 \
--epochs 50 

python $chemprop_dir/predict.py \
--test_path $data_dir/qm9_100k.csv \
--preds_path $save_dir/qm9_100k/preds/preds.csv \
--checkpoint_dir $save_dir/qm9_100k 


#10k
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $data_dir/qm9_10k.csv \
--save_dir $save_dir/qm9_10k \
--aggregation norm \
--depth 4 \
--ffn_num_layers 2 \
--hidden_size 1000 \
--ffn_hidden_size 1000 \
--epochs 50

python $chemprop_dir/predict.py \
--test_path $data_dir/qm9_10k.csv \
--preds_path $save_dir/qm9_10k/preds/preds.csv \
 --checkpoint_dir $save_dir/qm9_10k 

#1k
python $chemprop_dir/train.py \
--dataset_type regression \
--data_path $data_dir/qm9_1k.csv \
--save_dir $save_dir/qm9_1k \
--aggregation norm \
--depth 4 \
--ffn_num_layers 2 \
--hidden_size 1000 \
--ffn_hidden_size 1000 \
--epochs 50 

python $chemprop_dir/predict.py \
--test_path $data_dir/qm9_1k.csv \
--preds_path $save_dir/qm9_1k/preds/preds.csv \
--checkpoint_dir $save_dir/qm9_1k 
