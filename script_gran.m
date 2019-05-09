%SCRIPT PRINCIPAL
% Descripció del procés:
% 1- Calcular base de dades
%   1.1- Obrir fitxers
%   1.2- Calcular histogrames
% 2- Trobem els matches
%   2.1- Calcular histograma de la foto usuari
%   2.2- Calcular distància foto usuari amb la base de dades
%   2.3- Ordenem i ens quedem els 8 primers
% 3- Mostrar imatges i exportar fitxer
% 4- Calcular mètriques

%Declaració de variables
folder_database = 'path';  %Base de dades d'imatges
files_in_folder = dir(folder_database);     %Obtenció dels fitxers de la carpeta
files_in_folder = files_in_folder(3:end);   %Correció dels punts, eliminem els dos primers (. ..)
precision_res = zeros(10,1);                 %Vector de resultats de precisió global
recall_res = zeros(10,1);                    %Vector de resultats de recall global
file = fopen('.\exports\output.txt','w');             %Fitxer d'exportar resultats
count = 0;                                  %Contador de fotos comparades (Per a després normalitzar)

n_files = size(files_in_folder);    %Variable nombre de fitxers en la carpeta
foto_s = [];                 %Nombre de fitxers a comparar (és pot ficar menys per a anar més ràpid)


%Llegim fitxer de input
file_p = fopen('input.txt','r');
photo = fgetl(file_p);
while ischar(photo)
    number = str2num(photo(8:12));
    fprintf('%d\n', number);
    foto_s(end+1) = number+1;
    photo = fgetl(file_p);
end

%Paràmetres del model
bins = 256;  %Nombre de bins a utilitzar
error = 'euclidean'; %Mètrica d'error a utilitzar
plot_matches = false;   %Boolean per a mostrar els matches
plot_results = true;    %Boolean per a mostrar resultats


%1- CÀLCUL DE LA BASE DE DADES
%Iterem sobre cada imatge i la convertim a escala de grisos calculem
%l'histograma i el guardem en una matriu.
%Comprovem si la base de dades existeix per a crear-la
if ~ exist('histogram_list_hmmd', 'var')
    histogram_list_hmmd = build_database_hmmd(folder_database,...
                                              files_in_folder,...
                                              bins);
else
    fprintf('Base de dades trobada\n');
end



for i=foto_s
    %Obrim el fitxer usuari
    photo_name = files_in_folder(i).name;
    photo_c_path = strcat(folder_database,'\',photo_name);
    photo_c = imread(photo_c_path);
    
    DistParameter = 2;
    
    %2- TROBEM ELS MATCHES
   
    sorted_values = get_matches_hmmd(photo_c,...
                    error,...
                    DistParameter,...
                    bins,...
                    histogram_list_hmmd);

    
    %3- EXPORTEM RESULTATS I CREEM EL PLOT DELS MATCHES
    
    %Plot dels matches
    if (plot_matches)
        %TODO: MILLORAR EL PLOT FICAR TITOLS I TAL
        figure
        %Set title and axis labels
        title('Matches results')
    end
    
    %Export dels resultats al fitxer
    arr_results = zeros(10,1);
    fprintf(file, 'Retrieved list for query image %s\n', photo_name);
    for i=1:10
        nom = files_in_folder(sorted_values(i,1)).name;
        fprintf(file, '%s\n', nom);
        if(plot_matches)
            for j=1:9
                subplot(3,3,i),imshow(strcat(folder_database,'\',nom));
            end
        end
        arr_results(i) = str2num(nom(:,8:13)); 
    end
 
    
    fprintf(file,'\n');
    
    fprintf('Dades exportades fitxer: %s\n',photo_name);
    
    %4- VALIDACIÓ I CÀLCUL DE MÈTRIQUES
    % - Procés:
    % - Mirem el num de la foto usuari
    % - Mirem el modul 4 de la foto usuari
    % - Fem servir una LUT per a trobar les fotos que corresponen
    % - Mirem quants d'aquests valors estan en les primeres 8 fotos
    num_usuari = arr_results(1);
    mod_usuari = mod(num_usuari,4);
    %Look up table per a calcular els nombres correctes
    lut = [0,1,2,3;-1,0,1,2;-2,-1,0,1;-3,-2,-1,0];
    nums_correctes = num_usuari + lut(mod_usuari+1,:);  %Sumem 1 perqué els vectors comencen al 1 i el mòdul no
    
    %Declaració de vectors
    precision = zeros(10,1);
    recall = zeros(10,1);
    for i = 1:10
        %Agafan cada cop una foto més, calculem recall i precision
        precision(i) = sum(ismember(arr_results(1:i), nums_correctes))/double(i);
        recall(i) = sum(ismember(arr_results(1:i), nums_correctes))/4.0;
    end
    
    %Contador per a calcular la mitjana
    count = count + 1;
    
    %Sumem els resultats. Per a després calcular la mitjana de tots els
    %resultats
    precision_res = precision + precision_res;
    recall_res = recall + recall_res;
end

%Càlcul de la precisió i recall final
precision = precision_res./double(count);
recall = recall_res./double(count);

f = 2*(precision.*recall)./(precision+recall);

%Precision and recall plot
if (plot_results)
    figure
    plot(recall,precision);

    %Set title and axis labels
    title('Precision Recall Plot')
    xlabel('Recall');
    ylabel('Precision');

    %Set axis values
    xlim([0,1]);
    ylim([0,1]);

    %grid on
    grid on;
end

f = max(2*(precision.*recall)./(precision+recall))
