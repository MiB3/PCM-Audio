function y = aLawQuantize(x)

% A-Law quantizes a range of 13 bits signed integers with 8 bits
scale = pow2(12);
% clamp the signal to be between -1 and 1
clampedX = max(min(x, 1), -1);

% scale the values for the quantization to [-2^12, 2^12]
scaledX = clampedX * scale;
absX = abs(scaledX);

y = zeros(size(absX));

% implement table from https://en.wikipedia.org/wiki/G.711#A-Law 

% row 1
indices = absX < 32; 
y(indices) = absX(indices) - mod(absX(indices), 2) + 1;

for i = 2:8
    % row i
    indices = absX < 2^(4+i) & absX >= 2^(3+i);
    y(indices) = absX(indices) - mod(absX(indices), 2^(i-1)) + 2^(i-2);
end

% clamp to big values
indices = absX >= 2^12;
y(indices) = 2^12 - 2^6;

%add the signs back
indices = scaledX ~= 0;
y(indices) = y(indices) .* sign(scaledX(indices));

% scale back to [-1, 1]
y = round(y) / scale;

end

