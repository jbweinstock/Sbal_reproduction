# Sbal_reproduction
Code for paper: Latitudinal differences in embryonic development mediate the seasonal timing of larval release



## Noah Intertidal Temperature Model code

NOAH_IntertidalModel has the following directory trees below it. I recommend keeping this overall tree structure.
MetData: North American Regional Reanalysis data for 2000
NOAH_LSM: Source code for NOAH intertidal model
NOAH_R_Code_2: R code [and NOAH windows pc executable (nt191.exe)]
SST: OSTIA reprocessed SST subset for Northeast US/Canada coast for 2000
tide: [xtide.exe windows pc executable] and harmonics files

The R programs need to be edited to indicate where data and programs reside

You can get updated harmonics from https://flaterco.com/files/xtide/harmonics-dwf-20240104-free.tar.xz
Source code is here https://flaterco.com/files/xtide/xtide-2.15.5.tar.xz
You will need to create an environment variable HFILE_PATH that should have the path to the harmonics directory that is in the tide folder. PDF instructions for ways to do this are included in the toplevel directory.

The intertidal temperature model (NOAH) is in NOAH_LSM
The source code is NoahTest_v1.91.f (in NOAH_LSM)
If you want to run it on a Mac or Linux box, you will need to compile the source code with a fortran compiler like gfortran.

The MetData directory includes only data for the year 2000. You can download other years
from https://downloads.psl.noaa.gov/Datasets/NARR/monolevel/

The SST directory includes OSTIA, produced by the UK Met Office, using satellite and in-situ date (not including Argo). Argo data are used for validate on. Documentation is available via the links below.
OSTIA reprocessed data (2020-01-01 to 2022-05-31) were obtained from https://data.marine.copernicus.eu/product/SST_GLO_SST_L4_REP_OBSERVATIONS_010_011/description
OSTIA near real time data (after 2022-06-01) were obtained from https://data.marine.copernicus.eu/product/SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001/description


The MaxPlanck Institute for Meteorology tools CDO were used to aggregate the data into 1 year files, subsetted into the region of lons -74 to -59 and lats 40 to 47, using this linux script:



#-------------------------------------------

#!/bin/sh

STARNC="*.nc"

for Y in $(seq 2005 2022);do

#Y=2000

cdo -f nc4 -z zip_3 cat -apply,-sellonlatbox,-74,-59,40,47 [ /mnt/p/SST/OSTIA-NRT/$Y/$STARNC ] /mnt/p/SST/OSTIANRT/

OSTIA_US_NEast_$Y.nc

done

#------------------------------------------


