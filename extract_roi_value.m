% 加载 Atlas (196*238*197)
atlas = niftiread('C:\Users\qian''rui\Downloads\AAL_UNCneo_in_extdhcp40wk.nii.gz');

% 原始 Atlas 的尺寸
atlasSize = size(atlas);

% 假设有一个配准好的大脑图像，尺寸为 (68*67*45)
% 使用其配准后的坐标来索引 Atlas
% 你需要定义好这些索引，假设这些索引已经给定或计算出来

% 例如，假设你有对齐后大脑图像每个点对应在原始 Atlas 中的索引：
% 这些索引可以根据配准映射得出
Xq = round(linspace(1, atlasSize(1), 68));  % 对应的 x 轴索引
Yq = round(linspace(1, atlasSize(2), 67));  % 对应的 y 轴索引
Zq = round(linspace(1, atlasSize(3), 45));  % 对应的 z 轴索引

% 使用这些索引直接从 Atlas 中提取数据
extracted_atlas = atlas(Xq, Yq, Zq);

% 加载头文件信息
hdr = niftiinfo('C:\Users\qian''rui\Downloads\AAL_UNCneo_in_extdhcp40wk.nii.gz');

% 更新头文件的 ImageSize，匹配目标大脑图像尺寸
hdr.ImageSize = [68, 67, 45];

% 保存结果为新的 NIfTI 文件
niftiwrite(extracted_atlas, 'extracted_AAL_UNCneo_to_brain.nii', hdr);
