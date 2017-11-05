#!/bin/bash

stem=$1
tt=$2
seqno=$3

scratch_dir="$HOME/scratch/${stem}/run.prop"
pref="${scratch_dir}/${stem}/prop.strange.singlet.${seqno}/${stem}.t0_${tt}"
input="${pref}.prop.ini.xml${seqno}"
output="${pref}.prop.out.xml${seqno}"
out="${pref}.prop.out${seqno}"

#basedir="$HOME/qcd/git/bw.3/scripts_rge/run/chroma"
basedir="$HOME/qcd/git/nim-play/nstar/run/chroma"
exe="$HOME/bin/exe/ib9q/chroma.cori2.scalar.qphix.aug_28_2017"

source ${basedir}/env_qphix.sh
export KMP_AFFINITY=compact,granularity=thread
export KMP_PLACE_THREADS=1s,64c,2t

$exe -i $input -o $output -by 4 -bz 4 -pxy 0 -pxyz 0 -c 64 -sy 1 -sz 2 -minct 1 > $out 2>&1
