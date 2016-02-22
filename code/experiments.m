close all;

imageFolder = '../images/';

soundFolder = '../sounds/';

%% Sinus plot

bounds = [0, 1];

freq = 1; % Hz
fs = 1000; % Sampling period from f
duration = bounds(2) * 1/freq;

t = 0 : 1/fs : duration;

sinsound = sin(2*pi*freq*t);

linearSinsound = uniformQuantize(sinsound, 6);

aLawSinsound = aLawQuantize(sinsound);

figure;
plot(t, sinsound);
title('Without quantization');
xlabel('Time');
ylabel('Sinevalue');
set(gca, 'XTick', bounds(1):0.5:bounds(2));
set(gca, 'YTick', -1:0.2:1);
xlim(bounds);
ylim([-1, 1]);

print([imageFolder 'sinWithoutQuantization'], '-dpng')

figure;
plot(t, linearSinsound);
title('Linear Quantization');
xlabel('Time');
ylabel('Quantized Sinevalue');
set(gca, 'XTick', bounds(1):0.5:bounds(2));
set(gca, 'YTick', -1:0.2:1);
xlim(bounds);
ylim([-1, 1]);

print([imageFolder 'sinLinearQuantization'], '-dpng')

figure;
plot(t, aLawSinsound);
title('A-Law Quantization');
xlabel('Time');
ylabel('Quantized Sinevalue');
set(gca, 'XTick', bounds(1):0.5:bounds(2));
set(gca, 'YTick', -1:0.2:1);
xlim(bounds);
ylim([-1, 1]);

print([imageFolder 'sinALawQuantization'], '-dpng')


%% speech different bitdepth

[y, fs] = audioread([soundFolder 'speech_orig.wav']);
y = y(:,1); % consider only one channel
y = y/max(abs(y)); % scale to -1, 1

samplingRate = 1:16;
mselinear = samplingRate;
for i = samplingRate
    mselinear(i) = mean((y - lPCM(y, fs, fs, i)).^2);
end
msealaw = mean((y - aLawPCM(y, fs, fs)).^2) * ones(size(samplingRate));

figure;
semilogy(samplingRate, mselinear, samplingRate, msealaw);
title('MSE for different bit depths (speech)');
xlabel('bit depth');
ylabel('MSE');
set(gca, 'XTick', samplingRate(1):1:samplingRate(end));
%set(gca, 'YTick', -1:0.2:1);
xlim([samplingRate(1), samplingRate(end)]);
%ylim([-1, 1]);
legend('Linear', 'A-Law')

print([imageFolder 'speechBitDepth'], '-dpng')

%% speech sampling rate

[y, fs] = audioread([soundFolder 'speech_orig.wav']);
y = y(:,1); % consider only one channel
y = y/max(abs(y)); % scale to -1, 1

% 48000 Hz, the original sampling frequency needs to be dividable by the
% sampling rates to ensure a proper calculation of the MSE.
samplingRate = [2000, 3000, 4000, 6000, 8000, 12000, 16000, 24000, 48000];
mselinear = samplingRate;
msealaw = samplingRate;
for i = 1:size(samplingRate,2)
    mselinear(i) = mean((y(1:48000/samplingRate(i):end) - lPCM(y, fs, samplingRate(i), 8)).^2);
end
msealaw = mean((y(1:48000/8000:end) - aLawPCM(y, fs, 8000)).^2) * ones(size(samplingRate));

figure;
semilogy(samplingRate, mselinear, samplingRate, msealaw);
title('MSE for different sampling rates (speech)');
xlabel('sampling rate in Hz');
ylabel('MSE');
set(gca, 'XTick', samplingRate(1):4000:samplingRate(end));
%set(gca, 'YTick', -1:0.2:1);
xlim([samplingRate(1), samplingRate(end)]);
%ylim([-1, 1]);
legend('Linear', 'A-Law')

print([imageFolder 'speechSamplingRate'], '-dpng')


%% speech unmodified

[y, fs] = audioread([soundFolder 'speech_orig.wav']);
y = y(:,1); % consider only one channel
y = y/max(abs(y)); % scale to -1, 1

% time axis vector
t = linspace(0,size(y,1) / fs, size(y,1));

% plot time domain waveform
figure;
plot(t, y)
title('Unmodified voice signal');
ylabel('Amplitude');
xlabel('Time in s');
xlim([t(1), t(end)]);
ylim([-1, 1]);

print([imageFolder 'speechUnmodified'], '-dpng')

%% speech G711

[y, fs] = audioread([soundFolder 'speech_orig.wav']);
y = y(:,1); % consider only one channel
y = y/max(abs(y)); % scale to -1, 1

y = g711(y, fs);

% time axis vector
t = linspace(0,size(y,1) / 8000, size(y,1));

% plot time domain waveform
figure;
plot(t, y)
title('G.711 processed voice signal');
ylabel('Amplitude');
xlabel('Time in s');
xlim([t(1), t(end)]);
ylim([-1, 1]);

print([imageFolder 'speechG711'], '-dpng')

%% speech aduiowrite

[yunmodified, fs] = audioread([soundFolder 'speech_orig.wav']);
yunmodified = yunmodified / max(abs(yunmodified));

yG711 = g711(yunmodified, fs);
yLPCM = lPCM(yunmodified, fs, 8000, 8);
yALaw = aLawPCM(yunmodified, fs, 8000);

audiowrite([imageFolder '/../sounds/speech_unmodified.wav'], yunmodified, fs);
audiowrite([imageFolder '/../sounds/speech_G711.wav'], yG711, 8000);
audiowrite([imageFolder '/../sounds/speech_linear.wav'], yLPCM, 8000);
audiowrite([imageFolder '/../sounds/speech_ALaw.wav'], yALaw, 8000);

