addpath('~/BrainNetViewer_20191031')
addpath('/Users/username/spm12')
wk_dir = '/Users/username/doc';

cd(wk_dir)
%%
sourcenumber = 195:201;
nThal = length(sourcenumber);
nSubj = 38;
output_mat_dFC = zeros(nSubj, nThal);

for col = 1:nThal
    thalamic_nuclei = sprintf('Source%03d', sourcenumber(col));
    disp(thalamic_nuclei)

   for nr = 1:nSubj
        sbj_name = sprintf('Subject%03d', nr);
        disp(sbj_name)
        fn0 = sprintf('%s/docsecondlevel/Mask_Thal%d_%d/con_0001.nii', wk_dir, col, col+7);
        HeaderInfo = spm_vol(fn0);
        dat0 = spm_read_vols(HeaderInfo);
%         experimental condition
        fn1 = sprintf('%s/docfirstlevel/BETA_%s_Condition001_%s.nii', wk_dir, sbj_name, thalamic_nuclei);
        HeaderInfo = spm_vol(fn1);
        dat1 = spm_read_vols(HeaderInfo);
        %do a contrast between them (or do standard deviation)
        dFC = dat1-dat0;
        dFC_abs = abs(dFC);
        dFC_mean = mean(dFC_abs,"all",'omitnan'); 
        dFC_zscore = dFC_mean/(std(abs(dat0),0, 'all','omitnan'));
        dFC_1 = dFC_zscore
        %dFC_1 = zscore(abs(dFC),"all");
        %dFC_zscore = abs(dFC)/std(abs(dat0),0, 'all','omitnan');
        %dFC_1 = std(dFC_zscore,0, "all","omitnan");
        % a detour: write the dFC_norm into a file - visualise
        %{
HeaderInfo.fname = 'BETA_Subject016_Condition003vs001_zscore_change_magnitude.nii';
HeaderInfo.private.dat.fname = HeaderInfo.fname;
spm_write_vol(HeaderInfo, dFC_zscore);
        %}
        % put the calculate to the output mat
        output_mat_dFC(nr,col) = dFC_1;
    end
end

T = array2table(output_mat_dFC);
T.Properties.VariableNames = {'Pu', 'Ant', 'MD', 'VLD', 'CL-LP-MPu', 'VA', 'VLV'};
writetable(T, '/Users/username/doc_thalamus.csv')



;