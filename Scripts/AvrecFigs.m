function AvrecFigs(homedir)

% %Input:     D:\MyCode\Dynamic_CSD_Analysis\DATA -> *DATA.mat; 
% %Output:    a carry over .mat and pictures in D:\MyCode\Dynamic_CSD_Analysis\Data\AvRecStats

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
rowofnans = NaN(1,50); %IMPORTANT: if animal group sizes are equal this isn't needed. Currently these are commented in the code

% forsave = {'BF-2','BF-1','BF','BF+1', 'BF+2'};
Group = {'Anesthetized','Awake','Muscimol'};
FromBF = [-2,-1,0,+1,+2];

%% Load in the appropriate files
load('AnesthetizedPre_Data.mat','Data')
Anesthetized = Data; clear Data;
load('Awake10dB_Data.mat','Data')
Awake = Data; clear Data;
load('Muscimol_Data.mat','Data')
Muscimol = Data; clear Data;

GroupNames = {'Anesthetized','Awake','Muscimol'};


%% Plots
% The first plots are of the individual animals' AVRECs and a black line
% averageing the group. For each frequency, using Matlab plotting.
% The second plots are of the groups' AVRECs for each frequecny using
% grammplots

%for full plots
plotdata = struct;
plotdata.BF = []; plotdata.min_one = []; plotdata.min_two = []; plotdata.min_three = [];
plotdata.plus_one = []; plotdata.plus_two = []; plotdata.plus_three = [];
plotdata.time = [];
plotdata.fgroup = [];
%for tuning curves
plottune = struct;
grpsz = 550;
plottune.frqz = [];
plottune.tgroup = []; plottune.animal = [];
plottune.peakamp = [];plottune.peaklate = [];plottune.smallmean = [];

for i1 = 1:length(GroupNames)

    disp(['Analyzing Group: ' GroupNames{i1}])
    tic
    
    clear Data
    if strcmp('Anesthetized',GroupNames{i1})
        Data = Anesthetized;
    elseif strcmp('Awake',GroupNames{i1})
        Data = Awake;
    elseif strcmp('Muscimol',GroupNames{i1})
        Data = Muscimol;
    end
    
    names = fieldnames(Data); %list of animal names
    avrec = struct;
    
    time = (1:1:600);
    groupname = GroupNames{i1};
    grouplist = repmat({groupname}, 1, 600);
   
   for i2 = 1:length(names)
       animal = names{i2};
       %BF
       BF = find((Data.(names{i2}).GS_BF) == (Data.(names{i2}).Frqz'));
       avrec.(animal).BF =  nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF},3)';
       
       plotdata.BF = horzcat(plotdata.BF, avrec.(animal).BF(1:600));
       plotdata.time = horzcat(plotdata.time, time);
       plotdata.fgroup = horzcat(plotdata.fgroup, grouplist);
       %-1
       try 
           avrec.(animal).min_one = nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF-1},3)';  
       catch
           avrec.(animal).min_one = NaN(1,length(avrec.(animal).BF));
       end
       plotdata.min_one = horzcat(plotdata.min_one, avrec.(animal).min_one(1:600));
       %-2
       try 
           avrec.(animal).min_two = nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF-2},3)';  
       catch
           avrec.(animal).min_two = NaN(1,length(avrec.(animal).BF));
       end
       plotdata.min_two = horzcat(plotdata.min_two, avrec.(animal).min_two(1:600));
       %-3
       try 
           avrec.(animal).min_three = nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF-3},3)';  
       catch
           avrec.(animal).min_three = NaN(1,length(avrec.(animal).BF));
       end
       plotdata.min_three = horzcat(plotdata.min_three, avrec.(animal).min_three(1:600));
       %+1
       try 
           avrec.(animal).plus_one = nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF+1},3)';  
       catch
           avrec.(animal).plus_one = NaN(1,length(avrec.(animal).BF));
       end
       plotdata.plus_one = horzcat(plotdata.plus_one, avrec.(animal).plus_one(1:600));
       %+2
       try 
           avrec.(animal).plus_two = nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF+2},3)';  
       catch
           avrec.(animal).plus_two = NaN(1,length(avrec.(animal).BF));
       end
       plotdata.plus_two = horzcat(plotdata.plus_two, avrec.(animal).plus_two(1:600));
       %+3
       try 
           avrec.(animal).plus_three = nanmean(Data.(animal).SingleTrial_AVREC_raw{1,BF+3},3)';  
       catch
           avrec.(animal).plus_three = NaN(1,length(avrec.(animal).BF));
       end
       plotdata.plus_three = horzcat(plotdata.plus_three, avrec.(animal).plus_three(1:600));
   end
   
   % MATLAB PLOTS currently silence to avoid unnecessary replotting
   cd(homedir); cd Figs; %opens figure folder to store future images
   mkdir(['Avrec_' GroupNames{i1}]); cd(['Avrec_' GroupNames{i1}]);
   PlotAnimalAvrec(avrec, names)
    
end

