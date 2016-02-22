function y = uniformQuantize(x, bitdepth) 

scale = pow2(bitdepth-1);
% clamp the signal to be between -1 and 1
y = max(min(x, 1), -1);
% do the quantization
y = round(y * scale);
y(y == scale) = scale - 1; % + 2^(bitdepth-1) can not be represented with twos complement
y = y / scale;

end

