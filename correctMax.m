function [plocsOut,pAmpsOut] = correctMax(mlocsIn,plocsIn,func)
% Corrects PPG signal peak and minumum detection where mLocsIn and PlocsIn
% are the perviosuly calculated locals minumums and maximums of PPG signal
% func.

% The nature of the PPG data does not allow two consecative peaks or two
% consecative minumums; i.e every minumum must be followed by a maximum and
% every maximum must be followed by a minumum. So look at the mLocsIn and 
% plocsIn values and if there are two consecatives, take the maximum or
% minumum of the function in that interval. And update the mLocs and Plocs
% values.


%For the case in which func starts with a minima

if(mlocsIn(1)<plocsIn(1))

    %Check for consecative minima

    for i = 1:length(mlocsIn)-1
        if(((mlocsIn(i) < plocsIn(i)) && (plocsIn(i) < mlocsIn(i+1))))
            
            %Local maximum is between two minimums so it is valid.
            plocsOut(i) = plocsIn(i);
            pAmpsOut(i) = func(plocsOut(i));
        
        else
            
            %If there is no local maximum between two minimums, so we should find one
            
            [~,plocsOut(i)] = max(func(mlocsIn(i):mlocsIn(i+1)));

            plocsOut(i) = plocsOut(i) + mlocsIn(i) -1;

            pAmpsOut(i) = func(plocsOut(i));
            
            
        end
    end
 end

 %For the case in which func starts with a maxima

if(plocsIn(1)<mlocsIn(1))
    plocsOut(1) = plocsIn(1);
    pAmpsOut(1) = plocsOut(1);
    %Check for consecative minima
    for i = 1:length(plocsIn)-1
        if(((mlocsIn(i) < plocsIn(i+1)) && (plocsIn(i+1) < mlocsIn(i+1))))
            
            %Local maximum is between two minumums so it is valid.
            plocsOut(i+1) = plocsIn(i+1);
            pAmpsOut(i+1) = plocsOut(i+1);
        else
            
            %If there is no local maximum between two minumums, so we should find one
            
            [~,plocsOut(i+1)] = max(func(mlocsIn(i):mlocsIn(i+1)));
            
            plocsOut(i+1) = plocsOut(i+1) + mlocsIn(i) -1;
            pAmpsOut(i+1) = plocsOut(i+1);
        end
    end

 end

end