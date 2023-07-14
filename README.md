# Chemprop benchmarking scripts and data

This repository contains benchmarking scripts and data for Chemprop, a message passing neural network for molecular property prediction, as described in the paper [XXX](XXX). Please have a look at the [Chemprop repository](https://github.com/chemprop/chemprop) for installation and usage instructions.

## Data

All datasets used in the study can be downloaded from [Zenodo](XXX). You can either download and extract the file data.tar.gz yourself, or run

```
wget https://zenodo.org/api/files/xxx.tar.gz
tar -xzvf data.tar.gz
```

The data folder should be placed within the `chemprop_benchmark` folder (i.e. where this README and the `scripts` folder are located).

## Benchmarks

The paper reports a large number of benchmarks, than can be run individually by executing one of the shell scripts in the `scripts` folder. For example, to run the `barriers_e2` reaction benchmark, activate your Chemprop environment as described in the [Chemprop repository](https://github.com/chemprop/chemprop), and then run (after adapting the path to your Chemprop folder):

```
cd scripts
./barriers_e2.sh
```

This will run a hyperparameter search, as well as a training run on the best hyperparameters, and produce the folder `results_barriers_e2` with all information. Specifically, the file `results_barriers_e2/test_scores.csv` will list the test set errors. If you have installed Chemprop via pip, use `chemprop_train` etc instead of `python $chemprop_dir/train.py` in the script.

Available benchmarking systems:
 * `hiv_random` HIV replication inhibition from MoleculeNet and OGB with random splits
 * `hiv_scaffold` HIV replication inhibition from MoleculeNet and OGB with scaffold splits
 * `pcba_random` Biological activities from MoleculeNet and OGB with random splits
 * `pcba_scaffold` Biological activities from MoleculeNet and OGB with scaffold splits
 * `qm9_multitask` DFT calculated properties from MoleculeNet and OGB, trained as a multi-task model
 * `qm9_u0` DFT calculated properties from MoleculeNet and OGB, trained as a single-task model on the target U0 only
 * `qm9_gap` DFT calculated properties from MoleculeNet and OGB, trained as a single-task model on the target gap only
 * `sampl` Water-octanol partition coefficients, used to predict molecules from the SAMPL6, 7 and 9 challenges
 * `atom_bond_137k` Quantum-mechanical atom and bond descriptors
 * `bde` Bond dissociation enthalpies trained as single-task model
 * `bde_charges` Bond dissociation enthalpies trained as multi-task model together with atomic partial charges
 * `charges_eps_4` Partial charges at a dielectric constant of 4 (in protein)
 * `charges_eps_78` Partial charges at a dielectric constant of 78 (in protein)
 * `barriers_e2` Reaction barrier heights of E2 reactions
 * `barriers_sn2` Reaction barrier heights of SN2 reactions
 * `barriers_cycloadd` Reaction barrier heights of cycloaddition reactions
 * `barriers_rdb7` Reaction barrier heights in the RDB7 dataset
 * `barriers_rgd1` Reaction barrier heights in the RGD1-CNHO dataset
 * `multi_molecule` UV/Vis peak absorption wavelengths in different solvents
 * `ir` IR Spectra
 * `pcqm4mv2` HOMO-LUMO gaps of the PCQM4Mv2 dataset
 * `uncertainty_ensemble` Uncertainty estimation using an ensemble using the QM9 gap dataset
 * `uncertainty_evidential` Uncertainty estimation using evidential learning using the QM9 gap dataset
 * `uncertainty_mve` Uncertainty estimation using mean-variance estimation using the QM9 gap dataset
 * `timing` Timing benchmark using subsets of QM9 gap

All benchmarks were done on the master branch of Chemprop as of March 2023 (commit [0c129c9](https://github.com/chemprop/chemprop/commit/0c129b985868a98331edc728e75d59024778ee4c) which extends functionalities of the [v1.5.2](https://github.com/chemprop/chemprop/releases/tag/v1.5.2) release of Chemprop, and will be part of the upcoming v1.6 release.