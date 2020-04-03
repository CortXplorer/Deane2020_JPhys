function AvrecStats(homedir)

%  This script is SPECIFIC for running the AVREC stats for Katrina's
%  Master's thesis. It may be used as a template but please make a copy
%  elsewhere for modicifications

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

%for teg_repeated measures_ANOVA
levels = [2,1];

Ticks = {'a -3','b -2', 'c -1','d BF', 'e +1', 'f +2', 'g +3'};
Ticknames = {'BF-3', 'BF-2','BF-1','BF','BF+1', 'BF+2', 'BF+3'};
Group = {'Anesthetized','Awake','Muscimol','ANChronic'};
FromBF = [-3,-2,-1,0,+1,+2,+3];

%% Load in the appropriate files
cd(homedir);cd Data;
load('AnesthetizedPre_Data.mat','Data')
Anesthetized = Data; clear Data;
load('Awake10dB_Data.mat','Data')
Awake = Data; clear Data;
load('Muscimol_Data.mat','Data')
Muscimol = Data; clear Data;

mkdir('AvRecStats'); cd AvRecStats
%% Run Stats

plottune = struct;
plottuner = struct;
%for tuning curves
grpsz = 550;
plottune.frqz = [];
plottune.tgroup = [];
plottune.peakamp = [];plottune.peaklate = [];plottune.peakvalue = [];plottune.totalmean = [];
plottuner.frqz = [];
plottuner.tgroup = [];
plottuner.peakamp = [];plottuner.peaklate = [];plottuner.peakvalue = [];plottuner.totalmean = [];

