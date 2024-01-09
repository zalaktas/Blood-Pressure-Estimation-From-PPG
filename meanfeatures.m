function [meanfeature] = meanfeatures(feature)
num_subgroups = numel(feature) / 3;
meanfeature = zeros(1,num_subgroups);

for i = 1:num_subgroups
    start_index = (i - 1) * 3 + 1;
    end_index = i * 3;
    subgroup_data = feature(start_index:end_index);
    meanfeature(i) = mean(subgroup_data);
end
end

