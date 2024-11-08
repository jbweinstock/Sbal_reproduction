#Make control file from info in noah.in and values passed from NOAH make_input_files
#Usage:  make_control_file<-function(infile="noah.in",path="/data/NOAH_R_Code_2/",template,d_t=1800.0,albedo=0.5,t.k.initial=285.0,add_ic=FALSE)
#------------------------------------------------------------------------------------------
#DSW 20180604
# original version
#------------------------------------------------------------------------------------------
#DSW 20181216
# add_ic=TRUE
# This allows merging of NOAH end of run state variable data into the control file for continuation of run.
# Multi-year runs can be obtained with this option, if the noah model is run as nt191 1>NOAH_messages.txt
#  The last 10 lines of the NOAH_messages.txt file has the model final conditions in the format needed
#  for inclusion in controlfile.1 as initial state variables for the next run.
#------------------------------------------------------------------------------------------
#Symbols   in controlfile.1.herrera.barnacle.sym
#------------------------------------------------------------------------------------------
# XXJDAY        JDAY......Initial julian day of simulation (1-366)
# XXTIME        TIME......Initial time "hhmm", where: hh=hour(0-23), mm=min(0-59)
# XXNCYC        NCYCLES...Cycles the forcing data (useful for spin-up runs)
#   365         SYDAYS....DAYS IN SPIN-UP YEAR(ea. SpUp yr has Sysec/dt t_steps)
#.FALSE.        L2nd_data.Uses 2nd forcing data file (useful after spin-up runs)
# XXNRUN        NRUN......Total # of simulation time steps
# XXDT          DT........Time step for integration in sec (not more than 3600)
#   20          NSOIL.....Number of soil layers (2-20)
# XXZ           Z.........Height (above ground) of the forcing wind vector  (m)
#    0.003  0.003  0.004  0.010  0.010  0.010  0.010  0.010  0.010  0.010  0.030  0.050  0.150  0.200  0.200  0.200  0.200  0.200  0.200  0.200    K=1,NSOIL...thickness of each soil layer (m)
#  Monthly ALBEDO (snow free albedo):
#   J*   F    M    A*   M    J    J*   A    S    O*   N    D
#  XXALB XXALB XXALB XXALB XXALB XXALB XXALB XXALB XXALB XXALB XXALB XXALB
# ------------------
#Physical parameters:
# ------------------
#  XXT1         TBOT......Annual constant bottom boundary soil temperature (K)
# ----------------------
#Initial state variables:
# ----------------------
#   XXT1       T1........Skin temperature (K)
#   XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1       XXT1      STC
#------------------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------------------
make_control_file<-function(infile="noah.in",path="D:/NOAH_R_Code_2/",template,d_t=1800.0,albedo=0.5,t.k.initial=285.0,add_ic=FALSE)
{
  model.in<-read.delim(paste(path,infile,sep=""),header=FALSE,sep="")	#read model input file
  new.ctrl<-paste(path,"controlfile.1",sep="")							#new control file
  template.ctrl<-readLines(paste(path,"/",template,sep=""))  		#controlfile.1.herrera.barnacle.sym"
  jd<-model.in[1,1]						#initial jday
  hhmm<-model.in[1,2]						#initial hhmm
  hhmm2<-model.in[2,2]					#second hhmm
  z<-10									#wind speed height
  alb<-albedo								#albedo
  t1<-3600*hhmm%/%100 + 60*hhmm%%100		#initial time of day
  t2<-3600*hhmm2%/%100 + 60*hhmm2%%100	#second time of day
  dt0<-t2-t1								#time step of input data
  delta_t<-d_t								#time step of model
  nrun<-(nrow(model.in)-2)*dt0/d_t			#number of model iterations (last line is blank)
  
  new.ctrl<-gsub("XXJDAY",jd,template.ctrl)	#replace XXJDAY with jd value from noah.in
  new.ctrl<-gsub("XXTIME",hhmm,new.ctrl)		#replace XXTIME with hhmm value from noah.in
  new.ctrl<-gsub("XXNRUN",nrun,new.ctrl)		#replace XXNRUN with nrun calculated in this function
  new.ctrl<-gsub("XXDT",delta_t,new.ctrl)		#default dt is 1800 seconds
  new.ctrl<-gsub("XXZ","10.0",new.ctrl)		#default wind height is 10m
  new.ctrl<-gsub("XXALB",albedo,new.ctrl)		#replace XXALB with albedo
  new.ctrl<-gsub("XXT1",t.k.initial,new.ctrl)	#replace XXT1 withinitial kelvin temperature
  if(add_ic==TRUE)							#initial conditions from NOAH output of previous run
  {NOAH_output<-readLines(paste(path,"NOAH_messages.txt",sep=""))
  ic_end_flag<-"   Do not confuse this with the initial conditions"
  ic_offset<-8
  ic_end<-grep(ic_end_flag,NOAH_output)-1
  ic_start<-ic_end-ic_offset
  NOAH_output[ic_start:ic_end]
  cf_last<-"----- END OF READABLE CONTROLFILE -----------------------------------------------"
  ctrl.bot<-c(NOAH_output[ic_start:ic_end],cf_last)
  new.ctrl<-c(new.ctrl,ctrl.bot)
  }
  writeLines(new.ctrl,paste(path,"controlfile.1",sep=""))	#write the new control file
}
