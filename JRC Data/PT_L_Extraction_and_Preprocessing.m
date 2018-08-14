tic
pt_l_FileNames = {'WR33_2017-05-04_SingleUnit1001.mat'...
    'WR33_2017-05-05_SingleUnit1001.mat'...
    'WR33_2017-05-05_SingleUnit1002.mat'...
    'WR33_2017-05-05_SingleUnit1003.mat'...
    'WR33_2017-05-06_SingleUnit1001.mat'...
    'WR33_2017-05-11_SingleUnit1001.mat'...
    'WR33_2017-05-11_SingleUnit1002.mat'...
    'WR33_2017-05-12_SingleUnit1001.mat'...
    'WR33_2017-05-12_SingleUnit1002.mat'...
    'WR33_2017-05-13_SingleUnit1002.mat'...
    'WR33_2017-05-14_SingleUnit1001.mat'...
    'WR33_2017-05-14_SingleUnit1002.mat'...
    'WR33_2017-05-14_SingleUnit1003.mat'...
    'WR33_2017-05-19_SingleUnit1001.mat'...
    'WR33_2017-05-19_SingleUnit1002.mat'...
    'WR34_2017-05-20_SingleUnit1001.mat'...
    'WR34_2017-05-22_SingleUnit1001.mat'...
    'WR36_2017-06-15_SingleUnit1001.mat'...
    'WR36_2017-06-15_SingleUnit1002.mat'...
    'WR36_2017-06-15_SingleUnit1003.mat'...
    'WR36_2017-06-17_SingleUnit1001.mat'...
    'WR38_2017-07-13_SingleUnit1001.mat'...
    'WR38_2017-07-13_SingleUnit1002.mat'...
    'WR38_2017-07-13_SingleUnit1003.mat'...
    'WR38_2017-07-15_SingleUnit1001.mat'...
    'WR38_2017-07-16_SingleUnit1001.mat'...
    'WR38_2017-07-16_SingleUnit1002.mat'...
    'WR38_2017-07-17_SingleUnit1001.mat'...
    'WR39_2017-06-15_SingleUnit1001.mat'...
    'WR39_2017-06-16_SingleUnit1001.mat'...
    'WR39_2017-06-17_SingleUnit1001.mat'...
    'WR39_2017-06-18_SingleUnit1001.mat'...
    'WR39_2017-06-19_SingleUnit1001.mat'...
    'WR40_2017-06-08_SingleUnit1001.mat'...
    'WR40_2017-06-08_SingleUnit1002.mat'...
    'WR40_2017-06-08_SingleUnit1003.mat'...
    'WR40_2017-06-08_SingleUnit1004.mat'...
    'WR40_2017-06-10_SingleUnit1001.mat'...
    'WR40_2017-06-11_SingleUnit1001.mat'...
    'WR40_2017-06-12_SingleUnit1001.mat'...
    'WR41_2017-06-08_SingleUnit1001.mat'...
    'WR41_2017-06-08_SingleUnit1002.mat'...
    'WR41_2017-06-09_SingleUnit1001.mat'...
    'WR41_2017-06-09_SingleUnit1002.mat'...
    'WR41_2017-06-09_SingleUnit1003.mat'...
    'WR41_2017-06-10_SingleUnit1001.mat'...
    'WR41_2017-06-11_SingleUnit1001.mat'...
    'WR41_2017-06-11_SingleUnit1002.mat'...
    'WR41_2017-06-11_SingleUnit1003.mat'...
    'WR41_2017-06-13_SingleUnit1001.mat'...
    'WR42_2017-07-13_SingleUnit1001.mat'...
    'WR42_2017-07-14_SingleUnit1001.mat'...
    'WR42_2017-07-14_SingleUnit1002.mat'...
    'WR42_2017-07-14_SingleUnit1003.mat'...
    'WR42_2017-07-14_SingleUnit1004.mat'...
    'WR42_2017-07-15_SingleUnit1001.mat'...
    'WR42_2017-07-16_SingleUnit1001.mat'...
    'WR42_2017-07-16_SingleUnit1002.mat'...
    'WR42_2017-07-16_SingleUnit1003.mat'...
    'WR42_2017-07-16_SingleUnit1004.mat'...
    'WR42_2017-07-17_SingleUnit1001.mat'...
    'WR42_2017-07-17_SingleUnit1002.mat'...
    'WR42_2017-07-18_SingleUnit1001.mat'...
    'WR42_2017-07-18_SingleUnit1002.mat'};

