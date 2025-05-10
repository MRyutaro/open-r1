#!/bin/bash
#PBS -q SQUID
#PBS --group=G15612

#PBS -l elapstim_req=[経過時間]
#PBS -l cpunum_job=[1ノードあたりのCPUコア使用数]
#PBS -l memsz_job=[1ノードあたりのメモリ使用量]
#PBS -l gpunum_job=[1ノードあたりのGPU使用数]

#PBS -m eb
#PBS -M matsumoto.ryutaro@ais.cmc.osaka-u.ac.jp

cd $PBS_O_WORKDIR

module load python/3.11
source .venv/bin/activate

accelerate launch --config_file=configs/zero3.yaml src/open_r1/sft.py \
  --model_name_or_path Qwen/Qwen2.5-Math-1.5B-Instruct \
  --dataset_name HuggingFaceH4/Bespoke-Stratos-17k \
  --learning_rate 2.0e-5 \
  --num_train_epochs 1 \
  --packing \
  --max_seq_length 4096 \
  --per_device_train_batch_size 4 \
  --per_device_eval_batch_size 4 \
  --gradient_accumulation_steps 4 \
  --gradient_checkpointing \
  --bf16 \
  --logging_steps 5 \
  --eval_strategy steps \
  --eval_steps 100 \
  --output_dir data/Qwen2.5-1.5B-Open-R1-Distill
