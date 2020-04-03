%% PIPELINE DEANE 2020 \m/(>.<)\m/

% By: Katrina Deane; katrina.deane@lin-magdeburg.de

% This code is intended only for use with the Data specifically for
% Deane et al. 2020 (Anesthetized, Awake10dB, and Muscimol).
% Any other Data run through here will require manual edits and seperate scripts.

% Please ensure that any external files are not in main folders groups or
% Data. Files generated from the output folder are called manually; all
% other input is dynamic and will attempt to run whatever is inside the
% main folder.

% If everything is properly called and output, this entire pipeline
% generates all statistics and plots used for Deane et al 2020. Please cite
% us if you use these scripts :)

%% Start
clear; clc;

% add your directory to the list OR comment this step and simply start in
% the correct directory 
if exist('D:\MyCode\Deane2020_JPhys','dir') == 7
    cd('D:\MyCode\Deane2020_JPhys');
elseif exist('C:\Users\kedea\Documents\Work Stuff\Deane2020_JPhys','dir') == 7
    cd('C:\Users\kedea\Documents\Work Stuff\Deane2020_JPhys')
end

homedir = pwd;
addpath(genpath(homedir));

%% Group creation

%Input:     sink_dura_single.m and several other edited functions
%Output:    Figures of all single animals in "Single..." folder 
%           Data.mat files in Data folder
Dynamic_CSD_Inf_single(homedir)

%% Group Sorting

%Input:     D:\MyCode\Dynamic_CSD_Analysis\Data -> *Data.mat; (bin, zscore,
%           mirror)
%Output:    Figures of groups in "Group..." folder 
%           .mat files in Data/Output folder
%           AVG Data
GroupAnalysis_fnc_singlecondition(1,0,0,homedir); 

%% Permutation analysis of CSD profiles

cd(homedir);
diary permutation_readout 

%Input:     Dynamic_CSD\Data\; specifically (not automatically) called
%Output:    is placed in figs - PermuteCSDs; observed difference matrix,
%           observed t matrix, observed cluster matrix in .fig / the
%           observed vs permustation curves across frequency bins in .pdf
%           and .png (grammplots), ALSO the stats output calculated in .mat
PermutationTestCSD(homedir)

diary off
%% Tuning curves

cd(homedir);
diary sinktuning_readout

% Input:    Dynamic_CSD\Data\Output -> *.mat 
% IMPORTANT:Command window needs to be copy/pasted to carry info from
%           post-hoc tests. This is done with the diary function here
% Output:   *.mat files in Data\Stats\
Stats_Loop_5Freq(homedir) %St with +-2 & cohen's d

diary off

% Input:     Dynamic_CSD\Data\Output -> *.mat 
% Output:    gramm plots for all tuning curves in "Group grammplots ST"
grammplots(homedir)

% USE (i.e) grammcombo_4sinks.m to visualize multiple tuning curves. Go
% there directly to control which sinks and in which paramter you would
% like to output 
% commented to not destroy a full run-through:
% open('grammcombo_4sinks.m') 

%% AvRec

%Input:     Deane2020_JPhys\Data -> *Data.mat; 
%Output:    a carry over .mat and pictures in Deane2020_JPhys\Data\avrec_compare
AvrecFigs(homedir)

cd(homedir);
diary avrec_readout

%STATS:
% Input:    Deane2020_JPhys\Data -> *Data.mat 
% IMPORTANT:Command window needs to be copy/pasted to carry info from
%           post-hoc tests. This is done with the diary function here
% Output:   Single frequency bin and tuning curve statistics (p and cohen's
%           d values) into \Data\Stats*
AvrecStats(homedir)

diary off

% folder:   Deane2020_JPhys\Data\avrec_compare
% Input:    stats from single trial avrec and relres 
% Output:   BrownScyth statistical comparison of variances; box plots and
%           stats saved as pictures
BrownScyth(homedir)

%% Spectral Analysis

% Input:    Deane2020_JPhys\Data -> *Data.mat; manually called
% Output:   Runs CWT analysis using the Wavelet toolbox. figures of
%           animal-wise scalograms -> Deane2020_JPhys\figs\Spectral_MagPlot
%           and table 'scalograms.mat' with all Data -> Deane2020_JPhys\Data\Spectral
CSD_allLayers_scalogram(homedir)

% Input:    Deane2020_JPhys\Data -> *Data.mat; manually called
% Output:   Runs CWT analysis using the Wavelet toolbox. figures of
%           animal-wise scalograms -> Deane2020_JPhys\figs\Spectral_AngPlot
%           and table 'STscalograms_*.mat' with Data -> Deane2020_JPhys\Data\Spectral
CSD_allLayers_scalogram_SnglT(homedir)

 %% Run Permutation Magnitude
rel2BFin = [0 -2];
layerin = {'I_IIE','IVE','VbE','VIaE';};
for rel2BF = 1:length(rel2BFin)
    for layer = 1:length(layerin)

    % Input:    Layer to analyze, relative to BF
    %           Deane2020_JPhys\Data\scalograms.mat
    % Output:   Figures for means and observed difference of awake/ketamine
    %           comparison; figures for observed t values, clusters, ttest line
    %           output; boxplot and significance of permutation test ->
    %           Deane2020_JPhys\figs\Spectral_MagPerm and
    %           Deane2020_JPhys\Data\Spectral\MagPerm
    PermutationTestScalogram(layerin{layer},rel2BFin(rel2BF),homedir)
        

    % Input:    Layer to analyze, relative to BF
    %           Deane2020_JPhys\Data\scalograms.mat
    % Output:   Figures for cohen's D of observed difference of awake/ketamine
    %           comparison;  -> Deane2020_JPhys\figs\Spectral_MagPerm
    cohensDScalogram(layerin{layer},rel2BFin(rel2BF),homedir)

    end
end

%% Run Permutation Phase Coherence
% Input:    matrix to load, layer and rel2BF as a name
%           Deane2020_JPhys\Data\STscalograms_*.mat
% Output:   Figures for means and observed difference of awake/ketamine
%           comparison; figures for observed t values, clusters, ttest line
%           output; boxplot and significance of permutation test -> Pictures 
%           folder -> phase permutations

% please note that this code takes an enourmously long time to run
PermutationTest_PhaseCoh('STscalograms_IIBF.mat',' I_II BF',homedir)
PermutationTest_PhaseCoh('STscalograms_IVBF.mat',' IV BF',homedir)
PermutationTest_PhaseCoh('STscalograms_VbBF.mat',' Vb BF',homedir)
PermutationTest_PhaseCoh('STscalograms_VIaBF.mat',' VIa BF',homedir)

PermutationTest_PhaseCoh('STscalograms_IIoffBF.mat',' I_II off BF',homedir)
PermutationTest_PhaseCoh('STscalograms_IVoffBF.mat',' IV off BF',homedir)
PermutationTest_PhaseCoh('STscalograms_VboffBF.mat',' Vb off BF',homedir)
PermutationTest_PhaseCoh('STscalograms_VIaoffBF.mat',' VIa off BF',homedir)

%% End
