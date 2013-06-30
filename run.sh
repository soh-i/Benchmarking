#!/bin/sh
set -e

DIR=/home/soh.i/benchmark
hg19=/home/soh.i/benchmark/data/human

# S2 and S3
perl $DIR/src/AGrichness.pl $hg19/predict/23291724/nmeth.2330-S2_PooledSamplesNon-Repetitive.csv $hg19/predict/23291724/nonAG/nmeth.2330-S3_PooledSamplesNonRepetitive.csv
perl $DIR/src/AGrichness.pl $hg19/predict/23291724/nmeth.2330-S2_PooledSamplesRepetitiveNonAlu.csv $hg19/predict/23291724/nonAG/nmeth.2330-S3_PooledSamplesRepetitiveNonAlu.csv

# S4 and S5
perl $DIR/src/AGrichness.pl $hg19/predict/23291724/nmeth.2330-S4_PooledSamplesNonRepetitive.csv $hg19/predict/23291724/nonAG/nmeth.2330-S5_PooledSamplesNonRepetitive.csv
perl $DIR/src/AGrichness.pl $hg19/predict/23291724/nmeth.2330-S4_PooledSamplesRepetitiveNonAlu.csv $hg19/predict/23291724/nonAG/nmeth.2330-S5_PooledSamplesRepetitiveNonAlu.csv

# S6 and S7
perl $DIR/src/AGrichness.pl $hg19/predict/23291724/nmeth.2330-S6_PooledSamplesNonRepetitive.csv $hg19/predict/23291724/nonAG/nmeth.2330-S7_PooledSamplesNonRepetitive.csv
perl $DIR/src/AGrichness.pl $hg19/predict/23291724/nmeth.2330-S6_PooledSamplesRepetitiveNonAlu.csv $hg19/predict/23291724/nonAG/nmeth.2330-S7_PooledSamplesRepetitiveNonAlu.csv








