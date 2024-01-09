function [plocsOut,pAmpsOut] = newMax(mlocsIn,plocsIn,func)
% Corrects PPG signal peak and minumum detection where mLocsIn and PlocsIn
% are the perviosuly calculated locals minumums and maximums of PPG signal
% func.

% The nature of the PPG data does not allow two consecative peaks or two
% consecative minumums; i.e every minumum must be followed by a maximum and
% every maximum must be followed by a minumum. So look at the mLocsIn and 
% plocsIn values and if there are two consecatives, take the maximum or
% minumum of the function in that interval. And update the mLocs and Plocs
% values.


%Local maximum is between two minimums so it is valid.
plocsOut = plocsIn;
pAmpsOut = func(plocsOut);

%For the case in which func starts with a minima

if(mlocsIn(1)<plocsIn(1))

    %Check for consecative minima

    for i = 1:min(length(plocsOut),length(mlocsIn)-1)
        if((~((mlocsIn(i) < plocsOut(i)) && (plocsOut(i) < mlocsIn(i+1)))))        
            %If there is no local maximum between two minimums, we should find one
            
            [~,maxIdx] = max(func(mlocsIn(i):mlocsIn(i+1)));

            plocsOut = [plocsOut(1:i-1) (maxIdx + mlocsIn(i) -1) plocsOut(i:end)];

            pAmpsOut = func(plocsOut);

        end
    end
 end

 %For the case in which func starts with a maxima

if(plocsIn(1)<mlocsIn(1))
    %Check for consecative minima
    for i = 1:min(length(mlocsIn)-1,length(plocsIn)-1)
        if((~((mlocsIn(i) < plocsOut(i+1)) && (plocsOut(i+1) < mlocsIn(i+1)))))
            %If there is no local maximum between two minumums, we should find one
            
            [~,maxIdx] = max(func(mlocsIn(i):mlocsIn(i+1)));
            
            plocsOut = [plocsOut(1:i) (maxIdx + mlocsIn(i) -1) plocsOut(i+1:end) ] ;
            pAmpsOut = func(plocsOut);
        end
    end
 end

end