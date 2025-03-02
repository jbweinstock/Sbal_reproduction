# Sbal_reproduction
**Code for paper: Latitudinal variation in seasonal cycle mediates population differences in barnacle reproduction phenology**

NOTE: Any files/programs contained in [brackets] must be downloaded separately from links provided

Sbal_reproduction has the following directory trees below it.
- **scripts:** R and MATLAB scripts for processing phenology data and intertidal temperatures, see below
- **data:** [~weekly reproductive proportion data], [hourly intertidal/subtidal temperature logger data for Newagen 2003], [site meta-data],and folder **NOAH_filt_temps** for [filtered temperatures]. Note that data must be downloaded from https://doi.org/10.5061/dryad.gxd2547wk and inserted into this file structure.
- **NOAH_IntertidalModel:** see below


## Sbal_reproduction/scripts

- data_load_proc.R loads + standardizes weekly proportion data, then splits data by site
- phenology.R runs logistic regression analysis and summarizes results into 'release_est' object, *using output from data_load_proc.R*
- pl64.m contains PL64 filter function
- filter_NOAH_temps.m runs PL64 filter function on Newagen 2003 temperature logger data *and on Noah Intertidal Temperature model output*
- NOAH_load_filtd.R loads + standardizes *filtered temperatures*
- temp_vs_repr.R combines *phenology.R output* and *filtered intertidal temperatures* into release_est object; includes code for Figures 2c, 2d, 4, and 5
- figure1.R creates figure 1 using [OSTIA and NARR satellite data]
- figures_2_S2.1.R uses *output from temp_vs_repr.R* to create figures 2 and S2.1
- figure3.R uses *output from phenology.R* to create figure 3
- figure_S1.2.R uses *output from NOAH_load_filtd.R* to generate figure S1.2

Code dependencies are *italicized*


## Noah Intertidal Temperature Model code

NOAH_IntertidalModel has the following directory trees below it. It is recommend to keep this overall tree structure.
- **MetData:** location for [North American Regional Reanalysis (NARR) data]
- **NOAH_R_Code_2:** R code, template files, and [NOAH windows pc executable (nt191.exe)]

The following folders are also necessary, located within the NOAH_IntertidalModel folder. These folders with example data can be downloaded from https://doi.org/10.5061/dryad.gxd2547wk
- **SST:** Location for [OSTIA SST data]
- **tide:** [xtide.exe windows pc executable] and [harmonics files]

The R programs need to be edited to indicate where data and programs reside

You can get updated harmonics from https://flaterco.com/files/xtide/harmonics-dwf-20240104-free.tar.xz  
Source code is here https://flaterco.com/files/xtide/xtide-2.15.5.tar.xz  
You will need to create an environment variable HFILE_PATH that should have the path to the harmonics directory that is in the tide folder. 

The Noah Land Surface Temperature model software is available for download from https://ral.ucar.edu/model/unified-noah-lsm.
This study used NoahTest_v1.91
If you want to run the model on a Mac or Linux box, you will need to compile the source code with a fortran compiler like gfortran.

The MetData directory includes only data for the year 2000. You can download other years
from https://downloads.psl.noaa.gov/Datasets/NARR/monolevel/

The SST directory includes OSTIA, produced by the UK Met Office, using satellite and in-situ date (not including Argo). Argo data are used for validate on. Documentation is available via the links below.
OSTIA reprocessed data (2020-01-01 to 2022-05-31) were obtained from https://data.marine.copernicus.eu/product/SST_GLO_SST_L4_REP_OBSERVATIONS_010_011/description
OSTIA near real time data (after 2022-06-01) were obtained from https://data.marine.copernicus.eu/product/SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001/description


The MaxPlanck Institute for Meteorology tools CDO were used to aggregate the data into 1 year files, subsetted into the region of lons -74 to -59 and lats 40 to 47, using this linux script:

```
#-------------------------------------------
#!/bin/sh
STARNC="*.nc"
for Y in $(seq 2005 2022);do
#Y=2000
cdo -f nc4 -z zip_3 cat -apply,-sellonlatbox,-74,-59,40,47 [ /mnt/p/SST/OSTIA-NRT/$Y/$STARNC ] /mnt/p/SST/OSTIANRT/
OSTIA_US_NEast_$Y.nc
done
#------------------------------------------
```

## Data download

Weekly reproductive proportion data, Newagen 2003 hourly temperature logger data, filtered intertidal temperatures, and site metadata can be downloaded from: https://doi.org/10.5061/dryad.gxd2547wk. This URL also includes example data files for NARR and OSTIA data products and XTide harmonics files.

