addpath('~/BrainNetViewer_20191031')
addpath('/Users/username/spm12')
wk_dir = '/Users/username/anaesthesia/anaesthesiafirstlevel';
cd(wk_dir)
%%
sourcenumber = 193:199;
nThal = length(sourcenumber);
nSubj = 16;
output_mat_dFC = zeros(nSubj, nThal);

for col = 1:nThal
    thalamic_nuclei = sprintf('Source%03d', sourcenumber(col));
    disp(thalamic_nuclei)
    for nr = 1:nSubj
        sbj_name = sprintf('Subject%03d', nr);
        disp(sbj_name)
        fn0 = sprintf('%s/BETA_%s_Condition001_%s.nii', wk_dir, sbj_name, thalamic_nuclei);
        HeaderInfo = spm_vol(fn0);
        dat0 = spm_read_vols(HeaderInfo);
        % experimental condition
        fn1 = sprintf('%s/BETA_%s_Condition003_%s.nii', wk_dir, sbj_name, thalamic_nuclei);
        HeaderInfo = spm_vol(fn1);
        dat1 = spm_read_vols(HeaderInfo);
        % do a contrast between them
        dFC = dat1-dat0;
        dFC_zscore = abs(dFC)/std(abs(dat0),0, 'all','omitnan');
        dFC_1 = std(dFC_zscore,0,"all","omitnan");
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
writetable(T, '/Users/username/anaesthesia.csv');




