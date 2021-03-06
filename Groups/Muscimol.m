%%% general input
animals = {'GXL03','GXL04','GXL05','GXL06',...
            'GKD_02','GKD_05','GKD_06',...
            'GSA_006','GSA_007','GSA_008','GSA_009'};

dB_lev ={[],[],[],[],[],[],[],[],[],[],[]}; %between 30dB and 10dB: ,[]

channels = {...
    '[32;11; 31; 12; 30; 13; 29; 14; 17;  1; 19; 10; 18;  2; 28;  9; 20;  3; 27;  8; 21;  4; 23;  7; 22; 15; 25;  6; 24;  5; 26; 16]',...
    '[32;11; 31; 12; 30; 13; 29; 14; 17;  1; 19; 10; 18;  2; 28;  9; 20;  3; 27;  8; 21;  4; 23;  7; 22; 15; 25;  6; 24;  5; 26; 16]',...
    '[32;11; 31; 12; 30; 13; 29; 14; 17;  1; 19; 10; 18;  2; 28;  9; 20;  3; 27;  8; 21;  4; 23;  7; 22; 15; 25;  6; 24;  5; 26; 16]',...
    '[32;11; 31; 12; 30; 13; 29; 14; 17;  1; 19; 10; 18;  2; 28;  9; 20;  3; 27;  8; 21;  4; 23;  7; 22; 15; 25;  6; 24;  5; 26; 16]',...
    '[11; 31; 12; 30; 13; 29; 14; 17;  1; 19; 10; 18;  2; 28;  9; 20;  3; 27;  8; 21;  4; 23;  7; 22; 15; 25;  6; 24;  5; 26; 16]',...
    '[29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]',...
    '[29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]',...
    '[31; 15; 29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]',...
    '[13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]',...
    '[31; 15; 29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]',...
    '[27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]',...
    };

              %XL:3     4           5           6           KD:2        5           6           %SA:6       7         8           9
Layer.I_IIE = {'[1:7]', '[1:7]',    '[4:8]',    '[5:7]',    '[1:3]',    '[1:3]',    '[1:3]',   '[1:4]',    '[1:4]',  '[1:4]',    '[1:5]'}; 
              %XL:3     4           5           6           KD:2        5           6           %SA:6       7         8           9
Layer.I_IIL = {'[1:7]', '[1:7]',    '[4:8]',    '[5:7]',    '[1:3]',    '[1:3]',    '[1:3]',   '[1:4]',    '[1:4]',  '[1:4]',    '[1:5]'}; 
              %XL:3     4           5           6           KD:2        5           6           %SA:6       7         8           9     
Layer.IVE = {'[8:13]',  '[8:15]',   '[9:12]',   '[8:12]',   '[4:10]',  '[4:10]',   '[4:12]',   '[5:12]',   '[5:13]', '[5:12]',   '[6:12]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9     
Layer.IVL = {'[8:13]',  '[8:15]',   '[9:12]',   '[8:12]',   '[4:10]',  '[4:10]',   '[4:12]',   '[5:12]',   '[5:13]', '[5:12]',   '[6:12]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9    
Layer.VaE = {'[14:19]', '[16:20]',  '[13:16]',  '[13:18]',  '[11:15]', '[11:15]',  '[13:17]',  '[13:16]',  '[14:18]','[13:17]',  '[13:16]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9    
Layer.VaL = {'[14:19]', '[16:20]',  '[13:16]',  '[13:18]',  '[11:15]', '[11:15]',  '[13:17]',  '[13:16]',  '[14:18]','[13:17]',  '[13:16]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9   
Layer.VbE = {'[20:24]', '[21:23]',  '[17:21]',  '[19:23]',  '[16:20]', '[16:20]',  '[18:22]',  '[17:21]',  '[19:23]','[18:21]',  '[17:21]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9  
Layer.VbL = {'[20:24]', '[21:23]',  '[17:21]',  '[19:23]',  '[16:20]', '[16:20]',  '[18:22]',  '[17:21]',  '[19:23]','[18:21]',  '[17:21]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9  
Layer.VIaE = {'[25:28]','[24:27]',  '[22:28]',  '[24:28]',  '[21:24]','[21:24]',  '[23:26]',   '[22:25]',  '[24:26]','[22:25]',  '[22:24]'}; 
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9  
Layer.VIaL = {'[25:28]','[24:27]',  '[22:28]',  '[24:28]',  '[21:24]','[21:24]',  '[23:26]',   '[22:25]',  '[24:26]','[22:25]',  '[22:24]'};
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9       
Layer.VIbE = {'[29:32]','[28:32]',  '[29:32]',  '[29:32]',  '[25:29]','[25:29]',  '[23:30]',   '[26:28]',  '[27:29]','[26:31]',  '[25:28]'}; 
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9
Layer.VIbL = {'[29:32]','[28:32]',  '[29:32]',  '[29:32]',  '[25:29]','[25:29]',  '[23:30]',   '[26:28]',  '[27:29]','[26:31]',  '[25:28]'}; 
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9       
Layer.InfE = {'[25:32]','[24:32]',  '[22:32]',  '[24:32]',  '[21:29]','[21:29]',  '[23:30]',   '[22:28]',  '[24:29]','[22:31]',  '[22:28]'}; 
              %XL:3     4           5           6           KD:2        5           6          %SA:6       7         8           9
Layer.InfL = {'[25:32]','[24:32]',  '[22:32]',  '[24:32]',  '[21:29]','[21:29]',  '[23:30]',   '[22:28]',  '[24:29]','[22:31]',  '[22:28]'}; 


%%% Conditions
Cond.condition= {...
    {'0032'},... %GXL 3
    {'0035'},... %GXL 4
    {'0032'},... %GXL 5
    {'0034'},... %GXL 6
    {'0044'},... %GKD 2
    {'0039'},... %GKD 5
    {'0040'},... %GKD 6
    {'0023'},... %GSA 6
    {'0017'},... %GSA 7
    {'0016'},... %GSA 8
    {'0017'},... %GSA 9
    };

