These are the scripts specific to the **Deane 2020 Journal of Physiology** publication.

## Title: Ketamine anesthesia induces gain enhancement via recurrent excitation in granular input layers of the auditory cortex
### Authors: ***Katrina E. Deane, Michael G. K. Brunk, Andrew W. Curran, Marina M. Zempeltzi, Jing Ma, Xiao Lin, Francesca Abela, Sümeyra Aksit, Matthias Deliano, Frank W. Ohl, Max F. K. Happel***
DOI: TBA

***Please cite us if you use these scripts***

Necessary to run:\
Raw data for this project can be found at: https://figshare.com/articles/Raw_Data_for_Deane_et_al_2020_JPhys/12083154 (1.8 GB)\
Animal raw data (e.g "GKD_02_0028") should be placed in ../Deane2020_JPhys/Raw;

Optional to run from downstream steps:\
Processed data for this project can be found at: https://cloud.lin-magdeburg.de/s/dBGczo86o9o3MK3 (12 GB, very slow download, sorry)\
Group Data (e.g. "AnesthetizedPre_Data.mat") should be placed in ../Deane2020_JPhys/Data;\
Sorted Group Data (e.g. "AnesthetizedPre_Data.m_Threshold_0.25_Zscore_0_binned_1_mirror_0.mat") should be placed in ../Deane2020_JPhys/Data/Output;\
Spectral Data (e.g. "scalograms.mat") should be placed in ../Deane2020_JPhys/Data/Spectral;

If animal raw data files are placed correctly in ../Deane2020_JPhys/Raw, running the Pipeline_Deane2020 script will produce all figures and statistics from the publication. Further data steps are provided to allow a user to start from different points. It's my recommendation to run this script in sections but it isn't necessary.

***Please raise an issue in this repository if something is not running. Thank you!***
