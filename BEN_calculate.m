%% BEN calculator
% Define file and target root paths
fileroot = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/BOLD_for_calculate_trait';
targetroot = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/fMRItrait/BEN';

% Get a list of participant folders in the BOLD directory
participantDirs = dir(fullfile(fileroot, 'sub-*')); % Get folders starting with 'sub-'

% Loop through each participant directory
for i = 1:length(participantDirs)
    subID = participantDirs(i).name; % Get the folder name (e.g., 'sub-CC00058XX09')

    % Construct the file path for the BOLD and mask files
    boldFilePath = fullfile(fileroot, subID, [subID '-bold.nii']);
    maskFilePath = fullfile(fileroot, subID, [subID '-mask.nii']);
    
    % Read the BOLD data
    [v, h] = y_Read(boldFilePath);
    dat = v;
    tlen = size(dat, 4);
    dat = reshape(dat, size(dat, 1) * size(dat, 2) * size(dat, 3), size(dat, 4));
    loc = size(dat, 1);
    
    datfile = fullfile(targetroot, 'braindat.dat');
    std_d = std(dat, 0, 2);
    dat = dat';
    r = 0.3; % Adjust as necessary
    dim = 3;
    
    % Write data to file
    fid = fopen(datfile, 'wb');
    fwrite(fid, loc, 'int');
    fwrite(fid, tlen, 'int');
    fwrite(fid, std_d, 'float');
    fwrite(fid, dat, 'float');
    fclose(fid);
    
    % Execute SampEn for BEN calculation
    if isunix
        str = ['\neuro\labs\grantlab\research\enrique.mondragon\morton_lab\dhcp\toolbox\BENtbx\SampEn -d ' num2str(dim) ' -r ' num2str(r) ' -i ' datfile  ' -o SEN.dat '];
        eval(str);
    else
        str = ['sampen.exe -d ' num2str(dim) ' -r ' num2str(r) ' -i ' datfile  ' -o SEN.dat '];
        system(str);
    end
    
    % Read the SEN.dat file
    fid = fopen('SEN.dat', 'rb');
    slen = fread(fid, 1, 'int');
    dim = fread(fid, 1, 'int');
    ratio = fread(fid, 1, 'float');
    sSEN = fread(fid, slen, 'float');
    aSEN = fread(fid, slen, 'float');
    fclose(fid);
    
    sSEN = sSEN * 1e3;
    benmap = reshape(sSEN, size(v, 1), size(v, 2), size(v, 3));
    
    % Load the mask for the current subject
    mask1 = niftiread(maskFilePath);
    mask = im2double(mask1);
    benmap = benmap .* mask; % Apply mask to the BEN map
    
    % Write the BEN map to the target directory
    targetPath = fullfile(targetroot, ['BEN_' subID '.nii']);
    y_Write(benmap, h, targetPath);
    
    % Clean up
    delete(datfile);
end

disp('BEN calculation complete!');
