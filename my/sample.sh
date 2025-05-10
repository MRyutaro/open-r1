#!/bin/bash
#PBS -q SQUID
#PBS --group=G15612

#PBS -l elapstim_req=0:01:00
#PBS -l cpunum_job=1
#PBS -l memsz_job=10MB

#PBS -m eb
#PBS -M matsumoto.ryutaro@ais.cmc.osaka-u.ac.jp

#PBS -e ./logs/error.txt
#PBS -o ./logs/output.txt

module load BaseCPU

cd $PBS_O_WORKDIR

# pwd, lsの結果を表示し，その後，lsの結果をファイルに保存
pwd > ./logs/pwd.txt
ls > ./logs/ls.txt
