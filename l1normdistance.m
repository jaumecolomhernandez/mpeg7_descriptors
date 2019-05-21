function distance = l1normdistance(histogram_c,arr_comparar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
absolute_value=abs(histogram_c-arr_comparar);
distance=sum(absolute_value(1,:));
end

