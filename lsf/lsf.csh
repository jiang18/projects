#!/bin/tcsh 
#BSUB -n 8
#BSUB -W 10
#BSUB -R span[hosts=1]
#BSUB -R select[model==Gold6130]
#BSUB -o out.%J
#BSUB -e err.%J
#BSUB -J test
#BSUB -x

cd /home/jjiang26/qtlmas2012/
