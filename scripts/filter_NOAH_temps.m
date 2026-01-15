%% Filtering NOAH intertidal temperatures
% Date created: 05.15.24
% Date updated: 01.14.26

clear
clc

%% Load + process data in loop, saving results in new folder

filepath = '[CODEPATH HERE]\Sbal_reproduction\NOAH_R_Code_2\model_output\procd_NOAH_temps\';
filepath2 = '[CODEPATH HERE]\Sbal_reproduction\data\NOAH_filt_temps';

listt = dir(filepath); %create list of files in directory
isfile=~[listt.isdir]; %determine index of files vs folders

for i = 3:length(listt) %loop over proc'd files (manually skip directories)
    data = readtable(fullfile(listt(i).folder, listt(i).name)); %load data
    filtT = pl64t(data.body_temp); %apply filter, using default 33 hr cutoff
    data2 = [data table(filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
    writetable(data2,fullfile(filepath2, listt(i).name)); %export
end

% sanity-check plot below (uncomment to run)
%plot(data2.datetime,data2.body_temp,data2.datetime,data2.filtT,'k','Linewidth',2)

%% Process hourly logger data, for Supp. figure

filepath3 = '[CODEPATH HERE]\Sbal_reproduction\data\';
filepath4 = '[CODEPATH HERE]\Sbal_reproduction\data\NOAH_filt_temps';

interT = readtable(fullfile(filepath3,'temps_Nw_int.csv')); %load data
subT = readtable(fullfile(filepath3,'temps_Nw_sub.csv')); %load data

filtT = pl64t(interT.tempC); %apply filter, using default 33 hr cutoff
interT2 = [interT table(filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(interT2,fullfile(filepath4, 'temps_Nw_int_filt.csv')); %export

sub_filtT = pl64t(subT.tempC); %apply filter, using default 33 hr cutoff
subT2 = [subT table(sub_filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(subT2,fullfile(filepath4, 'temps_Nw_sub_filt.csv')); %export

%% Process hourly logger data, for figure

% Newagen 2003
interT = readtable('R\water_temps\temps_Nw_int.csv'); %load data
subT = readtable('R\water_temps\temps_Nw_sub.csv'); %load data

filtT = pl64t(interT.tempC); %apply filter, using default 33 hr cutoff
interT2 = [interT table(filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(interT2,fullfile(filepath4, 'temps_Nw_int_filt.csv')); %export

sub_filtT = pl64t(subT.tempC); %apply filter, using default 33 hr cutoff
subT2 = [subT table(sub_filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(subT2,fullfile(filepath4, 'temps_Nw_sub_filt.csv')); %export


%% Process hourly logger data, for quantitative comparison with model

% Halifax 2003
interT_Hal = readtable('R\water_temps\temps_Hal_int.csv'); %load data

filtT = pl64t(interT_Hal.temp_C); %apply filter, using default 33 hr cutoff
interT2 = [interT_Hal table(filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(interT2,fullfile(filepath4, 'temps_Hal_int_filt.csv')); %export


% Park St 2004
interT_PS04 = readtable('R\water_temps\temps_PS04_int.csv'); %load data

filtT = pl64t(interT_PS04.temp_C); %apply filter, using default 33 hr cutoff
interT2 = [interT_PS04 table(filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(interT2,fullfile(filepath4, 'temps_PS04_int_filt.csv')); %export


% Park St 2022
interT_PS22 = readtable('R\water_temps\temps_PS22_int.csv'); %load data

filtT = pl64t(interT_PS22.temp_C); %apply filter, using default 33 hr cutoff
interT2 = [interT_PS22 table(filtT, 'VariableNames', {'filtT'})]; %combine filtered temps to data
writetable(interT2,fullfile(filepath4, 'temps_PS22_int_filt.csv')); %export
