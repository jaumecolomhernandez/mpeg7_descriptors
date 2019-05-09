function hmmd_cuant = hmmd_cuantifier_photo(hmmd_matrix, diff_ranges, sum_step, hue_step)
%HMMD_CUANTIFIER_PHOTO Summary of this function goes here
%   Detailed explanation goes here
    tamany = size(hmmd_matrix);
    hmmd_cuant = zeros(tamany(1),tamany(2));

    for i=(1:tamany(1))
        for j=(1:tamany(2))
            hmmd_t = reshape(hmmd_matrix(i,j,:),[],1)';
            hmmd_cuant(i,j) = hmmd_cuantifier_pixel(hmmd_t, diff_ranges, sum_step, hue_step);
        end
    end
end

