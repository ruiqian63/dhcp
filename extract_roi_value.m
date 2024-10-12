% 定义文件夹路径
atlas_dir = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/atlas/';
ben_dir = '/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/fMRItrait/BEN/';

% 被试数量和脑区数量
num_subjects = 650;
num_regions = 134;

% 获取 atlas 文件名（按 CC 编号排序）
atlas_files = dir(fullfile(atlas_dir, '*_AAL_t2_applied.nii.gz'));
[~, idx] = sort({atlas_files.name});  % 按文件名排序
atlas_files = atlas_files(idx);       % 重排 atlas 文件

% 初始化结果矩阵
region_mean_ben = zeros(num_subjects, num_regions);

% 遍历每个被试
for sub_idx = 1:num_subjects
    % 构建 atlas 和 ben 文件名
    atlas_file = fullfile(atlas_dir, atlas_files(sub_idx).name);
    ben_file = sprintf('%sBEN_sub%d.nii', ben_dir, sub_idx);

    % 加载 atlas 和 ben 文件
    atlas = niftiread(atlas_file);  % 假设 atlas 是 (196*238*197) 的维度
    ben = niftiread(ben_file);      % 假设 ben 是 (68*67*45) 的维度
    
    % 获取 atlas 的大小
    atlasSize = size(atlas);
    
    % 进行坐标映射，将 atlas 的坐标映射到 ben 的上
    % 这里 linspace 将 atlas 的分辨率映射到 ben 的分辨率
    Xq = round(linspace(1, size(ben, 1), atlasSize(1)));
    Yq = round(linspace(1, size(ben, 2), atlasSize(2)));
    Zq = round(linspace(1, size(ben, 3), atlasSize(3)));

    % 遍历每个脑区
    for region = 1:num_regions
        % 找到 atlas 中当前脑区的所有坐标（忽略0值的点）
        region_mask = atlas == region & atlas ~= 0;

        % 如果该脑区有体素，则对体素进行处理
        if any(region_mask(:))
            % 将 atlas 的每个体素映射到 ben 上
            mapped_ben_values = ben(Xq(region_mask), Yq(region_mask), Zq(region_mask));
            
            % 忽略 ben 文件中的 0 值
            mapped_ben_values = mapped_ben_values(mapped_ben_values ~= 0);
            
            % 计算当前脑区的平均 ben 值
            if ~isempty(mapped_ben_values)
                region_mean_ben(sub_idx, region) = mean(mapped_ben_values);
            else
                region_mean_ben(sub_idx, region) = NaN;  % 如果脑区没有有效数据，填充 NaN
            end
        else
            region_mean_ben(sub_idx, region) = NaN;  % 如果脑区没有体素，填充 NaN
        end
    end
end

% 保存结果矩阵
%save('region_mean_ben.mat', 'region_mean_ben');
% 将结果保存为 .tsv 文件
tsv_filename = 'region_mean_ben.tsv';
writematrix(region_mean_ben, tsv_filename, 'Delimiter', '\t');
