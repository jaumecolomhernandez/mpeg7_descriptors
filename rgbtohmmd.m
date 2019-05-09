function photo = rgbtohmmd(path)
    % C�rrega de la foto
    rgb_photo = imread(path);

    % Conversi� a hmmd coma flotant
    calculate = 1;
    if calculate == 1
        hmmd_matrix = rgb_hmmd(rgb_photo);  
    end

    % Creaci� dels rangs de cuantificaci�
    % Per a cuantificar les dades s'utilitza les taules de
    % cuantificaci� del paper x pag y.

    cuant_table = []; 

    sum_resol = [32,8,4,4,4];
    hue_resol = [1,4,16,16,16];

    sum_resol = [16,4,4,4,4];
    hue_resol = [1,4,8,8,8];

    % C�lcul del rangs de diff
    % Els rangs de diff est�n definits pel standard.
    diff_ranges = [0,6,20,60,110];

    % C�lcul dels rangs de sum
    % Per a calcular els rangs de sum, assumim que l'espai de color
    % utilitzant hue,diff i sum es piramidal. 
    % L'objectiu es calcular l'altura de cada index de creaci� dels rangs, i
    % dividir pel nombre de segments. Fent aix� aconseguim el step de 
    % cada rang. Ho deixem aix� perqu� ens facilita fer els c�lculs.

    % Calculem l'angle d'inclinaci� de la pir�mide.
    alfa = atan2(128,255);
    % C�lcul de les dist�ncies desde la punta
    dist = 255 - diff_ranges;
    % C�lcul de les altures
    heights = dist*tan(alfa)*2;
    % C�lcul dels valors de les divisions per cada altura
    sum_step = heights./sum_resol;

    % C�lcul dels rangs de hue
    % Com que hue es un float, per a designar els rangs definim
    % un array amb el primer valor del rang. El rang va desde el valor n
    % fins al n+1. Ex: Rang n [hue_rangs(n),hue_rangs(n+1))
    hue_step = 360.0./hue_resol;

    % Pixel de treball per a cuantificar
    % l'estructura �s [diff, sum, hue]

    photo = hmmd_cuantifier_photo(hmmd_matrix,diff_ranges, sum_step, hue_step);

    %squeeze(hmmd(:,:,5))'
end