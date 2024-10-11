#!/bin/bash

# 定义目录路径
TEMPLATE_T2="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration/template/template_t2.nii"
ATLAS_FILE="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration/template/AAL_UNCneo_in_extdhcp40wk.nii"
REGISTRATION_DIR="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration"
ATLAS_OUTPUT_DIR="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/atlas"

# 遍历所有 "sub-" 开头的文件夹
for subject_dir in ${REGISTRATION_DIR}/sub-*; do
    subject_id=$(basename "$subject_dir")
    
    # 查找该被试的 T2w 文件
    T2W_FILE=$(find "$subject_dir" -name "*_T2w.nii.gz" | head -n 1)
    
    if [[ -z "$T2W_FILE" ]]; then
        echo "No T2w file found for $subject_id"
        continue
    fi
    
    echo "Processing $subject_id"
    
    # 1. 线性配准 template_t2.nii 到 T2w 图像，生成配准矩阵和配准后的图像
    flirt -in "$TEMPLATE_T2" -ref "$T2W_FILE" \
          -out "${subject_dir}/${subject_id}_template_t2.nii.gz" \
          -omat "${subject_dir}/${subject_id}_template_t2.mat"
    
    # 2. 应用配准矩阵到 AAL atlas，生成应用后的 atlas 图像
    flirt -in "$ATLAS_FILE" -ref "$T2W_FILE" \
          -applyxfm -init "${subject_dir}/${subject_id}_template_t2.mat" \
          -out "${subject_dir}/${subject_id}_AAL_t2_applied.nii.gz"
    
    # 3. 将结果拷贝到 atlas 输出目录
    cp "${subject_dir}/${subject_id}_AAL_t2_applied.nii.gz" "$ATLAS_OUTPUT_DIR/"
    
    echo "$subject_id completed and copied to atlas directory."
done

echo "All subjects processed."
