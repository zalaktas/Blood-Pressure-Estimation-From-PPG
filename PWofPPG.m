function [fw50_amplitude] = PWofPPG(ppg_signal,percentage,Fs,t)

% Find peaks in the PPG signal
[peaks, peak_indices] = findpeaks(ppg_signal, 'MinPeakDistance', 0.6*Fs);  % Adjust MinPeakDistance as needed

% Calculate pulse width at 50% amplitude
fw50_amplitude = zeros(size(peaks));
for i = 1:length(peaks)
    % Find the index where the signal reaches half of the amplitude of the peak
    half_amplitude = peaks(i)*percentage;
    
    % Find the index before the peak where the signal crosses half amplitude
    index_before = find(ppg_signal(1:peak_indices(i)) < half_amplitude, 1, 'last');
    
    % Find the index after the peak where the signal crosses half amplitude
    index_after = find(ppg_signal(peak_indices(i):end) < half_amplitude, 1, 'first') + peak_indices(i) - 1;
    
    % Check if both indices are found
    if ~isempty(index_before) && ~isempty(index_after)
        % Calculate the pulse width at 50% amplitude
        fw50_amplitude(i) = t(index_after) - t(index_before);
        
        % Plot the width at percentage of amplitude
%         figure;
%         plot(t, ppg_signal, 'b', t(peak_indices), peaks, 'ro');
%         hold on;
%         plot([t(index_before), t(index_after)], [peaks(i)*percentage, peaks(i)*percentage], 'g--');
%         title(['PPG Signal with Peak and Width at percentage Amplitude for Peak ' num2str(i)]);
%         xlabel('Time (s)');
%         ylabel('Amplitude');
%         legend('PPG Signal', 'Peak', 'Width at percentage Amplitude');
    else
%         % Display a message if one of the indices is not found
%         disp(['Skipping peak ' num2str(i) ' - Unable to find both indices.']);
    end
end

% % Display the pulse width at percentage of amplitude
% disp('Pulse Width at percentage Amplitude:');
% disp(fw50_amplitude);

end

