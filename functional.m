basepath = '/users/username/final_data';
addpath('/users/username/final_data')
addpath('/users/username/CONN/SPM12')
dirs = [1:24]; % excellent find . -name  'd1*' -type d | sort -t \0 >>dirs_epi.txt

% DIRS IS IMPORTANT BECAUSE IT WILL DETERMINE LOOPING- CHECK WITH Un and Wn
%struct = importfile_func(fullfile(basepath,'xstruct.txt')); %remember the struct
func = importfile_func(fullfile(basepath,  'funcfile.txt')); % change these accordingly to your file structure etc. find . -name 1*_0*_0*.nii  | sort -t \0 >EPI_stage_func.txt
%for mild data


%funcdir = fullfile(basepath,func);
funcdir = fullfile(basepath, func)
%funcdir{1} = ''
u=6;%remember to change these according to if you want to exclude scans and no of scancs
w=300;% change u and ws all over according to scans
spm_jobman('initcfg');




for i = 1:length(dirs)
    clear matlabbatch
    matlabbatch{1}.spm.temporal.st.scans = {funcdir(u:w)};
    matlabbatch{1}.spm.temporal.st.nslices = 32;
    matlabbatch{1}.spm.temporal.st.tr = 2;
    matlabbatch{1}.spm.temporal.st.ta = 1.9375;
    matlabbatch{1}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32];
    matlabbatch{1}.spm.temporal.st.refslice = 17;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    disp (['slicetimming_correction'])
    spm_jobman('run', matlabbatch);
    u = (i*300)+(6) %plus 6 if you want to exclude scans? check before running!
    w = 300*(i+1)
    save ('matlabbatch')
end


split1= regexp(funcdir, '/', 'split');
for s = 1:length(funcdir);
%     if s == 1
%          a4_funcdir(s,1) =(split1{s,1}(:,10));
%           a_funcfile(s,1) = strcat('a' , a4_funcdir(s));
%     a1_funcdir(s,1) = (split1{s,1}(:,7));
%     a2_funcdir(s,1) = (split1{s,1}(:,8));
%     a3_funcdir(s,1) = (split1{s,1}(:,9));
%     else
    a4_funcdir(s,1) =(split1{s,1}(1,10));
    a_funcfile(s,1) = strcat('a' , a4_funcdir(s));
    a1_funcdir(s,1) = (split1{s,1}(1,6));
    a2_funcdir(s,1) = (split1{s,1}(:,7));
    a3_funcdir(s,1) = (split1{s,1}(:,8));
    a9_funcdir(s,1) = (split1{s,1}(:,9));
end

afuncdir = fullfile (basepath,   a3_funcdir, a9_funcdir, a_funcfile);
u1=6;
w1=300;

for n = 1:length(dirs)
    clear matlabbatch
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {afuncdir(u1:w1)};
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    disp (['realignment'])
    spm_jobman('run', matlabbatch);
    u1 = (n*300)+(6)
    w1 = 300*(n+1)
    save ('matlabbatch')
end


n1=6;
for s = 1:length(dirs);
%      if s == 1
%     funcfile0000(s,1) =(split1{n1,1}(1,10)); 
%     meana_funcfile(s,1) = strcat('meana' , funcfile0000(s));
%     n1 = (s * 150) +1;
%      else
    funcfile0000(s,1) =(split1{n1,1}(1,10));
    meana_funcfile(s,1) = strcat('meana' , funcfile0000(s));
   
    da1_funcdir(s,1) = (split1{n1,1}(1,6));
    da2_funcdir(s,1) = (split1{n1,1}(:,7));
    da3_funcdir(s,1) = (split1{n1,1}(:,8));
    da9_funcdir(s,1) = (split1{n1,1}(:,9));
    n1 = (s * 300) +6;
end

pwd
for s4 = 1:length(funcdir);
    
    a5_funcdir(s4,1) =(split1{s4,1}(:,10));
    ra_funcfile(s4,1) = strcat('ra' , a5_funcdir(s4));
end

raFuncDir = fullfile (basepath,  a3_funcdir, a9_funcdir, ra_funcfile);

meanDir = fullfile(basepath,  da3_funcdir, da9_funcdir, meana_funcfile);


u2=6;
w2=300;

for j = 1:length(dirs) % put ('a') directories with struct %%   :   length(structDir)
    clear matlabbatch
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.source = meanDir(j);
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.resample = raFuncDir(u2:w2);
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.template = {'/home/users/username/final_data/EPI.nii,1'};
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smoref = 0;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.nits = 16;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.vox = [2 2 2];
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';
    disp (['norms'])
    spm_jobman('run', matlabbatch);
    u2 = (j*300)+(6)
    w2 = 300*(j+1) 
    save ('matlabbatch')
end

for s5 = 1:length(funcdir);
    a7_funcdir(s5,1) =(split1{s5,1}(:,10));
    wra_funcfile(s5,1) = strcat('wra' , a7_funcdir(s5));
end

wraFuncDir = fullfile (basepath,    a3_funcdir, a9_funcdir, wra_funcfile);
u3=6;
w3=300;

for j1 = 1:length(dirs)
    clear matlabbatch
    matlabbatch{1}.spm.spatial.smooth.data = wraFuncDir(u3:w3);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    disp (['smoooooth'])
    spm_jobman('run', matlabbatch);
    save ('matlabbatch')
    u3 = (j1*300)+(6)
    w3 = 300*(j1+1)
end
disp (['done'])