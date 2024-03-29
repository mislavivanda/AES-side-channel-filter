for i=1:1
    readIndexString = num2str(i+1);
    filename = ['SDS0000' readIndexString '.csv'];
    data = csvread(filename);
    col2 = data(:, 2); %data
    col3 = data(:, 3); %trigger
    %buterworh filter
    filter_order = 10;
    f_sampling = 50000000;
    % spectogram, center frequency 16MHz
    passband_lower = 15000000;
    passband_upper = 17000000;
    Wp = [passband_lower  passband_upper]/(f_sampling/2);
    Ws = [0.9 1.1].*Wp;
    Rp =  3; % Passband Ripple For Lowpass Filter (dB)
    Rs = 40; % Stopband Ripple (Attenuation) For Lowpass Filter (dB)
    [n,Wn] = buttord(Wp,Ws,Rp,Rs);
    [b,a] = butter(n, Wn,'bandpass');
    %Extract only AES part of signal with trigger signal
    startIndexAES = 0;
    stopIndexAES = length(col3);
    for j=1:length(col3)
        if col3(j) > 4
            startIndexAES=j;
            break;
        end
    end
    for j=startIndexAES:length(col3)
        if col3(j) < 4
            stopIndexAES=j;
            break;
        end
    end
    roundSampleCount = (stopIndexAES - startIndexAES) / 10;
    startLastRoundAES = floor(stopIndexAES - roundSampleCount);
    signalData=[];
    triggerData=[];
    for j=1:length(col2)
        if j >= startLastRoundAES && j <= stopIndexAES
            signalData(end + 1) = col2(j);
            triggerData(end + 1) = col3(j);
        end
    end
    sampleNumber = [1:length(signalData)];
    filtered_signal = filter(b,a,signalData);
%     plot(sampleNumber, filtered_signal);
    csvMatrix = [sampleNumber(:), filtered_signal(:)];
    outputIndexString = num2str(i);
    outputName = ['samplex' outputIndexString '.csv'];
    csvwrite(outputName, csvMatrix);
end