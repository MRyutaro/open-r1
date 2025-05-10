from datasets import load_dataset
import os

# データセットをHugging Faceから取得
dataset = load_dataset("HuggingFaceH4/Bespoke-Stratos-17k")

# 保存先ディレクトリ
save_dir = "/sqfs/work/G15612/u6c223/programs/open-r1/datasets/Bespoke-Stratos-17k"

# 既存のディレクトリがあれば削除
if os.path.exists(save_dir):
    import shutil
    shutil.rmtree(save_dir)

# 各スプリットをArrow形式で保存
for split_name, split_dataset in dataset.items():
    # Arrow形式で保存
    split_dataset.save_to_disk(
        os.path.join(save_dir, split_name),
        num_proc=4  # 並列処理で高速化
    )

print("データセットの保存が完了しました")
