function y = changeSamplingRate(x, Fsinput, Fsoutput)

if size(x,2) ~= 1
    error('size(x,2) must be 1 but is ' + size(x, 2))
end

if Fsinput == Fsoutput
    y = x;
elseif Fsinput > Fsoutput
    stepsize = Fsinput / Fsoutput;
    limit = floor(size(x,1)/stepsize);
    y = zeros(limit,1);
    
    for i = 1:limit
        xFloor = x(floor(i*stepsize));
        xCeil = x(ceil(i*stepsize));
        y(i) = xFloor + mod(i*stepsize, 1) * (xCeil - xFloor);
    end
else
   error('Fsinput should be greater or euqals Fsoutput') 
end

end

