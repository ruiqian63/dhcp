% 加载 NIfTI 文件
nii = niftiread('sub-CC00056XX07_AAL_t2.nii.gz');
hdr = niftiinfo('sub-CC00056XX07_AAL_t2.nii.gz');

% 查看原始图像尺寸
originalSize = size(nii);
disp(['Original size: ', num2str(originalSize)]);

% 重新采样到目标尺寸 68x67x45
newSize = [68, 67, 45];
resizedImage = imresize3(nii, newSize);

% 修改头信息中的 ImageSize 字段
hdr.ImageSize = newSize;

% 保存结果为新的 NIfTI 文件
niftiwrite(resizedImage, 'resized_AAL_UNCneo.nii', hdr);
