function [y, fsout] = g711(x, fs)

fsout = 8000; % output sampling frequency is 8000
maxFreq = 3400; % highest transmitted frequency
minFreq = 300; % lowest transmitted frequency

% remove low and high frequecies, only keep 300 - 3400 Hz
% http://www.aquaphoenix.com/lecture/matlab10/page4.html
fsNormHigh = maxFreq / (fs/2);
fsNormLow = minFreq / (fs/2);
[b, a] = butter(5, [fsNormLow, fsNormHigh], 'bandpass');
y = filtfilt(b, a, x);

y = aLawPCM(y, fs, fsout);

end

