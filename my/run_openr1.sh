#!/bin/bash
#PBS -q SQUID
#PBS --group=G15612

# テスト用の小規模な設定
#PBS -l elapstim_req=1:00:00  # 1時間の実行時間
#PBS -l cpunum_job=4          # 4コアのCPU
#PBS -l memsz_job=32gb        # 32GBのメモリ
#PBS -l gpunum_job=1          # 1つのGPU

#PBS -m eb
#PBS -M matsumoto.ryutaro@ais.cmc.osaka-u.ac.jp

module load BasePy
module --force switch python3/3.6 python3/3.6.GPU
module load BaseGCC
module load cuda
module load cudnn

cd $PBS_O_WORKDIR

source .venv/bin/activate

accelerate launch --config_file=configs/zero3.yaml src/open_r1/sft.py \
  --model_name_or_path Qwen/Qwen2.5-Math-1.5B-Instruct \
  --dataset_name HuggingFaceH4/Bespoke-Stratos-17k \
  --learning_rate 2.0e-5 \
  --num_train_epochs 1 \
  --packing \
  --max_seq_length 2048 \        # シーケンス長を短く
  --per_device_train_batch_size 2 \  # バッチサイズを小さく
  --per_device_eval_batch_size 2 \   # バッチサイズを小さく
  --gradient_accumulation_steps 2 \  # 勾配累積ステップを減らす
  --gradient_checkpointing \
  --bf16 \
  --logging_steps 5 \
  --eval_strategy steps \
  --eval_steps 50 \             # 評価ステップを減らす
  --output_dir data/Qwen2.5-1.5B-Open-R1-Distill
