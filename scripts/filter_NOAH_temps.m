%% Filtering NOAH intertidal temperatures
% Date created: 05.15.24
% Date updated: 11.07.24

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

