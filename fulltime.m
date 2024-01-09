clearvars
clc

% load('newdatasetdiatable.mat');
% load('newdatasetsystable.mat');
% load('newdatasetdiaSVM.mat');
% load("newdatasetSysSVM.mat");

load("tableDia.mat");
load("tableSys.mat");
load("newSys.mat");
load("newDiaSVM.mat");

% one reading takes approximetly 60ms 
Fs=1/0.06;

% Array for the sensor values
y = zeros(1, round(6*2.1*Fs));

% Open serıal port
comport = serialport('COM5', 115200);

%Read the weight,height,age,gender
n=1;
while n==1
    dataC = convertStringsToChars(readline(comport));
    data = convertStringsToChars(dataC);
    if isempty(dataC) || strcmp(dataC, '<missing>')
    % Handle case when data is empty
    disp("data empty");
    continue;
    end
    if data(1) == 'A'
        age = str2double(data(2:end));
    elseif data(1) == 'W'
        weight = str2double(data(2:end));
    elseif data(1) == 'H'
        height = str2double(data(2:end));
    elseif data(1) == 'G'
        genderVal = str2double(data(2:end));
        if genderVal ==1
            gender = "Male";
        end
        if genderVal == 0
            gender = "Female";
        end
        n =2;
    else
        disp(data);
    end
end

% Read the data and show on plot
for i = 1:round(6*2.1*Fs)
    data = readline(comport);  % Read data
    try
        y(i) = str2double(data);
    catch
        y(i) = NaN; % Handle the case when the conversion fails
    end
end
%load('sampley.mat') %CDR
y = -y(~isnan(y)); 

% Apply moving average filter to the PPG signal

filtered_ppg = zeros(1,length(y));
for i = 2 : length(y)-1
filtered_ppg(i) = (y(i-1) + y(i) + y(i+1))/3;
end
filtered_ppg(1) = filtered_ppg(2);
filtered_ppg(length(filtered_ppg)-1) = filtered_ppg(length(filtered_ppg)-2);
filtered_ppg(length(filtered_ppg)) = filtered_ppg(length(filtered_ppg)-2);

%detrend
filtered_ppg = detrend(filtered_ppg,1);

%normalize
%filtered_ppg = (filtered_ppg - min(filtered_ppg,[],2))./(max(filtered_ppg,[],2)-min(filtered_ppg,[],2));

%standartize
filtered_ppg = (filtered_ppg - mean(filtered_ppg))/std(filtered_ppg);

%plot
%figure;
t = linspace(0,length(filtered_ppg)/Fs,length(filtered_ppg));
% plot(t,filtered_ppg);
% findpeaks(filtered_ppg,"MinPeakProminence",0.2,"MinPeakDistance",10);
% title('Filtered PPG Signal');
% xlabel('Time (s)');
% ylabel('Amplitude');

%find BPM
%find peak locations:
[~, plocs] = findpeaks(filtered_ppg,"MinPeakProminence",0.1,"MinPeakDistance",10);

%find local minimums
TF = islocalmin(filtered_ppg,'MinSeparation',10,"MinProminence",0.1);
mlocs = find(TF==1); %idx

%mampl = filtered_ppg(mlocs);
%correct the min max points
[plocs,pampl] = newMax(mlocs,plocs,filtered_ppg);
[mlocs,mampl] = newMin(mlocs,plocs,filtered_ppg);

%convert into seconds:
plocs = plocs/Fs;
%convert into seconds
mlocs = mlocs/Fs;

%RtoR intervals:
R2R = diff(plocs);

%average heartrate:
avBPM = 60/mean(R2R);

plot(t,filtered_ppg,mlocs,mampl,'r*',plocs,pampl,'k*')


writeline(comport, "BP:" + round(avBPM));


%calculate the mean systolic upstroke time (ST) and diastolic time (DT)
[ST ,DT] = STDTofPPG(mlocs,plocs); % should be in average 0.54 - 0.27
% %calculate mean %50 pulse width
[halfPW] = mean(nonzeros(PWofPPG(filtered_ppg,0.5,Fs,t)))/2; %0.33
% %calculate mean %66 pulse width
[two3rdsPW] = mean(nonzeros(PWofPPG(filtered_ppg,0.66,Fs,t)))/2;  %0.25

TableDia.SexMF = gender; 
TableSys.SexMF = TableDia.SexMF;
TableDia.Ageyear = age;
TableSys.Ageyear = TableDia.Ageyear;
TableDia.Heightcm = height;
TableSys.Heightcm = TableDia.Heightcm;
TableDia.Weightkg = weight;
TableSys.Weightkg = TableDia.Weightkg;
TableDia.DiastolicBloodPressuremmHg = 0;
TableDia.HeartRatebm = avBPM;
TableSys.HeartRatebm = TableDia.HeartRatebm;
TableDia.BMIkgm2 = TableDia.Weightkg / (0.01*TableDia.Heightcm).^2;
TableSys.BMIkgm2 = TableDia.BMIkgm2;
TableDia.IntraSubjectST = ST;
TableSys.IntraSubjectST = TableDia.IntraSubjectST;
TableDia.IntraSubjectDT = DT;
TableSys.IntraSubjectDT = TableDia.IntraSubjectDT;
TableDia.IntraSubjectHalfPW = halfPW;
TableSys.IntraSubjectHalfPW = TableDia.IntraSubjectHalfPW;
TableDia.IntraSubjectTwo3rdsPW = two3rdsPW;
TableSys.IntraSubjectTwo3rdsPW = TableDia.IntraSubjectTwo3rdsPW;


sysPred = Newsys.predictFcn(TableSys);
diaPred = newDiaSVM.predictFcn(TableDia);
writeline(comport, "DI:" + round(diaPred));
writeline(comport, "SY:" + round(sysPred));
% Clear port
clear comport;

