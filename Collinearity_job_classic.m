% List of open inputs
% fMRI model specification (design only): Directory - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'/Users/cecconi/Desktop/DISCONNECTEDNESS PROJECT - Liege/GITHUB_EA/Collinearity/Collinearity_job_classic_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification (design only): Directory - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