% Pre-allocation of matrix
L = zeros(907564, 44);
for file = 1:length(pt_l_FileNames)
    fprintf('Loaded ' + string(pt_l_FileNames(file)) + '\n')
    load(string(pt_l_FileNames(file)))
    % Access each waveform of the unit
    for x = 1:size(unit.waveform,1)
        %fill with features
        maxIdx = wvfrmExtraction(unit.waveform(x,:));
        numWvfrm = int16(size(unit.waveform,2) / 32);
        inputWvfrm = unit.waveform(x,((32*(maxIdx-1) + 1):(maxIdx * 32)));
        inputST = unit.spike_times;
        L(x,1) = 2;
        L(x,2) = fullAmplitude(inputWvfrm);
        L(x,3) = negAmplitude(inputWvfrm);
        L(x,4) = posAmplitude(inputWvfrm);
        L(x,5) = widthTP(inputWvfrm);
        L(x,6) = widthPT(inputWvfrm);
        isiArr = interspike(inputST);
        L(x, 7) = isiArr(x);
        regArr = regularity(isiArr);
        L(x,8) = regArr(x);
        eT_len = length(inputST);
        L(x,9) = burstiness(isiArr, eT_len);
        if numWvfrm == 5
            L(x,10) = unit.channel(x) + (maxIdx - 3);
        else
            L(x,10) = unit.channel(x) + (maxIdx - 4);
        end
        L(x,11) = unit.shank;
        L(x,12) = unit.ix(x,1);
        for ind = 13:44
            L(x, ind) = inputWvfrm(ind - 12); 
        end
    end
fprintf('Completed ' + string(pt_l_FileNames(file)) + '\n')
end
toc

% Extract largest waveform of 5-7 waveforms
function idx = wvfrmExtraction(w)
    amplitude = zeros(7, 2);
    numWvfrm = int16(size(w,2) / 32);
    maxIdx = 0;
    maxAmp = -1;
    for wvfrm = 1:numWvfrm
        amplitude(wvfrm,1) = fullAmplitude(w((32*(wvfrm-1) + 1):(wvfrm * 32)));
        amplitude(wvfrm,2) = wvfrm;
        if amplitude(wvfrm,1) > maxAmp
            maxAmp = amplitude(wvfrm,1);
            maxIdx = amplitude(wvfrm,2);
        end
    end
    idx = maxIdx; 
end

% Full amplitude - Maximum - minimum
function fA = fullAmplitude(w)
    minVal = min(w);
    maxVal = max(w);
    fA = maxVal - minVal;
end

% Negative amplitude - 0 - minimum
function nA = negAmplitude(w)
    minVal = min(w);
    nA = 0 - minVal;
end

% Positive amplitude - Max - 0
function pA = posAmplitude(w)
    maxVal = max(w);
    pA = maxVal;
end

% Recovery time - Distance from trough to first peak after trough
function wTP = widthTP(w)
    minVal = min(w);
    minInd = find(w == minVal);
    if size(minInd, 2) > 1
        minInd = minInd(1);
    end
    wNew = w(minInd:32);
    maxVal = max(wNew);
    maxInd = find(w == maxVal);
    if size(maxInd, 2) > 1
        maxInd = maxInd(1);
    end
    wTP = maxInd - minInd;
end

% Spike time - Distance from initial peak to trough
function wPT = widthPT(w)
    minVal = min(w);
    minInd = find(w == minVal);
    if size(minInd, 2) > 1
        minInd = minInd(1);
    end
    wNew = w(1:minInd);
    maxVal = max(wNew);
    maxInd = find(w == maxVal);
    if size(maxInd, 2) > 1
        maxInd = maxInd(1);
    end
    wPT = minInd - maxInd;
end

% Interspike interval - Time between consecutive spikes
function isi = interspike(eT)
    %look at diff between spike times; ISI array same size
    %as waveforms
    diffET = zeros(1,length(eT));
    for time = 1:length(eT)-1
        %for when time loops to 0 because of new trial
        if eT(time+1) < eT(time)
            diffET(time) = mean(diffET(1:time-1));
        else
            diffET(time) = eT(time + 1) - eT(time);
        end
    end
    diffET(length(eT)) = mean(diffET);
    isi = diffET; 
end

% Regularity - variance of the ratio between consecutive ISIs
function reg = regularity(isiArray)
    ratios = zeros(1,length(isiArray));
    for isiN = 1:length(isiArray)-1
        ratios(isiN) = (((isiArray(isiN)) / (isiArray(isiN+1) + isiArray(isiN))) - 0.5)^2;
    end
    ratios(length(isiArray)) = mean(ratios);
    reg = ratios;
end
    
% Burstiness - the number of ISIs that are less than a tenth of the mean,
%   implying a burst
function b = burstiness(isiArray2, eT_len)
    %fraction of ISIs less than a tenth of the average ISI
    count = 0;
    meanISI = mean(isiArray2(1:eT_len));
    for indISI = 1:length(isiArray2(1:eT_len))
        if (isiArray2(indISI) ~= 0) && (isiArray2(indISI) < (0.1 * meanISI))
            count = count + 1;
        end
    end
    b = count;
end
