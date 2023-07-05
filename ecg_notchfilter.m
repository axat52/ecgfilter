clear all;
close all;
clc
fs = 200;
sig= load('ecg3.dat');
ecg_sig = sig - mean(sig);
ecg_spectrum = abs(fft(ecg_sig));
ecg_spectrum = ecg_spectrum(1:length(ecg_spectrum)/2+1);
ecg_spectrum(2:end-1) = 2*ecg_spectrum(2:end-1);
freq = linspace(0, fs/2, length(ecg_spectrum));
n = length(ecg_sig);
t= 1/fs;
ecg_time = (0:(n-1))*t;

figure;
%time domain representation
subplot(2,1,1);
plot(ecg_time,ecg_sig); title('Time Domain Representation of ECG Signal');
xlabel('time(s)'); ylabel('amplitude');xlim([0 3]);ylim([-2 3]);

% Magnitude spectrum
subplot(2,1,2);
plot(freq,abs(ecg_spectrum));
title('Magnitude Spectrum of ECG signal');
xlabel('Frequency(Hz)'); ylabel('Magnitude')

% Filter design
f0=60;Q = 35; % Q-factor of notch
[b, a] = fir1(100, [(f0-Q/2)/(fs/2), (f0+Q/2)/(fs/2)], 'stop');

% Filter design
[h, w] = freqz(b, a, length(ecg_sig));
filter_spectrum = abs(h);
% magnitude spectrum of the filter
figure;
plot(w*fs/(2*pi), filter_spectrum);
hold on;
title('Filter magnitude spectrum ');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%the pole-zero diagram of the filter
figure;
zplane(b,a);

%filtered ECG signal
ecg_filtered = filter(b, a, ecg_sig);
ecg_filtered_spectrum = abs(fft(ecg_filtered-mean(ecg_filtered)));
ecg_filtered_spectrum = ecg_filtered_spectrum(1:length(ecg_filtered_spectrum)/2+1);
ecg_filtered_spectrum(2:end-1) = 2*ecg_filtered_spectrum(2:end-1);
%plot the time-domain of the filtered ECG signal
figure;
subplot(2,1,1)
plot(ecg_filtered);
title('Filtered ECG signal')
xlabel('Time(sample)'); ylabel('Amplitude')
%plot the MAGNITUDE SPECTRUM of FILTERED ECG SIGNAL
subplot(2,1,2)
plot(freq, ecg_filtered_spectrum);
title('Magnitude spectrum of filtered ECG signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');