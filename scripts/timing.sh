#!/bin/bash

chemprop_dir=../../../chemprop  # location of chemprop directory, CHANGE ME

save_dir=results_timing
data_dir=../data/timing

#100k
chemprop train \
-t regression \
--data-path $data_dir/qm9_100k.csv \
--save-dir $save_dir/qm9_100k \
--aggregation norm \
--depth 4 \
--ffn-num-layers 2 \
--hidden-size 1000 \
--ffn-hidden-size 1000 \
--epochs 50 

chemprop predict \
--test-path $data_dir/qm9_100k.csv \
--preds-path $save_dir/qm9_100k/preds/preds.csv \
--model-path $save_dir/qm9_100k 


#10k
chemprop train \
-t regression \
--data-path $data_dir/qm9_10k.csv \
--save-dir $save_dir/qm9_10k \
--aggregation norm \
--depth 4 \
--ffn-num-layers 2 \
--hidden-size 1000 \
--ffn-hidden-size 1000 \
--epochs 50

chemprop predict \
--test-path $data_dir/qm9_10k.csv \
--preds-path $save_dir/qm9_10k/preds/preds.csv \
--model-path $save_dir/qm9_10k 

#1k
chemprop train \
-t regression \
--data-path $data_dir/qm9_1k.csv \
--save-dir $save_dir/qm9_1k \
--aggregation norm \
--depth 4 \
--ffn-num-layers 2 \
--hidden-size 1000 \
--ffn-hidden-size 1000 \
--epochs 50 

chemprop predict \
--test-path $data_dir/qm9_1k.csv \
--preds-path $save_dir/qm9_1k/preds/preds.csv \
--model-path $save_dir/qm9_1k 
