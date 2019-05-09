function cuant = hmmd_cuantifier_pixel(hmmd, diff_ranges, sum_step, hue_step)
%HMMD_CUANTIFIER_PIXEL Realitza la cuantificaci� d'un pixel en format HMMD
%   Passat un pixel el quantifica en el nombre de bins indicat.
%   TODO: Generalitzar a quasevol nombre de bins

    %Definici� dels parametres de quantificaci�
    sum_resol = [16,4,4,4,4];
    hue_resol = [1,4,8,8,8];
    
    %Assignaci� de la variable
    hmmd_t = hmmd;

    % C�lculem en quina posici� de l'eix diff li toca
    diff_logical = hmmd_t(1) >= diff_ranges;
    diff_index = sum(diff_logical);

    % Calculem en quin bucket de l'eix sum li toca
    sum_index = floor(hmmd_t(2)/sum_step(diff_index));

    % Calculem en quin bucket de hue li toca
    hue_index = floor(hmmd_t(3)/hue_step(diff_index));

    % C�lcul del valor de cuantificaci�
    % El valor de cuantificaci� �s calcula en funci� de diff, sum i hue

    % Par�metres init (calcular din�micament)
    init = [0,16,32,64,96];
    
    
    cuant = init(diff_index) + (hue_index)*sum_resol(diff_index) + sum_index;  
end



