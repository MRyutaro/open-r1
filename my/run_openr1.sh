#!/bin/bash
#PBS -q SQUID
#PBS --group=G15612

# テスト用の小規模な設定
#PBS -l elapstim_req=5:00:00  # 実行時間
#PBS -l cpunum_job=8          # CPU数
#PBS -l memsz_job=64gb        # メモリ量
#PBS -l gpunum_job=1          # GPU数

#PBS -m eb
#PBS -M matsumoto.ryutaro@ais.cmc.osaka-u.ac.jp

module load BasePy
module --force switch python3/3.6 python3/3.6.GPU
module load BaseGCC
module load cuda
module load cudnn

cd $PBS_O_WORKDIR

source .venv/bin/activate

accelerate launch --config_file=recipes/accelerate_configs/zero3.yaml src/open_r1/sft.py \
  --model_name_or_path ./models/Qwen2.5-Math-1.5B-Instruct \
  --dataset_name ./datasets/Bespoke-Stratos-17k \
  --learning_rate 2.0e-5 \
  --num_train_epochs 1 \
  --packing \
  --max_seq_length 2048 \
  --per_device_train_batch_size 2 \
  --per_device_eval_batch_size 2 \
  --gradient_accumulation_steps 2 \
  --gradient_checkpointing \
  --bf16 \
  --logging_steps 5 \
  --eval_strategy steps \
  --eval_steps 50 \
  --output_dir data/Qwen2.5-1.5B-Open-R1-Distill \
  --report_to none \
