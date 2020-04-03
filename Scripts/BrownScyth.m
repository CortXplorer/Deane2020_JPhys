function BrownScyth(homedir)

% folder:   D:\MyCode\Dynamic_CSD_Analysis\DATA\avrec_compare
% Input:    stats from single trial avrec and relres 
% Output:   BrownScyth statistical comparison of variances; box plots and
%           stats saved as pictures

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
cd(homedir);
cd Data; cd AvRecStats;

figlist = {'vMusc_Box','vMusc_Stat','vAw_Box','vAw_Stat'};

%% Load and sort the data 
load('AvrecPlotData.mat','plottune');

mkdir('BrownScyth'); cd BrownScyth
% pull out the needed structure 
AVREC.peakamp = plottune.peakamp';
AVREC.peaklate = plottune.peaklate';
AVREC.tgroup = plottune.tgroup';
AVREC.frqz = plottune.frqz';

% convert to table, and find the groups to compare at specific frequencies
% AV_BF is avrec BF, AV_m2 is avrec BF-2, RE is relres, AB is absres
AVREC_T = struct2table(AVREC);
AV_BFT = AVREC_T(strcmp(AVREC_T.frqz,'d BF'),1:3);
[AV_BF,AV_BFname]=findgroups(AV_BFT.tgroup);
AV_m2T = AVREC_T(strcmp(AVREC_T.frqz,'b -2'),1:3);
[AV_m2,AV_m2name]=findgroups(AV_m2T.tgroup);


%% AVREC PEAKAMP

% BF
clear peakamp
for ii =1:3
    %cut out groups and stick them side by side in a struct
    peakamp.(AV_BFname{ii}) = AV_BFT.peakamp(AV_BF == ii);
end
%stick the struct in a table instead to spread it out properly
peakAmpT = struct2table(peakamp); 
%tables can't go into vartestn so we need a matrix, no table2mat so 2 steps:
peakAmpC = table2cell(peakAmpT); PEAKamp = cell2mat(peakAmpC); 
%2 comparisons, ket vs awake and ket vs mus
PEAKamp1 = PEAKamp(:,1:2); %ketamine and awake
PEAKamp2 = PEAKamp(:,1:2:3); %ketamine and muscimol

[AV_Amp_BF_P1,AV_Amp_BF_STATS1] = vartestn(PEAKamp1, 'testtype','BrownForsythe');
[AV_Amp_BF_P2,AV_Amp_BF_STATS2] = vartestn(PEAKamp2, 'testtype','BrownForsythe');

%get each figure, save them and close them
for ifig = 1:4
h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h, ['AVREC_' figlist{ifig} '_BFamp'])
saveas(gcf, ['AVREC_' figlist{ifig} '_BFamp.pdf'])
close (h)
end

%BF - 2
clear peakamp
for ii =1:3
    %cut out groups and stick them side by side in a struct
    peakamp.(AV_m2name{ii}) = AV_m2T.peakamp(AV_m2 == ii);
end
%stick the struct in a table instead to spread it out properly
peakAmpT = struct2table(peakamp); 
%tables can't go into vartestn so we need a matrix, no table2mat so 2 steps:
peakAmpC = table2cell(peakAmpT); PEAKamp = cell2mat(peakAmpC); 
%2 comparisons, ket vs awake and ket vs mus
PEAKamp1 = PEAKamp(:,1:2); %ketamine and awake
PEAKamp2 = PEAKamp(:,1:2:3); %ketamine and muscimol

[AV_Amp_m2_P1,AV_Amp_m2_STATS1] = vartestn(PEAKamp1, 'testtype','BrownForsythe');
[AV_Amp_m2_P2,AV_Amp_m2_STATS2] = vartestn(PEAKamp2, 'testtype','BrownForsythe');

for ifig = 1:4
h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h, ['AVREC_' figlist{ifig} '_m2amp'])
saveas(gcf, ['AVREC_' figlist{ifig} '_m2amp.pdf'])
close (h)
end

%% AVREC PEAKLAT

% BF
clear peakLate
for ii =1:3
    %cut out groups and stick them side by side in a struct
    peakLate.(AV_BFname{ii}) = AV_BFT.peaklate(AV_BF == ii);
end
%stick the struct in a table instead to spread it out properly
peakLateT = struct2table(peakLate); 
%tables can't go into vartestn so we need a matrix, no table2mat so 2 steps:
peakLateC = table2cell(peakLateT); PEAKLate = cell2mat(peakLateC); 
%2 comparisons, ket vs awake and ket vs mus
PEAKLate1 = PEAKLate(:,1:2); %ketamine and awake
PEAKLate2 = PEAKLate(:,1:2:3); %ketamine and muscimol

[AV_Late_BF_P1,AV_Late_BF_STATS1] = vartestn(PEAKLate1, 'testtype','BrownForsythe');
[AV_Late_BF_P2,AV_Late_BF_STATS2] = vartestn(PEAKLate2, 'testtype','BrownForsythe');

%get each figure, save them and close them
for ifig = 1:4
h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h, ['AVREC_' figlist{ifig} '_BFlate'])
saveas(gcf, ['AVREC_' figlist{ifig} '_BFlate.pdf'])
close (h)
end

%BF - 2
clear peakLate
for ii =1:3
    %cut out groups and stick them side by side in a struct
    peakLate.(AV_m2name{ii}) = AV_m2T.peaklate(AV_m2 == ii);
end
%stick the struct in a table instead to spread it out properly
peakLateT = struct2table(peakLate); 
%tables can't go into vartestn so we need a matrix, no table2mat so 2 steps:
peakLateC = table2cell(peakLateT); PEAKLate = cell2mat(peakLateC); 
%2 comparisons, ket vs awake and ket vs mus
PEAKLate1 = PEAKLate(:,1:2); %ketamine and awake
PEAKLate2 = PEAKLate(:,1:2:3); %ketamine and muscimol

[AV_Late_m2_P1,AV_Late_m2_STATS1] = vartestn(PEAKLate1, 'testtype','BrownForsythe');
[AV_Late_m2_P2,AV_Late_m2_STATS2] = vartestn(PEAKLate2, 'testtype','BrownForsythe');

for ifig = 1:4
h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h, ['AVREC_' figlist{ifig} '_m2late'])
saveas(gcf, ['AVREC_' figlist{ifig} '_m2late.pdf'])
close (h)
end