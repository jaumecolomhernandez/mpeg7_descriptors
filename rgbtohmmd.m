function photo = rgbtohmmd(path)
    % Càrrega de la foto
    rgb_photo = imread(path);

    % Conversió a hmmd coma flotant
    calculate = 1;
    if calculate == 1
        hmmd_matrix = rgb_hmmd(rgb_photo);  
    end

    % Creació dels rangs de cuantificació
    % Per a cuantificar les dades s'utilitza les taules de
    % cuantificació del paper x pag y.

    cuant_table = []; 

    sum_resol = [32,8,4,4,4];
    hue_resol = [1,4,16,16,16];

    sum_resol = [16,4,4,4,4];
    hue_resol = [1,4,8,8,8];

    % Càlcul del rangs de diff
    % Els rangs de diff estàn definits pel standard.
    diff_ranges = [0,6,20,60,110];

    % Càlcul dels rangs de sum
    % Per a calcular els rangs de sum, assumim que l'espai de color
    % utilitzant hue,diff i sum es piramidal. 
    % L'objectiu es calcular l'altura de cada index de creació dels rangs, i
    % dividir pel nombre de segments. Fent això aconseguim el step de 
    % cada rang. Ho deixem així perqué ens facilita fer els càlculs.

    % Calculem l'angle d'inclinació de la piràmide.
    alfa = atan2(128,255);
    % Càlcul de les distàncies desde la punta
    dist = 255 - diff_ranges;
    % Càlcul de les altures
    heights = dist*tan(alfa)*2;
    % Càlcul dels valors de les divisions per cada altura
    sum_step = heights./sum_resol;

    % Càlcul dels rangs de hue
    % Com que hue es un float, per a designar els rangs definim
    % un array amb el primer valor del rang. El rang va desde el valor n
    % fins al n+1. Ex: Rang n [hue_rangs(n),hue_rangs(n+1))
    hue_step = 360.0./hue_resol;

    % Pixel de treball per a cuantificar
    % l'estructura és [diff, sum, hue]

    photo = hmmd_cuantifier_photo(hmmd_matrix,diff_ranges, sum_step, hue_step);

    %squeeze(hmmd(:,:,5))'
end