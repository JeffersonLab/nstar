#!/bin/bash
#SBATCH --qos=debug
#SBATCH --time=00:05:00
#SBATCH --constraint=knl
#SBATCH --nodes=2

REMOVE=/global/homes/f/fwinter/genprop_test_cori_launcher/remove_fifo.sh
LAUNCHER=/global/homes/f/fwinter/genprop_test_cori_launcher/launcher

CHROMA=/global/cscratch1/sd/fwinter/exe/chroma
GENPROP=/global/cscratch1/sd/fwinter/exe/genprop


echo "Starting remove"

srun -n 2 --ntasks-per-node=1 ${REMOVE}

echo "End remove, starting CHROMA"

INPUT=input_mg_8n_small.xml
OUTPUT=output_mg_8n.xml


rm -f /global/cscratch1/sd/fwinter/unsmeared_genprop_8n.sdb

srun -n 16 --ntasks-per-node=8 ${LAUNCHER} SLURM_PROCID 8 ${CHROMA} 8 out.chroma ${GENPROP} 8 out.harom 4 /tmp/harom-cmd 32 -i $INPUT -o $OUTPUT -geom 2 2 2 2 -by 4 -bz 4 -c 4 -sy 1 -sz 2


