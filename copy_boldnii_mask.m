% Define folder paths
baseDirBOLD = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline/';
baseDirMask = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_anat_pipeline/';
outputDir = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/BOLD_for_calculate_trait/';

% Read subject IDs from the text file
fileID = fopen('subjects_neonatal_genome_func.txt', 'r');
subjectIDs = textscan(fileID, '%s');
fclose(fileID);

% Loop through each subject ID
for i = 1:length(subjectIDs{1})
    % Get the subject ID and prepend 'sub-'
    subID = ['sub-' subjectIDs{1}{i}];
    
    % Create participant folder
    participantDir = fullfile(outputDir, subID);
    if ~exist(participantDir, 'dir')
        mkdir(participantDir);
    end
    
    % Construct BOLD file path
    boldPath = fullfile(baseDirBOLD, subID, 'ses-*/func', [subID '_ses-*_task-rest_desc-preproc_bold.nii']);
    
    % Find BOLD files
    boldFiles = dir(boldPath);
    if ~isempty(boldFiles)
        % Move and rename BOLD file
        movefile(fullfile(boldFiles(1).folder, boldFiles(1).name), ...
                 fullfile(participantDir, [subID '-bold.nii']));
    else
        % If no BOLD file found, check for gzipped BOLD file
        boldGzPath = fullfile(baseDirBOLD, subID, 'ses-*/func', [subID '_ses-*_task-rest_desc-preproc_bold.nii.gz']);
        boldGzFiles = dir(boldGzPath);
        if ~isempty(boldGzFiles)
            % Unzip and rename gzipped BOLD file
            gunzip(fullfile(boldGzFiles(1).folder, boldGzFiles(1).name), participantDir);
            movefile(fullfile(participantDir, boldGzFiles(1).name(1:end-3)), ...
                     fullfile(participantDir, [subID '-bold.nii']));
        end
    end
    
    % Construct mask file path
    maskPath = fullfile(baseDirMask, subID, 'ses-*/anat', [subID '_ses-*_desc-brain_mask.nii.gz']);
    
    % Find mask files
    maskFiles = dir(maskPath);
    if ~isempty(maskFiles)
        % Unzip and rename mask file
        gunzip(fullfile(maskFiles(1).folder, maskFiles(1).name), participantDir);
        movefile(fullfile(participantDir, maskFiles(1).name(1:end-3)), ...
                 fullfile(participantDir, [subID '-mask.nii']));
    end
end

disp('Processing complete!');
