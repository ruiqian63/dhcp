#!/bin/bash

# Set paths
registration_folder="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration"
avg_t2_template="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration/template/Reslice2_template_t2.nii"
failed_subjects_file="failed_subjects.txt"

# Clear the failed_subjects.txt file before starting
> "$failed_subjects_file"

# Counter for subject index
subject_count=0

# Loop through each subject folder in registration directory
for subject_dir in ${registration_folder}/sub-*; do
    subject_count=$((subject_count + 1))
    subject_id=$(basename "$subject_dir")
    
    # Find the BOLD file in the subject folder
    bold_file=$(find "$subject_dir" -type f -name "*task-rest_desc-preproc_bold.nii.gz")
    t2_template_file="$avg_t2_template"
    
    # Check if BOLD file exists
    if [ -z "$bold_file" ]; then
        echo "BOLD file not found for subject: $subject_id"
        echo "$subject_id" >> "$failed_subjects_file"
        continue
    fi
    
    # Define output file for the registration
    bold_template_output="${subject_dir}/sub-${subject_id}_bold_template.nii.gz"
    
    # Perform linear registration using flirt
    echo "Running subject $subject_count"
    flirt -in "$bold_file" -ref "$t2_template_file" -out "$bold_template_output" -omat "${subject_dir}/sub-${subject_id}_bold_to_t2.mat"
    
    # If registration failed, report the subject and log the failure
    if [ $? -ne 0 ]; then
        echo "！！！！！！！！！！！！！！！Linear registration failed for subject: $subject_id！！！！！！！！！！！！！！！！！"
        echo "$subject_id" >> "$failed_subjects_file"
    fi
done

echo "All linear registrations completed!"
