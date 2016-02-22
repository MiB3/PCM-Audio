function y = lPCM(x, Fsinput, Fsoutput, bitdepth)

xtmp = x;
if size(xtmp, 1) < size(xtmp,2)
    xtmp = xtmp';
end

for i = 1:size(xtmp,2)
    y(:,i) = changeSamplingRate(xtmp(:,i), Fsinput, Fsoutput);
    y(:,i) = uniformQuantize(y(:,i), bitdepth);
end

end



