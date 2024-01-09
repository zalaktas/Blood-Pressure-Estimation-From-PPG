function [mlocsOut,mAmpsOut] = correctMin(mlocsIn,plocsIn,func)
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
    mlocsOut(1) = mlocsIn(1);
    mAmpsOut(1) = func(mlocsOut(1));
    %Check for consecative maxima
    for i = 1:length(plocsIn)-1
        if(((plocsIn(i) < mlocsIn(i+1)) && (mlocsIn(i+1) < plocsIn(i+1))))
            
            %Local minimum is between two maximums so it is valid.
            mlocsOut(i+1) = mlocsIn(i+1);
            mAmpsOut(i+1) = func(mlocsOut(i+1));
        else
            
            %If there is no local minumum between two peaks, so we should find one
            
            [~,mlocsOut(i+1)] = min(func(plocsIn(i):plocsIn(i+1))) ;

            mlocsOut(i+1) = mlocsOut(i+1) + plocsIn(i) -1;
            
            mAmpsOut(i+1) = func(mlocsOut(i+1));
    
        end
    end   
 end

 %For the case in which func starts with a maxima

if(plocsIn(1)<mlocsIn(1))

    %Check for consecative maxima

    for i = 1:length(plocsIn)-1
        if(((plocsIn(i) < mlocsIn(i)) && (mlocsIn(i) < plocsIn(i+1))))
            
            %Local minumum is between two maximums so it is valid.
            mlocsOut(i) = mlocsIn(i);
            mAmpsOut(i) = mlocsOut(i);
        else
            
            %If there is no local minumum between two peaks, so we should find one
            
            [~,mlocsOut(i)] = min(func(plocsIn(i):plocsIn(i+1)));

            mlocsOut(i) =  mlocsOut(i) + plocsIn(i) -1;
            mAmpsOut(i) = mlocsOut(i);
    
        end
    end
 end

end

