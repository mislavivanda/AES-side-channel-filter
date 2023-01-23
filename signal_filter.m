clear;
data = csvread('1GS.csv');
col1 = data(:, 1); %uzmi sve retke od prvog stupca
col2 = data(:, 2); %uzmi sve retke od drugog stupca
subplot(3, 1, 1);
plot(col1, col2);
%buterworh filter
filter_order = 10;
f_sampling = 100000000;
% iz spektograma
passband_lower = 12000000;%12 MHz
passband_upper = 20000000;%20 MHz
Wp = [passband_lower  passband_upper]/(f_sampling/2);
Ws = [0.9 1.1].*Wp;

Rp =  3;                                                        % Passband Ripple For Lowpass Filter (dB)
Rs = 40;                                                        % Stopband Ripple (Attenuation) For Lowpass Filter (dB)
[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n, Wn,'bandpass');
%[b,a] = butter(filter_order, [passband_lower  passband_upper]/(f_sampling/2),'bandpass');
%y = filtfilt(b,a,x)
%MAKNI NEBITNE DJELOVE SIGNALA
signalData=[];
for i=1:length(col2)
%     if col1(i) > 0.2325
%         signalData(end + 1) = filtered_signal(i);
%     end
    if abs(col2(i)) > 0.02
        signalData(end + 1) = col2(i);
    end
end
sampleNumber = [1:length(signalData)];
subplot(3,1,2);
plot(sampleNumber, signalData);
filtered_signal = filter(b,a,signalData);
% filtered_signal = filter(b,a,col2);
subplot(3, 1, 3);
% signalData=[];
% for i=1:length(filtered_signal)
% %     if col1(i) > 0.2325
% %         signalData(end + 1) = filtered_signal(i);
% %     end
%     if abs(filtered_signal(i)) > 0.01
%         signalData(end + 1) = filtered_signal(i);
%     end
% end
% sampleNumber = [1:length(signalData)];
%plot(sampleNumber, signalData);
plot(sampleNumber, filtered_signal);
%iscrtaj prvu rundu od 10
% subplot(4, 1, 4);
% firstRound = [];
% for i=1:ceil(length(filtered_signal) / 10)
%     firstRound(i) = filtered_signal(i);
% end
% firstRoundNumbers = [1:length(firstRound)];
% plot(firstRoundNumbers, firstRound);
%plot(col1, filtered_signal);