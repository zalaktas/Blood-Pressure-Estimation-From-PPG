function [ST,DT] = STDTofPPG(mlocs,plocs)

%This function calculates the means of systolic upstroke time (ST) and 
% diastolic time (DT) of an PPG data  where mlocs correspons to the local
% minimums and plocs to the local maximums


if( (length(mlocs) > length(plocs)) && (plocs(1) > mlocs(1)) )
    ST = zeros(length(plocs),1);
    DT = zeros(length(plocs),1);
    for i = 1: length(plocs)
        ST(i) = plocs(i) - mlocs(i);
        DT(i) = mlocs(i+1) - plocs(i);
    end
end

if( (length(mlocs) < length(plocs)) && (plocs(1) < mlocs(1)) )
    ST = zeros(length(mlocs),1);
    DT = zeros(length(mlocs),1);
    for i = 1: length(mlocs)
        ST(i) = plocs(i+1) - mlocs(i);
        DT(i) = mlocs(i) - plocs(i);
    end
end

%new
if( (length(mlocs) < length(plocs)) && (plocs(1) > mlocs(1)) )
    ST = zeros(length(mlocs),1);
    DT = zeros(length(mlocs),1);
    for i = 1: length(mlocs)-1
        ST(i) = plocs(i) - mlocs(i);
        DT(i) = mlocs(i+1) - plocs(i);
    end
end

if( (length(mlocs) == length(plocs)) && (plocs(1) < mlocs(1)) )
    ST = zeros(length(mlocs)-1,1);
    DT = zeros(length(mlocs)-1,1);
    for i = 1: length(mlocs)-1
        ST(i) = plocs(i+1) - mlocs(i);
        DT(i) = mlocs(i) - plocs(i);
    end
end

if( (length(mlocs) == length(plocs)) && (plocs(1) > mlocs(1)) )
    ST = zeros(length(mlocs)-1,1);
    DT = zeros(length(mlocs)-1,1);
    for i = 1: length(mlocs)-1
        ST(i) = plocs(i) - mlocs(i);
        DT(i) = mlocs(i+1) - plocs(i);
    end
end
    ST = mean(ST);
    DT = mean(DT);
end

