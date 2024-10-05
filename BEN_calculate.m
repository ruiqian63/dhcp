%%BENcalculator
%for a = 0:2
%fileroot=sprintf('E:/wmm_BEN/batch1/RAW_bpf/w%d/post',a);
%targetroot=sprintf('E:/wmm_BEN/batch1/BENoutput_bpf/w%d/post',a);
fileroot='E:/wmm_BEN/batch1/RAW_bpf/1m';
targetroot='E:/wmm_BEN/batch1/BENoutput_bpf/1m';
files=dir(fileroot);

for i=3:length(files)
    filepath=strcat(fileroot,filesep,files(i).name,filesep,'Filtered_4DVolume.nii');
    [v,h]=y_Read(filepath);
    dat=v;
    tlen=size(dat,4);
    dat=reshape(dat,size(dat,1)*size(dat,2)*size(dat,3),size(dat,4));
    loc=size(dat,1);
    datfile=fullfile(targetroot,'braindat.dat');
    std_d=std(dat,0,2);
    dat=dat';
    r=0.3;    % if the BEN map is nearly zero everywhere, increase r to be 0.6 here    
    dim=3;
    
    fid=fopen(datfile,'wb');
    fwrite(fid, loc, 'int');
    fwrite(fid, tlen, 'int');
    fwrite(fid, std_d, 'float');
    fwrite(fid, dat, 'float');
    fclose(fid);
        
    if isunix
        str=['C:\Program Files\MATLAB\R2022b\toolbox\BENtbx\SampEn -d ' num2str(dim) ' -r ' num2str(r) ' -i ' datfile  ' -o SEN.dat '];
        eval(str);
    else
        str=['sampen.exe -d ' num2str(dim) ' -r ' num2str(r) ' -i ' datfile  ' -o SEN.dat '];
        system(str);
    end
    
    fid=fopen('SEN.dat','rb');
    slen=fread(fid, 1, 'int');
    dim=fread(fid, 1, 'int');
    ratio=fread(fid, 1, 'float');
    sSEN=fread(fid, slen, 'float');
    aSEN=fread(fid, slen, 'float');
    fclose(fid);
    
    sSEN=sSEN*1e3;
    benmap=reshape(sSEN,size(v,1),size(v,2),size(v,3));
    % mask .*
    maskroot='E:\testdata\mask\allmask.nii';
    mask1=niftiread(maskroot);
    mask=im2double(mask1);
    benmap=benmap.*mask;
    targetpath=strcat(targetroot,filesep,'BEN_',files(i).name);
    y_Write(benmap,h,targetpath);
    delete(datfile);
end
%end


        
