function CSD_allLayers_scalogram(homedir)

% Input:    Dynamic_CSD\DATA -> *DATA.mat; manually called
% Output:   Runs CWT analysis using the Wavelet toolbox. figures of
%           animal-wise scalograms -> Dynamic_CSD\figs\Spectral_MagPlots
%           and table 'scalograms.mat' with all data -> Dynamic_CSD\DATA\Spectral

%% standard operations
warning('OFF');
dbstop if error

% Change directory to your working folder
if ~exist('homedir','var')
    if exist('D:\MyCode\Deane2020_JPhys','dir') == 7
        cd('D:\MyCode\Deane2020_JPhys');
    elseif exist('C:\Users\kedea\Documents\Work Stuff\Deane2020_JPhys','dir') == 7
        cd('C:\Users\kedea\Documents\Work Stuff\Deane2020_JPhys')
    end
    
    homedir = pwd;
    addpath(genpath(homedir));
end

cd(homedir)
%% INIT PARAMETERS

%close all
params.sampleRate = 1000; % Hz
params.startTime = -0.2; % seconds
params.timeLimits = [-0.2 0.399]; % seconds
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'I_IIE','IVE','VaE','VbE','VIaE','VIbE'};
params.rel2BFlist = [0 -2];

%% CWT analysis

[awake] = runCwtCsd('Awake10dB',params,homedir,'average');
[anest] = runCwtCsd('AnesthetizedPre',params,homedir,'average');
[musc]  = runCwtCsd('Muscimol',params,homedir,'average');

%% Reorganize data into Gramm-compatible structure

cd(homedir); cd Data; mkdir('Spectral'); cd('Spectral');
%Rotate structs
%awake = structfun(@(x) x',awake,'UniformOutput',false);
%anest= structfun(@(x) x',anest,'UniformOutput',false);
%musc= structfun(@(x) x',musc,'UniformOutput',false);

wtTable = [struct2table(awake); struct2table(anest); struct2table(musc)];
save('scalograms.mat','wtTable')