% Gramm Plots
Ticks = {'BF', 'min_one', 'min_two', 'min_three', 'plus_one', 'plus_two', 'plus_three'};
Ticknames = {'Best Frequency', 'BF - 1','BF - 2','BF - 3','BF + 1', 'BF + 2', 'BF + 3'};
cd(homedir); cd Figs; %opens figure folder to store future images
mkdir('Gramm Plots Avrec'); cd('Gramm Plots Avrec');

for iticks = 1:length(Ticks)
    clear g
    g=gramm('x',plotdata.time,'y',plotdata.(Ticks{iticks}),'color',plotdata.fgroup);
    g.stat_summary('type','std','geom','area'); %mean and std shown
    g.set_layout_options('Position',[0 0 0.7 0.7],...
            'legend_pos',[0.71 0.66 0.2 0.2],... %We detach the legend from the plot and move it to the top right
            'margin_height',[0.1 0.1],...
            'margin_width',[0.1 0.1],...
            'redraw',false);
    g.set_names('x','Time (ms)','y','?V','color','Group');
    g.axe_property('ylim',[0 0.003],'xlim',[0 600])
    g.set_color_options('map','matlab');
    g.set_title((Ticknames{iticks}));
    g.draw();
    g.export('file_name',['S' (Ticks{iticks})], 'file_type','png');
    g.export('file_name',['S' (Ticks{iticks})], 'file_type','pdf');
    close all;
end

%% Tuning Plots

newTicks = {'b -2', 'c -1','d BF', 'e +1', 'f +2'};
newTicknames = {'BF - 2','BF - 1','Best Frequency','BF + 1', 'BF + 2'};

