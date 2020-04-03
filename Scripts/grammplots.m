function grammplots_ST(homedir)
%% Start
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

% averaged tuning
rowofnans = NaN(1,7);
Parameter = {'SinkRMS','SinkPeakAmp','SinkPeakLate','Sinkonset'};
% single trial tuning
% SParameter = {'SingleSinkRMS','SingleSinkPeakAmp','SingleSinkPeakLat'};
% srowofnans = [{NaN(1,50)} {NaN(1,50)} {NaN(1,50)} {NaN(1,50)} {NaN(1,50)} {NaN(1,50)} {NaN(1,50)}];

% Order = {'IVE','IVL','I_IIE','I_IIL', 'VaE','VaL','VbE','VbL','VIE','VIL'};
Order = {'IVE','IVL','I_IIE','I_IIL', 'VaE','VaL','VbE','VbL','VIaE','VIaL','VIbE','VIbL'};
ticks = {'a-3' 'b-2' 'c-1' 'dBF' 'e+1' 'f+2' 'g+3'};


%% Load in the appropriate files
load('AnesthetizedPre_Data.m_Threshold_0.25_Zscore_0_binned_1_mirror_0.mat','Data')
Anesthetized = Data; clear Data; 
load('Awake10dB_Data.m_Threshold_0.25_Zscore_0_binned_1_mirror_0.mat','Data')
Awake = Data; clear Data;
load('Muscimol_Data.m_Threshold_0.25_Zscore_0_binned_1_mirror_0.mat','Data')
Muscimol = Data; clear Data;

cd(homedir);cd Figs;
mkdir('Group Tuning Gramm'); cd('Group Tuning Gramm'); 