for ifreq = 1:length(Ticks)
    
    disp(['***********************AVREC STATS FOR ' (Ticknames{ifreq}) '***********************'])
    % KETAMINE
    ANpeakamp = nan(1,grpsz); ANpeaklat = nan(1,grpsz); 
    ANtotalvalue = nan(1,grpsz); ANpeakvalue = nan(1,grpsz);
    ThisVec = 1:50;
    ANnames = fieldnames(Anesthetized);
    for i1 = 1:length(ANnames)
        animal = ANnames{i1};
        %Find the best frequency
        BF = find((Anesthetized.(ANnames{i1}).GS_BF) == (Anesthetized.(ANnames{i1}).Frqz'));
        
        try %cut out the section of the matrix necessary (BF, BF-1, etc)
            avreclist =  Anesthetized.(animal).SingleTrial_AVREC_raw{1,(BF+FromBF(ifreq))};
        catch %produce NAN if there isn't an entry here
            avreclist = NaN(1,length(avreclist));
        end
        
        peakampme = nan(1,50); peaklat = nan(1,50); 
        totalvalue = nan(1,50); peakvalue = nan(1,50);
        
        for i2 = 1:50
            if isnan(avreclist)
                continue
            else
                [latency, ampl, meanOfdata] = iGetPeakData_avrec(avreclist(:,:,i2),[200 300]);
                [~, ~, meanOffulldata] = iGetPeakData_avrec(avreclist(:,:,i2));
                peaklat(i2) = latency;
                peakampme(i2) = ampl;
                peakvalue(i2) = meanOfdata;
                totalvalue(i2) = meanOffulldata;
            end
        end
        
        %apply a cutoff threshold
        if sum(isnan(peakampme)) > length(peakampme)*.75 % 25% at least
            peakampme = nan(1,50);
            peaklat = nan(1,50);
            peakvalue = nan(1,50);
        end
        
        ANpeakamp(ThisVec) = peakampme;
        ANpeaklat(ThisVec) = peaklat;
        ANtotalvalue(ThisVec) = totalvalue;
        ANpeakvalue(ThisVec) = peakvalue;
        ThisVec = ThisVec + 50;
    end
        
    % AWAKE
    AWpeakamp = nan(1,grpsz); AWpeaklat = nan(1,grpsz); 
    AWtotalvalue = nan(1,grpsz); AWpeakvalue = nan(1,grpsz);
    ThisVec = 1:50;
    AWnames = fieldnames(Awake);
    for i1 = 1:length(AWnames)
        animal = AWnames{i1};
        BF = find((Awake.(AWnames{i1}).GS_BF) == (Awake.(AWnames{i1}).Frqz'));
        try
            avreclist =  Awake.(animal).SingleTrial_AVREC_raw{:,(BF+FromBF(ifreq))};
        catch
            avreclist = NaN(1,length(avreclist));
        end
        peakampme = nan(1,50); peaklat = nan(1,50); 
        totalvalue = nan(1,50); peakvalue = nan(1,50);
        for i2 = 1:50
            if isnan(avreclist)
                continue
            else
                try
                    [latency, ampl, meanOfdata] = iGetPeakData_avrec(avreclist(:,:,i2),[200 300]);
                    [~, ~, meanOffulldata] = iGetPeakData_avrec(avreclist(:,:,i2));
                    peaklat(i2) = latency;
                    peakampme(i2) = ampl;
                    peakvalue(i2) = meanOfdata;
                    totalvalue(i2) = meanOffulldata;
                catch
                    continue
                end
            end
        end
        
        %apply a cutoff threshold
        if sum(isnan(peakampme)) > length(peakampme)*.75 %&& ifreq ~=5 % 25% at least
            peakampme = nan(1,50);
            peaklat = nan(1,50);
            peakvalue = nan(1,50);
        end
        
        AWpeakamp(ThisVec) = peakampme;
        AWpeaklat(ThisVec) = peaklat;
        AWtotalvalue(ThisVec) = totalvalue;
        AWpeakvalue(ThisVec) = peakvalue;
        ThisVec = ThisVec + 50;
    end
    
    % MUSCIMOL
    Mpeakamp = nan(1,grpsz); Mpeaklat = nan(1,grpsz); 
    Mtotalvalue = nan(1,grpsz); Mpeakvalue = nan(1,grpsz);
    ThisVec = 1:50;
    Mnames = fieldnames(Muscimol);
    for i1 = 1:length(Mnames)
        animal = Mnames{i1};
        BF = find((Muscimol.(Mnames{i1}).GS_BF) == (Muscimol.(Mnames{i1}).Frqz'));
        try
            avreclist =  Muscimol.(animal).SingleTrial_AVREC_raw{:,(BF+FromBF(ifreq))};
        catch
            avreclist = NaN(1,length(avreclist));
        end
        peakampme = nan(1,50); peaklat = nan(1,50); 
        totalvalue = nan(1,50); peakvalue = nan(1,50);
        for i2 = 1:50
            if isnan(avreclist)
                continue
            else
                [latency, ampl, meanOfdata] = iGetPeakData_avrec(avreclist(:,:,i2),[200 300]);
                [~, ~, meanOffulldata] = iGetPeakData_avrec(avreclist(:,:,i2));
                peaklat(i2) = latency;
                peakampme(i2) = ampl;
                peakvalue(i2) = meanOfdata;
                totalvalue(i2) = meanOffulldata;
            end
        end
        
        %apply a cutoff threshold
        if sum(isnan(peakampme)) > length(peakampme)*.75 % 25% at least
            peakampme = nan(1,50);
            peaklat = nan(1,50);
            peakvalue = nan(1,50);
        end
            
        Mpeakamp(ThisVec) = peakampme;
        Mpeaklat(ThisVec) = peaklat;
        Mtotalvalue(ThisVec) = totalvalue;
        Mpeakvalue(ThisVec) = peakvalue;
        ThisVec = ThisVec + 50;
    end
      
    %for later tuning curves
    plottune.peakamp = horzcat(plottune.peakamp, ANpeakamp, AWpeakamp, Mpeakamp);
    plottune.peaklate = horzcat(plottune.peaklate, ANpeaklat, AWpeaklat, Mpeaklat);
    plottune.peakvalue = horzcat(plottune.peakvalue, ANpeakvalue, AWpeakvalue, Mpeakvalue);
    plottune.totalmean = horzcat(plottune.totalmean, ANtotalvalue, AWtotalvalue, Mtotalvalue);
    plottune.tgroup = horzcat(plottune.tgroup, repmat({Group{1}},1,grpsz), ...
        repmat({Group{2}},1,grpsz), repmat({Group{3}},1,grpsz)); %#ok<*CCAT1>
    plottune.frqz = horzcat(plottune.frqz, repmat({Ticks{ifreq}}, 1, grpsz), ...
        repmat({Ticks{ifreq}}, 1, grpsz), repmat({Ticks{ifreq}}, 1, grpsz));
    
    % Peak Amp
    disp('********Peak Amplitude********')
    peakamp_ANvsAW = horzcat(ANpeakamp', AWpeakamp');
    peakamp_ANvsM = horzcat(ANpeakamp', Mpeakamp');
    var_peakamp = {'Groups','Peak Amplitude'};
    
    disp('**Anesthetized vs Awake**')
    AnesthetizedvsAwake = teg_repeated_measures_ANOVA(peakamp_ANvsAW, levels, var_peakamp);
    disp('**Anesthetized vs Awake COHEN D**')
    ANvsAWcohenD = iMakeCohensD(ANpeakamp, AWpeakamp) %#ok<*NOPRT>
    disp('**Anesthetized vs Muscimol**')
    AnesthetizedvsMuscimol = teg_repeated_measures_ANOVA(peakamp_ANvsM, levels, var_peakamp);
    disp('**Anesthetized vs Muscimol COHEN D**')
    ANvsMcohenD = iMakeCohensD(ANpeakamp, Mpeakamp)
    
    savefile = [Ticknames{ifreq} 'PeakAmp STAvrecStats.mat'];
    save(savefile, 'AnesthetizedvsAwake', 'AnesthetizedvsMuscimol', ...
        'ANvsAWcohenD', 'ANvsMcohenD')
    
    % Peak Lat
    disp('********Peak Latency********')
    peaklat_ANvsAW = horzcat(ANpeaklat', AWpeaklat');
    peaklat_ANvsM = horzcat(ANpeaklat', Mpeaklat');
    var_peaklat = {'Groups','Peak Latency'};
    
    disp('**Anesthetized vs Awake**')
    AnesthetizedvsAwake = teg_repeated_measures_ANOVA(peaklat_ANvsAW, levels, var_peaklat);
    disp('**Anesthetized vs Awake COHEN D**')
    ANvsAWcohenD = iMakeCohensD(ANpeaklat, AWpeaklat)
    disp('**Anesthetized vs Muscimol**')
    AnesthetizedvsMuscimol = teg_repeated_measures_ANOVA(peaklat_ANvsM, levels, var_peaklat);
    disp('**Anesthetized vs Muscimol COHEN D**')
    ANvsMcohenD = iMakeCohensD(ANpeaklat, Mpeaklat)
    
    savefile = [Ticknames{ifreq} ' Peaklat STAvrecStats.mat'];
    save(savefile, 'AnesthetizedvsAwake', 'AnesthetizedvsMuscimol', ...
        'ANvsAWcohenD', 'ANvsMcohenD')
    
    % RMS Peak Value
    disp('********RMS Peak Value********')
    peakvalue_ANvsAW = horzcat(ANpeakvalue', AWpeakvalue');
    peakvalue_ANvsM = horzcat(ANpeakvalue', Mpeakvalue');
    var_peakvalue = {'Groups','Total'};
    
    disp('**Anesthetized vs Awake**')
    AnesthetizedvsAwake = teg_repeated_measures_ANOVA(peakvalue_ANvsAW, levels, var_peakvalue);
    disp('**Anesthetized vs Awake COHEN D**')
    ANvsAWcohenD = iMakeCohensD(ANpeakvalue, AWpeakvalue)
    disp('**Anesthetized vs Muscimol**')
    AnesthetizedvsMuscimol = teg_repeated_measures_ANOVA(peakvalue_ANvsM, levels, var_peakvalue);
    disp('**Anesthetized vs Muscimol COHEN D**')
    ANvsMcohenD = iMakeCohensD(ANpeakvalue, Mpeakvalue)
    
    savefile = [Ticknames{ifreq} ' PeakValue STAvrecStats.mat'];
    save(savefile, 'AnesthetizedvsAwake', 'AnesthetizedvsMuscimol', ...
        'ANvsAWcohenD', 'ANvsMcohenD')
end
%%
levels5 = [2,5];
varinames = {'Groups','Frequencies'};

% Set up tables
TAv = table(plottune.frqz,plottune.tgroup,plottune.peakamp,plottune.peaklate,plottune.peakvalue);
TAv.Properties.VariableNames = {'Freq' 'Group' 'PeakAmp' 'PeakLat' 'RMS'};

TRe = table(plottuner.frqz,plottuner.tgroup,plottuner.peakamp,plottuner.peaklate,plottuner.peakvalue);
TRe.Properties.VariableNames = {'Freq' 'Group' 'PeakAmp' 'PeakLat' 'RMS'};

%% AVREC table re-organization

% % AWAKE PEAKAMP
Am2 = TAv.PeakAmp(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'b -2'))';
Am1 = TAv.PeakAmp(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'c -1'))';
ABF = TAv.PeakAmp(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'d BF'))';
Ap1 = TAv.PeakAmp(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'e +1'))';
Ap2 = TAv.PeakAmp(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'f +2'))';

A_PA_5 = horzcat(Am2,Am1,ABF,Ap1,Ap2);

% % AWAKE PEAKLAT
Am2 = TAv.PeakLat(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'b -2'))';
Am1 = TAv.PeakLat(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'c -1'))';
ABF = TAv.PeakLat(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'d BF'))';
Ap1 = TAv.PeakLat(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'e +1'))';
Ap2 = TAv.PeakLat(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'f +2'))';

