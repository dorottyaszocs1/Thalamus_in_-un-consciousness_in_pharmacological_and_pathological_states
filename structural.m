

basepath = '/users/username/final_data';
addpath('/users/username/final_data')
addpath('/username/CONN/SPM12')
% dirs = importfile(fullfile(basepath,'dirs.txt')); 
% excellent find . -name  'd1*' -type d | sort -t \0 >>dirs_epi.txt

% DIRS IS IMPORTANT BECAUSE IT WILL DETERMINE LOOPING- CHECK WITH Un and Wn
%struct = importfile_func(fullfile(basepath,'xstruct.txt')); %remember the struct
func = importfile_func(fullfile(basepath,  'funcfile.txt')); % chanhe these accordingly to your file structure etc. find . -name 1*_0*_0*.nii  | sort -t \0 >EPI_stage_func.txt


struct = importfile_func(fullfile(basepath,'textile2.txt'));
%% s
%struct!!!!


funcdir = fullfile(basepath,func);
%funcdir{1} = ''
u=6;%remember to change these according to if you want to exclude scans and no of scancs
w=300;% change u and ws all over according to scans
spm_jobman('initcfg');

structDir=fullfile(basepath, struct);

split1= regexp(funcdir, '/', 'split');

n1=6;
for s = [1:24];
%      if s == 1
%     funcfile0000(s,1) =(split1{n1,1}(1,10)); 
%     meana_funcfile(s,1) = strcat('meana' , funcfile0000(s));
%     n1 = (s * 251) +1;
%      else
    funcfile0000(s,1) =(split1{n1,1}(1,10));
    meana_funcfile(s,1) = strcat('meana' , funcfile0000(s));
   
    da1_funcdir(s,1) = (split1{n1,1}(1,6));
    da2_funcdir(s,1) = (split1{n1,1}(:,7));
    da3_funcdir(s,1) = (split1{n1,1}(:,8));
    da9_funcdir(s,1) = (split1{n1,1}(:,9));
    n1 = (s * 300) +6;
end





meanDir = fullfile(basepath,  da3_funcdir, da9_funcdir, meana_funcfile);



for j = 1: length (structDir) % put ('a') directories with struct %%   :   length(structDir)
    clear matlabbatch
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = meanDir(j);
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = structDir(j);
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
%     disp (['corej', dirs(j)])
    spm_jobman('run', matlabbatch);
    save ('matlabbatch')
end



split2= regexp(structDir, '/', 'split');
for s1 = 1:length(structDir);
    a3_structDir(s1,1) =(split2{s1,1}(:,10));
    a1_structDir(s1,1) =(split2{s1,1}(:,8));
    rx_strFile(s1,1) = strcat('r' , a3_structDir(s1));
    rx_Structdir(s1,1) = (split2{s1,1}(:,7));
end

rxStruct_Dir = fullfile (basepath, a1_structDir, 'struc', rx_strFile);


for j1 = 1 :length(rxStruct_Dir)
    clear matlabbatch
    matlabbatch{1}.spm.spatial.preproc.channel.vols = rxStruct_Dir(j1);
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/home/username/CONN/SPM12/tpm/TPM.nii,1'};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/home/username/CONN/SPM12/tpm/TPM.nii,2'};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'//home/username/CONN/SPM12/tpm/TPM.nii,3'};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/home/username/CONN/SPM12/tpm/TPM.nii,4'};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/home/username/CONN/SPM12/tpm/TPM.nii,5'};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/home/username/CONN/SPM12/tpm/TPM.nii,6'};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
%     disp (['segment', dirs(j1)])
    spm_jobman('run', matlabbatch);
    save ('matlabbatch')
end




for s6 = 1:length(structDir);
   
    y_rx_strFile(s6,1) = strcat('y_r' , a3_structDir(s6));% put iy_r if you want inverse transformation
    y_rx_Structdir(s6,1) = (split2{s6,1}(:,7));
end
y_rxStruct_Dir = fullfile (basepath, a1_structDir, 'struc', y_rx_strFile);
 

for j4 = 1:length(y_rxStruct_Dir)
 clear matlabbatch
matlabbatch{1}.spm.spatial.normalise.write.subj.def = y_rxStruct_Dir(j4);
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = rxStruct_Dir(j4);
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
% disp (['warped', dirs(j4)])
spm_jobman('run', matlabbatch);
save ('matlabbatch')
end 
