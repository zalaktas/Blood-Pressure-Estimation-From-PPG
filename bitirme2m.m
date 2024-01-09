clearvars
clc

% one reading takes approximetly 60ms 
Fs=1/0.06;

% Array for the sensor values
y = zeros(1, round(6*2.1*Fs));

% Open serıal port
comport = serialport('COM5', 115200);

% Read the data and show on plot
for i = 1:round(6*2.1*Fs)
    data = readline(comport);  % Read data
    try
        y(i) = str2double(data);
    catch
        y(i) = NaN; % Handle the case when the conversion fails
    end
end

y = y(round(2.1*Fs)+1:end); 

% Chebyshev-II filter parameters
Rp = 0.5;  % Passband ripple in dB
Rs = 10; % Stopband attenuation in dB
Fpass1 = 0.4;  % Lower cut-off frequency in Hz
Fpass2 = 8;    % Upper cut-off frequency in Hz

% Design the 4th-order Chebyshev-II filter
[n, Wn] = cheb2ord(Fpass1/(Fs/2), Fpass2/(Fs/2), Rp, Rs);
[b, a] = cheby2(n, Rs, Wn);

% Apply the filter to the PPG signal
filtered_ppg = filtfilt(b, a, y);
ppg_signal = reshape(filtered_ppg,[],5)';

%normalize
ppg_signal = (ppg_signal - min(ppg_signal,[],2))./(max(ppg_signal,[],2)-min(ppg_signal,[],2));

%plot
figure;

for i = 1:5
    t = linspace(0,length(ppg_signal)/Fs,length(ppg_signal));
    subplot(3, 2, i);
    plot(t,ppg_signal(i, :));
    findpeaks(ppg_signal(i, :),"MinPeakHeight",0.6,"MinPeakDistance",10);
    title('Filtered PPG Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
end


% 
% %find BPM
% %find peak locations:
% [pampl , plocs] = findpeaks(filtered_ppg,"MinPeakHeight",0.4,"MinPeakProminence",0.1);
% 
% %convert into seconds:
% plocs = plocs/Fs;
% 
% %RtoR intervals:
% R2R = diff(plocs);
% 
% %average heartrate:
% avBPM = 60/mean(R2R);
% 
% writeline(comport, "BP:" + avBPM);

% Clear port
clear comport;