%% Sink Loop
for isink = 1:length(Order)
    for ipara = 1:length(Parameter)
        %% 3 Groups
        An_data = vertcat(Anesthetized.ST_based.(Parameter{ipara}).(Order{isink})(:,5:11));
        Aw_data = vertcat(Awake.ST_based.(Parameter{ipara}).(Order{isink})(:,4:10),rowofnans,rowofnans);
        M_data = vertcat(Muscimol.ST_based.(Parameter{ipara}).(Order{isink})(:,5:11));
        
        fullmean = nanmean(vertcat(An_data,Aw_data,M_data),1)';
        
        % Create Appropriate Structure
        plotdata = struct;
        
        tone = ticks';
        Angrammdata = An_data(1,:)';
        Mugrammdata = M_data(1,:)';
        Awgrammdata = Aw_data(1,:)';
        
        Angroup = {'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized'}; %7 to match the amount of ticks
        An = Angroup';
        Mugroup = {'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol'};
        Mu = Mugroup';
        Awgroup = {'Awake' 'Awake' 'Awake' 'Awake' 'Awake' 'Awake' 'Awake'};
        Aw = Awgroup';
        
        for istack = 1:size(An_data,1)-1
            
            tone = vertcat(tone, ticks');
            Angrammdata = vertcat(Angrammdata, An_data(istack+1,:)');
            Mugrammdata = vertcat(Mugrammdata, M_data(istack+1,:)');
            Awgrammdata = vertcat(Awgrammdata, Aw_data(istack+1,:)');
            An = vertcat(An, Angroup');
            Mu = vertcat(Mu, Mugroup');
            Aw = vertcat(Aw, Awgroup');
            
        end
        
        plotdata.tone = vertcat(tone, tone, tone);
        plotdata.data = vertcat(Angrammdata, Mugrammdata, Awgrammdata);
        plotdata.group = vertcat(An, Mu, Aw);
        
        
        clear g
        figure('Position',[100 100 650 650]);
        
        %Mean frequency response
        g(1,1)=gramm('x',ticks','y',fullmean);
        g(1,1).geom_line();
        g(1,1).set_layout_options('Position',[0 0.8 0.8 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
            'legend',false,... % No need to display legend for side histograms
            'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
            'margin_width',[0.1 0.02],...
            'redraw',false); %We deactivate automatic redrawing/resizing so that the axes stay aligned according to the margin options
        g(1,1).set_names('x','','y','Mean');
        g(1,1).axe_property('XTickLabel',''); % We deactivate the ticks
        g(1,1).set_line_options('base_size',3)
        g(1,1).set_color_options('map',[0 0 0])
        
        %Tuning curve
        g(2,1)=gramm('x',plotdata.tone,'y',plotdata.data, 'color', plotdata.group); %,'y',cars.Acceleration,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5
        % g(2,1).geom_point(); %to see each point, removed the YLim (highest points are closer to 2.5
        g(2,1).stat_summary('type','std','geom','errorbar'); %mean and sem shown
        g(2,1).stat_summary('type','std','geom','point'); %mean and sem shown
        g(2,1).stat_summary('type','std','geom','area'); %mean and sem shown
        g(2,1).set_layout_options('Position',[0 0 0.8 0.8],...
            'legend_pos',[0.83 0.75 0.2 0.2],... %We detach the legend from the plot and move it to the top right
            'margin_height',[0.1 0.02],...
            'margin_width',[0.1 0.02],...
            'redraw',false);
        g(2,1).axe_property('Ygrid','on'); %,'YLim',[0 0.0015]
        g(2,1).set_names('x','Tone','y','mV','color','Group');
        g(2,1).set_color_options('map','matlab');
        g(2,1).axe_property('XTickLabel',{'-3', '-2', '-1', 'BF', '+1', '+2', '+3'})
          
        %side histogram
        g(3,1)=gramm('x',plotdata.data,'color',plotdata.group);
        g(3,1).set_layout_options('Position',[0.8 0 0.2 0.8],...
            'legend',false,...
            'margin_height',[0.1 0.02],...
            'margin_width',[0.02 0.05],...
            'redraw',false);
        g(3,1).set_names('x','');
        g(3,1).stat_bin('geom','overlaid_bar','fill','transparent'); %histogram
        g(3,1).coord_flip();
        g(3,1).axe_property('XTickLabel','');
        g(3,1).set_color_options('map','matlab');
        
        g.set_title([(Order{isink}) ' ' (Parameter{ipara})]);
        g.draw();
        g.export('file_name',[(Order{isink}) '_' (Parameter{ipara})], 'file_type','png');
        close all;
        

    end
end

%% Sink Loop Normalized
for isink = 1:length(Order)
    for ipara = 1:length(Parameter)
        %% 3 Groups
        An_data = vertcat(Anesthetized.ST_based.(Parameter{ipara}).(Order{isink})(:,5:11));
        An_data = An_data./An_data(:,4);
        
        Aw_data = vertcat(Awake.ST_based.(Parameter{ipara}).(Order{isink})(:,4:10),rowofnans,rowofnans);
        Aw_data = Aw_data./Aw_data(:,4);
        
        M_data = vertcat(Muscimol.ST_based.(Parameter{ipara}).(Order{isink})(:,5:11));
        M_data = M_data./M_data(:,4);

        fullmean = nanmean(vertcat(An_data,Aw_data,M_data),1)';
        
        % Create Appropriate Structure
        plotdata = struct;
        
        tone = ticks';
        Angrammdata = An_data(1,:)';
        Mugrammdata = M_data(1,:)';
        Awgrammdata = Aw_data(1,:)';
        
        Angroup = {'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized' 'Anesthetized'}; %7 to match the amount of ticks
        An = Angroup';
        Mugroup = {'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol' 'Muscimol'};
        Mu = Mugroup';
        Awgroup = {'Awake' 'Awake' 'Awake' 'Awake' 'Awake' 'Awake' 'Awake'};
        Aw = Awgroup';
        
        for istack = 1:size(An_data,1)-1
            
            tone = vertcat(tone, ticks');
            Angrammdata = vertcat(Angrammdata, An_data(istack+1,:)');
            Mugrammdata = vertcat(Mugrammdata, M_data(istack+1,:)');
            Awgrammdata = vertcat(Awgrammdata, Aw_data(istack+1,:)');
            An = vertcat(An, Angroup');
            Mu = vertcat(Mu, Mugroup');
            Aw = vertcat(Aw, Awgroup');

        end
        
        plotdata.tone = vertcat(tone, tone, tone);
        plotdata.data = vertcat(Angrammdata, Mugrammdata, Awgrammdata);
        plotdata.group = vertcat(An, Mu, Aw);
        
        
        clear g
        figure('Position',[100 100 650 650]);
        
        %Mean frequency response
        g(1,1)=gramm('x',ticks','y',fullmean);
        g(1,1).geom_line();
        g(1,1).set_layout_options('Position',[0 0.8 0.8 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
            'legend',false,... % No need to display legend for side histograms
            'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
            'margin_width',[0.1 0.02],...
            'redraw',false); %We deactivate automatic redrawing/resizing so that the axes stay aligned according to the margin options
        g(1,1).set_names('x','','y','Mean');
        g(1,1).axe_property('XTickLabel',''); % We deactivate the ticks
        g(1,1).set_line_options('base_size',3)
        g(1,1).set_color_options('map',[0 0 0])
        
        %Tuning curve
        g(2,1)=gramm('x',plotdata.tone,'y',plotdata.data, 'color', plotdata.group); %,'y',cars.Acceleration,'color',cars.Cylinders,'subset',cars.Cylinders~=3 & cars.Cylinders~=5
        % g(2,1).geom_point(); %to see each point, removed the YLim (highest points are closer to 2.5
        g(2,1).stat_summary('type','sem','geom','errorbar'); %mean and sem shown
        g(2,1).stat_summary('type','sem','geom','point'); %mean and sem shown
        g(2,1).stat_summary('type','sem','geom','area'); %mean and sem shown
        g(2,1).set_layout_options('Position',[0 0 0.8 0.8],...
            'legend_pos',[0.83 0.75 0.2 0.2],... %We detach the legend from the plot and move it to the top right
            'margin_height',[0.1 0.02],...
            'margin_width',[0.1 0.02],...
            'redraw',false);
        g(2,1).axe_property('Ygrid','on'); %,'YLim',[0 0.0015]
        g(2,1).set_names('x','Tone','y','mV','color','Group');
        g(2,1).set_color_options('map','matlab');
        g(2,1).axe_property('XTickLabel',{'-3', '-2', '-1', 'BF', '+1', '+2', '+3'})
          
        %side histogram
        g(3,1)=gramm('x',plotdata.data,'color',plotdata.group);
        g(3,1).set_layout_options('Position',[0.8 0 0.2 0.8],...
            'legend',false,...
            'margin_height',[0.1 0.02],...
            'margin_width',[0.02 0.05],...
            'redraw',false);
        g(3,1).set_names('x','');
        g(3,1).stat_bin('geom','overlaid_bar','fill','transparent'); %histogram
        g(3,1).coord_flip();
        g(3,1).axe_property('XTickLabel','');
        g(3,1).set_color_options('map','matlab');
        
        g.set_title([(Order{isink}) ' ' (Parameter{ipara})]);
        g.draw();
        g.export('file_name',[(Order{isink}) '_' (Parameter{ipara})], 'file_type','png');
        close all;
        

    end
end