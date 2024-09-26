#!/bin/bash

# 定义相关路径
input_txt="subjects_neonatal_genome_func.txt"
source_dir="/neuro/labs/grantlab/users/rui.qian/Package_1232682/genomics_sample03/Users/nickharper/cdb/dhcp_plink_files"  # 你的 .bed/.bim/.fam 文件的目录
target_dir="/neuro/labs/grantlab/users/rui.qian/Package_1232682/genomics_sample03/Users/nickharper/cdb/genome_plink_func_neonatal"

# 确保目标文件夹存在
mkdir -p "$target_dir"

# 遍历txt文件中的被试编号
while IFS= read -r subject; do
    # 定义源文件路径
    bed_file="$source_dir/$subject.bed"
    bim_file="$source_dir/$subject.bim"
    fam_file="$source_dir/$subject.fam"
    
    # 检查源文件是否存在并复制
    if [[ -f "$bed_file" && -f "$bim_file" && -f "$fam_file" ]]; then
        cp "$bed_file" "$target_dir"
        cp "$bim_file" "$target_dir"
        cp "$fam_file" "$target_dir"
        echo "Copied $subject files to $target_dir"
    else
        echo "Files for subject $subject not found, skipping."
    fi
done < "$input_txt"
