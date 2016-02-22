function y = aLawPCM(x, Fsinput, Fsoutput)

xtmp = x;
if size(xtmp, 1) < size(xtmp,2)
    xtmp = xtmp';
end

for i = 1:size(xtmp,2)
    y(:,i) = changeSamplingRate(xtmp(:,i), Fsinput, Fsoutput);
    y(:,i) = aLawQuantize(y(:,i));
end

end





