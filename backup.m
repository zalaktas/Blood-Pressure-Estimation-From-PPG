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

y = y(50:end);
figure()
plot(1:length(y),y);

% one reading takes approximetly 60ms 
Fs=1/0.06;

% Chebyshev-II filter parameters
Rp = 0.5;  % Passband ripple in dB
Rs = 10; % Stopband attenuation in dB
Fpass1 = 0.4;  % Lower cut-off frequency in Hz
Fpass2 = 8;    % Upper cut-off frequency in Hz

% Design the 4th-order Chebyshev-II filter
[n, Wn] = cheb2ord(Fpass1/(Fs/2), Fpass2/(Fs/2), Rp, Rs);
[b, a] = cheby2(n, Rs, Wn);

ppg_signal = y;
% Apply the filter to the PPG signal
filtered_ppg = filtfilt(b, a, ppg_signal);


%normalize
ppg_signal = (ppg_signal - min(ppg_signal,[],2))./(max(ppg_signal,[],2)-min(ppg_signal,[],2));
filtered_ppg = (filtered_ppg - min(filtered_ppg,[],2))./(max(filtered_ppg,[],2)-min(filtered_ppg,[],2));

t = linspace(0,length(filtered_ppg)/Fs,length(filtered_ppg));

%plot
figure;
subplot(2,1,1);
plot(t, ppg_signal);
title('Original PPG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filtered_ppg);
title('Filtered PPG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

%find BPM
%find peak locations:
[pampl , plocs] = findpeaks(filtered_ppg,"MinPeakHeight",0.4,"MinPeakProminence",0.1);

%convert into seconds:
plocs = plocs/Fs;

%RtoR intervals:
R2R = diff(plocs);

%average heartrate:
avBPM = 60/mean(R2R);

writeline(comport, "BP:" + avBPM);

% Clear port
clear comport;
