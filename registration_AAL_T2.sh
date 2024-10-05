#!/bin/bash

# Set paths
atlas_path="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration/template/AAL_UNCneo_in_extdhcp40wk.nii"
registration_folder="/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/registration"
failed_subjects_file="failed_subjects.txt"

# Get list of all subject folders (assuming the format is 'sub-<subject_id>')
subject_folders=("$registration_folder"/sub-*)

# Initialize report for failed subjects
> "$failed_subjects_file" # Clear the file at the beginning

# Loop through each subject folder
for subject_folder in "${subject_folders[@]}"; do
    subject_id=$(basename "$subject_folder") # This will be 'sub-<subject_id>'

    # Check for the T2 file
    t2_file=$(find "$subject_folder" -name "*_T2w.nii.gz")

    if [ -z "$t2_file" ]; then
        echo "T2 file missing for subject: $subject_id"
        echo "$subject_id" >> "$failed_subjects_file" # Record missing T2 file
        continue # Skip to the next subject
    fi

    # Output file name
    output_file="$subject_folder/${subject_id}_AAL_t2.nii"

    # Linear registration using FLIRT
    echo "Processing subject: $subject_id" # Report the current subject being processed
    flirt -in "$t2_file" -ref "$atlas_path" -out "$output_file" -omat "$subject_folder/${subject_id}_AAL_t2.mat"

    # Check if the registration command was successful
    if [ $? -ne 0 ]; then
        echo "Failed to register atlas for subject: $subject_id"
        echo "$subject_id" >> "$failed_subjects_file" # Record failed registration
    fi
done

# Output total processed subjects
echo "Total subjects processed: ${#subject_folders[@]}"