disp('***sorting frequencies***')
for ifreq = 1:length(newTicknames)
   
    % Anesthetized Acute
    Kpeakamp = []; Kpeaklat = []; Kpeakvalue = [];
    Knames = fieldnames(Anesthetized);
    for i1 = 1:length(Knames)
        animal = Knames{i1};
        %Find the best frequency
        BF = find((Anesthetized.(Knames{i1}).GS_BF) == (Anesthetized.(Knames{i1}).Frqz'));
        avreclist_BF =  Anesthetized.(animal).SingleTrial_AVREC_raw{1,BF};
        
        try %cut out the section of the matrix necessary (BF, BF-1, etc)
            avreclist =  Anesthetized.(animal).SingleTrial_AVREC_raw{1,(BF+FromBF(ifreq))};
        catch %produce NAN if there isn't an entry here
            avreclist = NaN(1,length(avreclist));
        end
        
        peakampme = []; peaklat = []; peakvalue = [];
        for i2 = 1:50
            if isnan(avreclist)
                peaklat = [peaklat NaN];
                peakampme = [peakampme NaN];
                peakvalue = [peakvalue NaN];
            else
                [latency, ampl, meanOfdata] = iGetPeakData_avrec(avreclist(:,:,i2),[200 300]);
                peaklat = [peaklat latency];
                peakampme = [peakampme ampl];
                peakvalue = [peakvalue meanOfdata];
            end
        end     
        
        %apply a cutoff threshold
        if sum(isnan(peakampme)) > length(peakampme)*.75 % 25% 
            peakampme = NaN(1,50);
            peaklat = NaN(1,50);
            peakvalue = NaN(1,50);
        end
        
        Kpeakamp = [Kpeakamp peakampme];
        Kpeaklat = [Kpeaklat peaklat];
        Kpeakvalue = [Kpeakvalue peakvalue];
    end
    
%     Kpeakamp = [Kpeakamp rowofnans];
%     Kpeaklat = [Kpeaklat rowofnans];
%     Kpeakvalue = [Kpeakvalue rowofnans];
    
    % Awake Chronic
    Apeakamp = []; Apeaklat = []; Apeakvalue = [];
    Anames = fieldnames(Awake);
    for i1 = 1:length(Anames)
        animal = Anames{i1};
        BF = find((Awake.(Anames{i1}).GS_BF) == (Awake.(Anames{i1}).Frqz'));
        avreclist_BF =  Awake.(animal).SingleTrial_AVREC_raw{1,BF};
        try
            avreclist =  Awake.(animal).SingleTrial_AVREC_raw{:,(BF+FromBF(ifreq))};
        catch
            avreclist = NaN(1,length(avreclist));
        end
        
        peakampme = []; peaklat = []; peakvalue = [];
        for i2 = 1:50
            if sum(sum(isnan(avreclist))) > 1 || size(avreclist,3)<i2
                peaklat = [peaklat NaN];
                peakampme = [peakampme NaN];
                peakvalue = [peakvalue NaN];
            else
                [latency, ampl, meanOfdata] = iGetPeakData_avrec(avreclist(:,:,i2),[200 300]);
                peaklat = [peaklat latency];
                peakampme = [peakampme ampl];
                peakvalue = [peakvalue meanOfdata];
            end
        end
           
        %apply a cutoff threshold
        if sum(isnan(peakampme)) > length(peakampme)*.75 % 25% 
            peakampme = NaN(1,50);
            peaklat = NaN(1,50);
            peakvalue = NaN(1,50);
        end
        
        Apeakamp = [Apeakamp peakampme];
        Apeaklat = [Apeaklat peaklat];
        Apeakvalue = [Apeakvalue peakvalue];
    end
    
    Apeakamp = [Apeakamp rowofnans rowofnans];
    Apeaklat = [Apeaklat rowofnans rowofnans];
    Apeakvalue = [Apeakvalue rowofnans rowofnans];
    
    % Muscimol Acute
    Mpeakamp = []; Mpeaklat = []; Mpeakvalue = [];
    Mnames = fieldnames(Muscimol);
    for i1 = 1:length(Mnames)
        animal = Mnames{i1};
        BF = find((Muscimol.(Mnames{i1}).GS_BF) == (Muscimol.(Mnames{i1}).Frqz'));
        avreclist_BF =  Muscimol.(animal).SingleTrial_AVREC_raw{1,BF};
        try
            avreclist =  Muscimol.(animal).SingleTrial_AVREC_raw{:,(BF+FromBF(ifreq))};
        catch
            avreclist = NaN(1,length(avreclist));
        end
        peakampme = []; peaklat = []; peakvalue = [];
        for i2 = 1:50
            if isnan(avreclist)
                peaklat = [peaklat NaN];
                peakampme = [peakampme NaN];
                peakvalue = [peakvalue NaN];
            else
                [latency, ampl, meanOfdata] = iGetPeakData_avrec(avreclist(:,:,i2),[200 300]);
                peaklat = [peaklat latency];
                peakampme = [peakampme ampl];
                peakvalue = [peakvalue meanOfdata];
            end
        end
        
        %apply a cutoff threshold
        if sum(isnan(peakampme)) > length(peakampme)*.75 % 25% 
            peakampme = NaN(1,50);
            peaklat = NaN(1,50);
            peakvalue = NaN(1,50);
        end
            
        Mpeakamp = [Mpeakamp peakampme];
        Mpeaklat = [Mpeaklat peaklat];
        Mpeakvalue = [Mpeakvalue peakvalue];
    end
    
%     Mpeakamp = [Mpeakamp rowofnans];
%     Mpeaklat = [Mpeaklat rowofnans];
%     Mpeakvalue = [Mpeakvalue rowofnans];
     
    Kanimals = horzcat(repmat({Knames{1}},1,50),repmat({Knames{2}},1,50),...
        repmat({Knames{3}},1,50),repmat({Knames{4}},1,50),repmat({Knames{5}},1,50),...
        repmat({Knames{6}},1,50),repmat({Knames{7}},1,50),repmat({Knames{8}},1,50),...
        repmat({Knames{9}},1,50),repmat({Knames{10}},1,50),repmat({Knames{11}},1,50));
        
    Aanimals = horzcat(repmat({Anames{1}},1,50),repmat({Anames{2}},1,50),...
        repmat({Anames{3}},1,50),repmat({Anames{4}},1,50),repmat({Anames{5}},1,50),...
        repmat({Anames{6}},1,50),repmat({Anames{7}},1,50),repmat({Anames{8}},1,50),...
        repmat({Anames{9}},1,50),repmat({'NaN'},1,50),repmat({'NaN'},1,50));
    
    Manimals = horzcat(repmat({Mnames{1}},1,50),repmat({Mnames{2}},1,50),...
        repmat({Mnames{3}},1,50),repmat({Mnames{4}},1,50),repmat({Mnames{5}},1,50),...
        repmat({Mnames{6}},1,50),repmat({Mnames{7}},1,50),repmat({Mnames{8}},1,50),...
        repmat({Mnames{9}},1,50),repmat({Mnames{10}},1,50),repmat({Mnames{11}},1,50));
    
    %for later tuning curves
%     T = table([Kpeakamp';Apeakamp';Mpeakamp'; repmat({newTicks{ifreq}}, 1, grpsz)';repmat({Group{1}},1,grpsz)']);%,'RowNames',{'PeakAmp','PeakLat','Freq','Group'}
    plottune.peakamp = horzcat(plottune.peakamp, Kpeakamp, Apeakamp, Mpeakamp);
    plottune.peaklate = horzcat(plottune.peaklate, Kpeaklat, Apeaklat, Mpeaklat);
    plottune.smallmean = horzcat(plottune.smallmean, Kpeakvalue, Apeakvalue, Mpeakvalue);
    plottune.tgroup = horzcat(plottune.tgroup, repmat({Group{1}},1,grpsz), ... 
                                               repmat({Group{2}},1,grpsz), repmat({Group{3}},1,grpsz));
    plottune.animal = horzcat(plottune.animal,Kanimals, Aanimals, Manimals);
    plottune.frqz = horzcat(plottune.frqz, repmat({newTicks{ifreq}}, 1, grpsz), ...
                                           repmat({newTicks{ifreq}}, 1, grpsz), repmat({newTicks{ifreq}}, 1, grpsz));
                                       
end

feature = {'peakamp','peaklate', 'smallmean'};
Name = {'Peak Amplitude', 'Peak Latency', 'RMS between 200 and 300 ms'};
PlotAvrecTuning(feature, Name, plottune, homedir)
save('AvrecPlotData.mat','plottune')