A_PL_5 = horzcat(Am2,Am1,ABF,Ap1,Ap2);

% % AWAKE RMS
Am2 = TAv.RMS(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'b -2'))';
Am1 = TAv.RMS(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'c -1'))';
ABF = TAv.RMS(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'d BF'))';
Ap1 = TAv.RMS(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'e +1'))';
Ap2 = TAv.RMS(strcmp(TAv.Group,'Awake')&strcmp(TAv.Freq,'f +2'))';

A_RMS_5 = horzcat(Am2,Am1,ABF,Ap1,Ap2);

% % KET PEAKAMP
Km2 = TAv.PeakAmp(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'b -2'))';
Km1 = TAv.PeakAmp(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'c -1'))';
KBF = TAv.PeakAmp(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'d BF'))';
Kp1 = TAv.PeakAmp(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'e +1'))';
Kp2 = TAv.PeakAmp(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'f +2'))';

K_PA_5 = horzcat(Km2,Km1,KBF,Kp1,Kp2);

% % KET PEAKLAT
Km2 = TAv.PeakLat(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'b -2'))';
Km1 = TAv.PeakLat(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'c -1'))';
KBF = TAv.PeakLat(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'d BF'))';
Kp1 = TAv.PeakLat(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'e +1'))';
Kp2 = TAv.PeakLat(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'f +2'))';

