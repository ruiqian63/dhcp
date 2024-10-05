#!/bin/bash

# 设置路径
subject_file="subjects_neonatal_genome_func.txt"
bold_base_path="/net/rc-fs-nfs.tch.harvard.edu/FNNDSC-e2/neuro/labs/grantlab/users/rui.qian/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline"
t2_base_path="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_anat_pipeline"
template_base_path="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration"
avg_t2_template="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration/template/Reslice2_template_t2.nii"

# 创建注册文件夹，复制BOLD和T2文件
while read subject_id; do
    registration_folder="${template_base_path}/sub-${subject_id}"
    mkdir -p "$registration_folder"
   
    # 找到BOLD信号文件
    bold_file=$(find "${bold_base_path}/sub-${subject_id}" -type f -name "*task-rest_desc-preproc_bold.nii.gz")
    if [ -z "$bold_file" ]; then
        echo "BOLD file not found for subject ${subject_id}"
        continue
    fi

    # 找到T2文件
    t2_file=$(find "${t2_base_path}/sub-${subject_id}" -type f -name "*T2w.nii.gz")
    if [ -z "$t2_file" ]; then
        echo "T2 file not found for subject ${subject_id}"
        continue
    fi
   
    # 复制文件到注册文件夹
    cp "$bold_file" "$registration_folder/"
    cp "$t2_file" "$registration_folder/"
done < "$subject_file"

# 线性配准BOLD到T2
while read subject_id; do
    registration_folder="${template_base_path}/sub-${subject_id}"
    bold_file=$(find "$registration_folder" -name "*task-rest_desc-preproc_bold.nii.gz")
    t2_file=$(find "$registration_folder" -name "*T2w.nii.gz")

    if [ -z "$bold_file" ] || [ -z "$t2_file" ]; then
        echo "Missing files for subject ${subject_id}, skipping registration"
        continue
    fi

    # 输出文件名加上被试编号前缀
    bold_t2_output="${registration_folder}/sub-${subject_id}_bold_t2.nii.gz"

    # 线性配准
    flirt -in "$bold_file" -ref "$t2_file" -out "$bold_t2_output" -omat "${registration_folder}/sub-${subject_id}_bold2t2.mat"
done < "$subject_file"

# 非线性配准T2到平均T2模板
while read subject_id; do
    registration_folder="${template_base_path}/sub-${subject_id}"
    t2_file=$(find "$registration_folder" -name "*T2w.nii.gz")

    if [ -z "$t2_file" ]; then
        echo "T2 file not found for subject ${subject_id}"
        continue
    fi

    # 非线性配准，并生成非线性变形场
    fnirt --in="$t2_file" --ref="$avg_t2_template" --iout="${registration_folder}/sub-${subject_id}_t2_template.nii.gz" --fout="${registration_folder}/sub-${subject_id}_warpfield.nii.gz"
done < "$subject_file"

# 应用T2到模板的变形场到BOLD_T2文件
while read subject_id; do
    registration_folder="${template_base_path}/sub-${subject_id}"
    bold_t2_file="${registration_folder}/sub-${subject_id}_bold_t2.nii.gz"
    warpfield="${registration_folder}/sub-${subject_id}_warpfield.nii.gz"

    if [ -z "$bold_t2_file" ] || [ -z "$warpfield" ]; then
        echo "Missing files for subject ${subject_id}, skipping warp application"
        continue
    fi

    # 输出最终配准的BOLD文件
    bold_template_output="${registration_folder}/sub-${subject_id}_bold_template.nii.gz"

    # 应用非线性变形场
    applywarp --ref="$avg_t2_template" --in="$bold_t2_file" --warp="$warpfield" --out="$bold_template_output"
done < "$subject_file"

echo "All processing completed!"
