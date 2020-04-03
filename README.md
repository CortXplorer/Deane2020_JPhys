These are the scripts specific to the **Deane 2020 Journal of Physiology** publication.

Title: **Ketamine anesthesia induces gain enhancement via recurrent excitation in granular input layers of the auditory cortex **
Authors: ***Katrina E. Deane, Michael G. K. Brunk, Andrew W. Curran, Marina M. Zempeltzi, Jing Ma, Xiao Lin, Francesca Abela, Sümeyra Aksit, Matthias Deliano, Frank W. Ohl, Max F. K. Happel***
DOI: TBA

***Please cite us if you use these scripts***

Data for this project can be found at TBA. 

Necessary to run:
Animal raw data should be placed in ../Deane2020_JPhys/Raw;
e.g "GKD_02_0028"

Optional to run from downstream steps:
Group Data should be placed in ../Deane2020_JPhys/Data;
e.g. "AnesthetizedPre_Data.mat"
Sorted Group Data should be placed in ../Deane2020_JPhys/Data/Output;
e.g. "AnesthetizedPre_Data.m_Threshold_0.25_Zscore_0_binned_1_mirror_0.mat"
Spectral Data should be placed in ../Deane2020_JPhys/Data/Spectral;
e.g. "scalograms.mat"

If animal raw data files are placed correctly in ../Deane2020_JPhys/Raw, running the Pipeline_Deane2020 script will produce all figures and statistics from the publication. Further data steps are provided to allow a user to start from different points. It's my recommendation to run this script in sections because some have a longer run-time but it isn't necessary.

***Please raise an issue in this repository if something is not running. Thank you!***