K_PL_5 = horzcat(Km2,Km1,KBF,Kp1,Kp2);

% % KET RMS
Km2 = TAv.RMS(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'b -2'))';
Km1 = TAv.RMS(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'c -1'))';
KBF = TAv.RMS(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'d BF'))';
Kp1 = TAv.RMS(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'e +1'))';
Kp2 = TAv.RMS(strcmp(TAv.Group,'Anesthetized')&strcmp(TAv.Freq,'f +2'))';

K_RMS_5 = horzcat(Km2,Km1,KBF,Kp1,Kp2);

% % MUSC PEAKAMP
Mm2 = TAv.PeakAmp(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'b -2'))';
Mm1 = TAv.PeakAmp(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'c -1'))';
MBF = TAv.PeakAmp(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'d BF'))';
Mp1 = TAv.PeakAmp(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'e +1'))';
Mp2 = TAv.PeakAmp(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'f +2'))';

M_PA_5 = horzcat(Mm2,Mm1,MBF,Mp1,Mp2);

% % MUSC PEAKLAT
Mm2 = TAv.PeakLat(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'b -2'))';
Mm1 = TAv.PeakLat(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'c -1'))';
MBF = TAv.PeakLat(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'d BF'))';
Mp1 = TAv.PeakLat(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'e +1'))';
Mp2 = TAv.PeakLat(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'f +2'))';

