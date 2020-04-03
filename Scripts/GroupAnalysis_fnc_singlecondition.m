function GroupAnalysis_fnc_singlecondition(bin, zscore, mirror, homedir)
% This function asks if it should bin (1 or 0), take zscore (1 or 0), or
% mirror (1 or 0)

% This group analysis deals only with obtaining group data for animals with
% one condition/one measurement

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

cd (homedir); cd Data;
input = dir('*.mat');
entries = length(input);
nThresh = 0.25; % Threshold for animals

%cell of target output features
para = { 'SinkRMS', 'SinkINT', 'init_Peak_BF_tune', 'SinkDur',...
    'Sinkonset', 'Sinkoffset','SinkPeakAmp','SinkPeakLate','IntCurFlow'};

SINKs = {'VbE', 'IVE', 'VIaE', 'VIbE', 'VaE', 'I_IIE','VbL', 'IVL', 'VIaL', 'VIbL', 'VaL', 'I_IIL'};

for i1 = 1:entries
    %% Preliminary functions
    disp(['Analyzing Group: ' (input(i1).name(1:end-9))])
    tic
    load (input(i1).name) %loads data into workspace
    
    cd(homedir); cd Figs; %opens figure folder to store future images
    mkdir(['Group_' input(i1).name(1:end-9)]); %adds folder to directory
    
    names = fieldnames(Data); %list of animal names
    DimDat = length(Data);
    
    %to determine where the BF should be placed (i.e. the length of the longest frequency list)
    BF_Pos = length(Data(1).(names{1}).Frqz);
    
    NumFreq = (BF_Pos*2)-1; %so that BF_Pos is center
    if BF_Pos == 8
        bfposticks = {'-7' '-6' '-5' '-4' '-3' '-2' '-1' 'BF' '+1' '+2' '+3' '+4' '+5' '+6'};
    elseif BF_Pos == 7
        bfposticks = {'-6' '-5' '-4' '-3' '-2' '-1' 'BF' '+1' '+2' '+3' '+4' '+5' '+6'};
    else
        bfposticks = {'not' 'acc' 'ur' 'ate' 'ly' 'tick' 'lab' 'eled'};
    end
    
    % Granular BF based
    [Data_GSBased,~] = Groupsorting(Data,names,para, DimDat,SINKs,NumFreq,'GS',mirror,nThresh,bin);
    %[sData_GSBased] = Groupsorting_single(Data,names,singletrialpara, DimDat,SINKs,NumFreq,'GS');
    
    % Selftuning based (BF of each layer determined and used)
    [Data_STBased,ST_Shift] = Groupsorting(Data,names,para, DimDat,SINKs,NumFreq,'ST',mirror,nThresh,bin);
    %[sData_STBased] = Groupsorting_single(Data,names,singletrialpara, DimDat,SINKs,NumFreq,'ST');
    
    if zscore == 1
        [Zscrd_DATA_GS,~] = ParaZScore(Data_GSBased, para, SINKs,PRE,nThresh,'bin');
        [Zscrd_DATA_ST,~] = ParaZScore(Data_STBased, para, SINKs,PRE,nThresh,'bin');
        
        Data_GSBased = Zscrd_DATA_GS;
        Data_STBased = Zscrd_DATA_ST;
    end
    
    %% plot Tuning Curves GS Avg
    Tuning = {'SinkPeakAmp', 'SinkRMS'};
    h=figure('units','normalized','outerposition',[0 0 1 1], 'Name','Avg Tuning Curves GS');
    
    for it = 1:length(Tuning)
    I_IIL = nanmean(Data_GSBased.(Tuning{it}).I_IIL,1);
    IV = nanmean(Data_GSBased.(Tuning{it}).IVE,1);
    Va = nanmean(Data_GSBased.(Tuning{it}).VaE,1);
    Vb = nanmean(Data_GSBased.(Tuning{it}).VbE,1);
    VIaE = nanmean(Data_GSBased.(Tuning{it}).VIaE,1);
    VIaL = nanmean(Data_GSBased.(Tuning{it}).VIaL,1);
    VIbE = nanmean(Data_GSBased.(Tuning{it}).VIbE,1);
    VIbL = nanmean(Data_GSBased.(Tuning{it}).VIbL,1);
    
    semI_II = nanstd(Data_GSBased.(Tuning{it}).I_IIL,1)/sqrt(sum(~isnan(I_IIL)));
    semIV = nanstd(Data_GSBased.(Tuning{it}).IVE,1)/sqrt(sum(~isnan(IV)));
    semVa = nanstd(Data_GSBased.(Tuning{it}).VaE,1)/sqrt(sum(~isnan(Va)));
    semVb = nanstd(Data_GSBased.(Tuning{it}).VbE,1)/sqrt(sum(~isnan(Vb)));
    semVIaE = nanstd(Data_GSBased.(Tuning{it}).VIaE,1)/sqrt(sum(~isnan(VIaE)));
    semVIaL = nanstd(Data_GSBased.(Tuning{it}).VIaL,1)/sqrt(sum(~isnan(VIaL)));
    semVIbE = nanstd(Data_GSBased.(Tuning{it}).VIbE,1)/sqrt(sum(~isnan(VIbE)));
    semVIbL = nanstd(Data_GSBased.(Tuning{it}).VIbL,1)/sqrt(sum(~isnan(VIbL)));
    
    subplot(1,length(Tuning),it)
    errorbar(I_IIL,semI_II,'LineWidth',2); hold on; 
    errorbar(IV,semIV,'LineWidth',2);
    errorbar(Va,semVa,'LineWidth',2);
    errorbar(Vb,semVb,'LineWidth',2);
    errorbar(VIaE,semVIaE,'LineWidth',2);
    errorbar(VIaL,semVIaL,'LineWidth',2);
    errorbar(VIbE,semVIbE,'LineWidth',2);
    errorbar(VIbL,semVIbL,'LineWidth',2);
    set(gca,'XTick',1:1:15); set(gca,'XTickLabel',bfposticks,'FontSize',8);
    legend('I.II Late','IV Early','Va Early','Vb Early','VIa Early','VIa Late','VIb Early','VIb Late')
    ylabel(Tuning{it},'FontSize',14,'FontWeight','bold');
    xlabel('Tone','FontSize',8);
    end
    
    title('Avg Sink Tuning Curves','FontSize',20,'FontWeight','bold');
    cd([homedir '\Figs\' 'Group_' input(i1).name(1:end-9)]);
    savefig(h,[input(i1).name(1:end-4), ' Avg Tuning Curves GS']); close all
    
    %% plot Latency Curves GS Avg
    LTuning = {'Sinkonset','SinkPeakLate'};
    h=figure('units','normalized','outerposition',[0 0 1 1], 'Name','Latency Curves GS');    
    
    for it = 1:length(LTuning)
    IV = nanmean(Data_GSBased.(LTuning{it}).IVE,1);
    Va = nanmean(Data_GSBased.(LTuning{it}).VaE,1);
    Vb = nanmean(Data_GSBased.(LTuning{it}).VbE,1);
    VIa = nanmean(Data_GSBased.(LTuning{it}).VIaE,1);
    

    semIV = nanstd(Data_GSBased.(LTuning{it}).IVE,1)/sqrt(sum(~isnan(IV)));
    semVa = nanstd(Data_GSBased.(LTuning{it}).VaE,1)/sqrt(sum(~isnan(Va)));
    semVb = nanstd(Data_GSBased.(LTuning{it}).VbE,1)/sqrt(sum(~isnan(Vb)));
    semVIa = nanstd(Data_GSBased.(LTuning{it}).VIaE,1)/sqrt(sum(~isnan(VIa)));

    subplot(1,length(Tuning),it)
    errorbar(IV,semIV,'LineWidth',2); hold on; 
    errorbar(Va,semVa,'LineWidth',2);
    errorbar(Vb,semVb,'LineWidth',2);
    errorbar(VIa,semVIa,'LineWidth',2);
    set(gca,'XTick',1:1:15); set(gca,'XTickLabel',bfposticks,'FontSize',8);
    legend('IV Early','Va Early','Vb Early','VIa Early')
    ylabel(LTuning{it},'FontSize',14,'FontWeight','bold');
    xlabel('Tone','FontSize',8);
    end
    
    title('Latency Curves','FontSize',20,'FontWeight','bold');
    cd([homedir '\Figs\' 'Group_' input(i1).name(1:end-9)]);
    savefig(h,[input(i1).name(1:end-4), ' Avg Latency Curves GS']); close all
    
  %% plot Tuning Curves ST Avg
    h=figure('units','normalized','outerposition',[0 0 1 1], 'Name','Avg Tuning Curves ST');
    
    for it = 1:length(Tuning)
    I_IIL = nanmean(Data_STBased.(Tuning{it}).I_IIL,1);
    IV = nanmean(Data_STBased.(Tuning{it}).IVE,1);
    Va = nanmean(Data_STBased.(Tuning{it}).VaE,1);
    Vb = nanmean(Data_STBased.(Tuning{it}).VbE,1);
    VIaE = nanmean(Data_STBased.(Tuning{it}).VIaE,1);
    VIaL = nanmean(Data_STBased.(Tuning{it}).VIaL,1);
    VIbE = nanmean(Data_STBased.(Tuning{it}).VIbE,1);
    VIbL = nanmean(Data_STBased.(Tuning{it}).VIbL,1);
    
    semI_II = nanstd(Data_STBased.(Tuning{it}).I_IIL,1)/sqrt(sum(~isnan(I_IIL)));
    semIV = nanstd(Data_STBased.(Tuning{it}).IVE,1)/sqrt(sum(~isnan(IV)));
    semVa = nanstd(Data_STBased.(Tuning{it}).VaE,1)/sqrt(sum(~isnan(Va)));
    semVb = nanstd(Data_STBased.(Tuning{it}).VbE,1)/sqrt(sum(~isnan(Vb)));
    semVIaE = nanstd(Data_STBased.(Tuning{it}).VIaE,1)/sqrt(sum(~isnan(VIaE)));
    semVIaL = nanstd(Data_STBased.(Tuning{it}).VIaL,1)/sqrt(sum(~isnan(VIaL)));
    semVIbE = nanstd(Data_STBased.(Tuning{it}).VIbE,1)/sqrt(sum(~isnan(VIbE)));
    semVIbL = nanstd(Data_STBased.(Tuning{it}).VIbL,1)/sqrt(sum(~isnan(VIbL)));
    
    subplot(1,length(Tuning),it)
    errorbar(I_IIL,semI_II,'LineWidth',2); hold on; 
    errorbar(IV,semIV,'LineWidth',2);
    errorbar(Va,semVa,'LineWidth',2);
    errorbar(Vb,semVb,'LineWidth',2);
    errorbar(VIaE,semVIaE,'LineWidth',2);
    errorbar(VIaL,semVIaL,'LineWidth',2);
    errorbar(VIbE,semVIbE,'LineWidth',2);
    errorbar(VIbL,semVIbL,'LineWidth',2);
    set(gca,'XTick',1:1:15); set(gca,'XTickLabel',bfposticks,'FontSize',8);
    legend('I.II Late','IV Early','Va Early','Vb Early','VIa Early','VIa Late','VIb Early','VIb Late')
    ylabel(Tuning{it},'FontSize',14,'FontWeight','bold');
    xlabel('Tone','FontSize',8);
    end
    
    title('Avg Sink Tuning Curves','FontSize',20,'FontWeight','bold');
    cd([homedir '\Figs\' 'Group_' input(i1).name(1:end-9)]);
    savefig(h,[input(i1).name(1:end-4), ' Avg Tuning Curves ST']); close all
    
    %% plot Latency Curves ST Avg
    LTuning = {'Sinkonset','SinkPeakLate'};
    h=figure('units','normalized','outerposition',[0 0 1 1], 'Name','Latency Curves GS');    
    
    for it = 1:length(LTuning)
    IV = nanmean(Data_STBased.(LTuning{it}).IVE,1);
    Va = nanmean(Data_STBased.(LTuning{it}).VaE,1);
    Vb = nanmean(Data_STBased.(LTuning{it}).VbE,1);
    VIa = nanmean(Data_STBased.(LTuning{it}).VIaE,1);
    

    semIV = nanstd(Data_STBased.(LTuning{it}).IVE,1)/sqrt(sum(~isnan(IV)));
    semVa = nanstd(Data_STBased.(LTuning{it}).VaE,1)/sqrt(sum(~isnan(Va)));
    semVb = nanstd(Data_STBased.(LTuning{it}).VbE,1)/sqrt(sum(~isnan(Vb)));
    semVIa = nanstd(Data_STBased.(LTuning{it}).VIaE,1)/sqrt(sum(~isnan(VIa)));
    
    subplot(1,length(Tuning),it)
    errorbar(IV,semIV,'LineWidth',2); hold on; 
    errorbar(Va,semVa,'LineWidth',2);
    errorbar(Vb,semVb,'LineWidth',2);
    errorbar(VIa,semVIa,'LineWidth',2);
    set(gca,'XTick',1:1:15); set(gca,'XTickLabel',bfposticks,'FontSize',8);
    legend('IV Early','Va Early','Vb Early','VIa Early')
    ylabel(LTuning{it},'FontSize',14,'FontWeight','bold');
    xlabel('Tone','FontSize',8);
    end
    
    title('Latency Curves','FontSize',20,'FontWeight','bold');    
    cd([homedir '\figs\' 'Group_' input(i1).name(1:end-9)]);
    savefig(h,[input(i1).name(1:end-4), ' Avg Latency Curves ST']); close all
    
   
    %% Save and Quit
    clear Data;
    cd(homedir); cd Data; 
    Data.GS_based = Data_GSBased;
    Data.ST_based = Data_STBased;
    Data.Shifts = ST_Shift;
    Data.names = names;
    Data.BF_Pos = BF_Pos;
    Data.Sinks = SINKs;
    
    cd (homedir); cd Data; cd Output;
    save([input(i1).name(1:end-2) '_Threshold_' num2str(nThresh) '_Zscore_' num2str(zscore) '_binned_' num2str(bin) '_mirror_' num2str(mirror) '.mat'],'Data')
    clear Data_GSBased Data Data_STBased ST_Shift
    cd (homedir); cd Data;
    
    toc    
end