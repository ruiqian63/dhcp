% 读取txt文件中的被试编号
fileID = fopen('subjects_neonatal_genome_func.txt', 'r');
subject_ids = textscan(fileID, '%s');
subject_ids = subject_ids{1}; % 转换为 cell 数组
fclose(fileID);

% 存放四维尺寸信息的矩阵，初始化为 650x4
size_matrix = zeros(650, 4);

% 遍历每个被试编号
for i = 1:length(subject_ids)
    subject_id = subject_ids{i};
    
    % 添加 "sub-" 前缀
    full_subject_id = ['sub-', subject_id];
    
    % 构建被试的文件夹路径
    base_folder = ['/net/rc-fs-nfs.tch.harvard.edu/FNNDSC-e2/neuro/labs/grantlab/users/rui.qian/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline/', full_subject_id];
    
    % 获取 ses-xxxx 文件夹名（下级只有一个文件夹，所以可以直接获取）
    ses_folder = dir(fullfile(base_folder, 'ses-*'));
    if isempty(ses_folder)
        disp(['找不到被试: ', full_subject_id, ' 的 ses 文件夹']);
        continue;
    end
    ses_folder_name = ses_folder(1).name;
    
    % 构建 BOLD 信号文件的完整路径
    bold_file = fullfile(base_folder, ses_folder_name, 'func', [full_subject_id, '_', ses_folder_name, '_task-rest_desc-preproc_bold.nii.gz']);
    
    % 解压 .nii.gz 文件
    gunzip(bold_file);
    nii_file = strrep(bold_file, '.gz', ''); % 解压后的 .nii 文件路径
    
    % 使用 SPM 加载并读取四维图像
    V = spm_vol(nii_file);
    img = spm_read_vols(V);
    
    % 保存 img 为 .mat 文件
    save([full_subject_id, '_bold.mat'], 'img');
    
    % 读取四维矩阵的大小，并存入 size_matrix 中
    img_size = size(img);
    if length(img_size) < 4
        img_size(4) = 1; % 如果不是四维图像，第四维设为1
    end
    size_matrix(i, :) = img_size; % 存入 (x, y, z, t)
end

% 保存四维尺寸矩阵
save('size_matrix.mat', 'size_matrix');