M_PL_5 = horzcat(Mm2,Mm1,MBF,Mp1,Mp2);

% % MUSC RMS
Mm2 = TAv.RMS(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'b -2'))';
Mm1 = TAv.RMS(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'c -1'))';
MBF = TAv.RMS(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'d BF'))';
Mp1 = TAv.RMS(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'e +1'))';
Mp2 = TAv.RMS(strcmp(TAv.Group,'Muscimol')&strcmp(TAv.Freq,'f +2'))';

M_RMS_5 = horzcat(Mm2,Mm1,MBF,Mp1,Mp2);

%% AVREC STATS
disp('*********************** AVREC STATS 5 octaves ***********************')
disp('************** PEAKAMP ***************')
com_KvsAw = horzcat(A_PA_5, K_PA_5);
com_KvM = horzcat(K_PA_5, M_PA_5);

disp('**Anesthetized vs Awake**')
AvK_AvrecPeakAmp_mini = teg_repeated_measures_ANOVA(com_KvsAw, levels5, varinames);
AvK_AvrecPeakAmp_miniCD = iMakeCohensD(K_PA_5, A_PA_5)

disp('**Anesthetized vs Muscimol**')
MvK_AvrecPeakAmp_mini = teg_repeated_measures_ANOVA(com_KvM, levels5, varinames);
MvK_AvrecPeakAmp_miniCD = iMakeCohensD(K_PA_5, M_PA_5)

disp('************** PEAKLAT ***************')
com_KvsAw = horzcat(A_PL_5, K_PL_5);
com_KvM = horzcat(K_PL_5, M_PL_5);

disp('**Anesthetized vs Awake**')
AvK_AvrecPeakLat_mini = teg_repeated_measures_ANOVA(com_KvsAw, levels5, varinames);
AvK_AvrecPeakLat_miniCD = iMakeCohensD(K_PL_5, A_PL_5)

disp('**Anesthetized vs Muscimol**')
MvK_AvrecPeakLat_mini = teg_repeated_measures_ANOVA(com_KvM, levels5, varinames);
MvK_AvrecPeakLat_miniCD = iMakeCohensD(K_PL_5, M_PL_5)

disp('**************   RMS   ***************')
com_KvsAw = horzcat(A_RMS_5, K_RMS_5);
com_KvM = horzcat(K_RMS_5, M_RMS_5);

disp('**Anesthetized vs Awake**')
AvK_AvrecRMS_mini = teg_repeated_measures_ANOVA(com_KvsAw, levels5, varinames);
AvK_AvrecRMS_miniCD = iMakeCohensD(K_RMS_5, A_RMS_5)

disp('**Anesthetized vs Muscimol**')
MvK_AvrecRMS_mini = teg_repeated_measures_ANOVA(com_KvM, levels5, varinames);
MvK_AvrecRMS_miniCD = iMakeCohensD(K_RMS_5, M_RMS_5)


%% Save
savefile = '5 Octave Tuning curve Avrec.mat';
save(savefile, 'AvK_AvrecPeakAmp_mini', 'AvK_AvrecPeakAmp_miniCD', ...
    'MvK_AvrecPeakAmp_mini', 'MvK_AvrecPeakAmp_miniCD', ...
    'AvK_AvrecPeakLat_mini', 'AvK_AvrecPeakLat_miniCD', ...
    'MvK_AvrecPeakLat_mini', ...
    'MvK_AvrecPeakLat_miniCD', 'AvK_AvrecRMS_mini', 'AvK_AvrecRMS_miniCD', ...
    'MvK_AvrecRMS_mini', 'MvK_AvrecRMS_miniCD')
