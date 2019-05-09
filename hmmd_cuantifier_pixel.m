
function cuant = hmmd_cuantifier_pixel(hmmd, diff_ranges, sum_step, hue_step)

    sum_resol = [16,4,4,4,4];
    hue_resol = [1,4,8,8,8];

    hmmd_t = hmmd;

    diff_logical = hmmd_t(1) >= diff_ranges;
    diff_index = sum(diff_logical);

    % Index de sum
    sum_index = floor(hmmd_t(2)/sum_step(diff_index));

    % Index de hue
    hue_index = floor(hmmd_t(3)/hue_step(diff_index));

    % Càlcul del valor de cuantificació
    % El valor de cuantificació és calcula en funció de diff, sum i hue

    init = [0,16,32,64,96];

    cuant = init(diff_index) + (hue_index)*sum_resol(diff_index) + sum_index;  
end



