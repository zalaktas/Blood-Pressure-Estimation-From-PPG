function [mlocsOut,mAmpsOut] = newMin(mlocsIn,plocsIn,func)
% Corrects PPG signal peak and minumum detection where mLocsIn and PlocsIn
% are the perviosuly calculated locals minumums and maximums of PPG signal
% func.

% The nature of the PPG data does not allow two consecative peaks or two
% consecative minumums; i.e every minumum must be followed by a maximum and
% every maximum must be followed by a minumum. So look at the mLocsIn and 
% plocsIn values and if there are two consecatives, take the maximum or
% minumum of the function in that interval. And update the mLocs and Plocs
% values.

mlocsOut = mlocsIn;
mAmpsOut = func(mlocsOut);

%For the case in which func starts with a minima

if(mlocsIn(1)<plocsIn(1))
    %Check for consecative maxima
    for i = 1:min(length(mlocsIn)-1,length(plocsIn)-1)
        if((~((plocsIn(i) < mlocsOut(i+1)) && (mlocsOut(i+1) < plocsIn(i+1)))))
            
            %If there is no local minumum between two peaks, so we should find one
            
            [~,minIdx] = min(func(plocsIn(i):plocsIn(i+1))) ;

            mlocsOut =[mlocsOut(1:i) (minIdx + plocsIn(i) -1) mlocsOut(i+1:end)];
            
            mAmpsOut = func(mlocsOut);
    
        end
    end   
 end

 %For the case in which func starts with a maxima

if(plocsIn(1)<mlocsIn(1))

    %Check for consecative maxima

    for i = 1:min(length(mlocsIn),length(plocsIn)-1)
        if((~((plocsIn(i) < mlocsOut(i)) && (mlocsOut(i) < plocsIn(i+1)))))
            
            %If there is no local minumum between two peaks, so we should find one
            
            [~,minIdx] = min(func(plocsIn(i):plocsIn(i+1)));

            mlocsOut =[ mlocsOut(1:i-1) (minIdx + plocsIn(i) -1) mlocsOut(i:end)];
            mAmpsOut = func(mlocsOut);
    
        end
    end
 end

end
