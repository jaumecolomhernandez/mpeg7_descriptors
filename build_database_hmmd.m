function db = build_database_hmmd(db_root_folder,files_in_folder,bins)
    %Crea la base de dades d'histogrames de cada foto en escala de grisos
    % Funcionament:
    % 1- Obra fitxer n
    % 2- Càlcula l'histograma
    % 3- El guarda en una matriu
    % 4- Repeteix els anterior passos fins que no queda cap fitxer
    % Parametres:
    %   - files_in_folder: struct amb tota la info dels fitxers de la base de
    %   dades
    %   - bins: nombre de bins per a construir l'histograma
    % Retorna:
    %   - db: matriu n_filesxbins amb l'histograma de cada foto

    %Declaració vars
    n_files = size(files_in_folder,1);
    folder_database = db_root_folder;

    fprintf('Creant base de dades\n');
    histogram_list_hmmd = zeros(n_files,bins);
    for i=1:n_files
        photo_name = files_in_folder(i).name;
        file_path = strcat(folder_database,'\',photo_name);
        photo = imread(file_path);
        photo_hmmd = rgb2hmmd(photo);
        histogram = imhist(photo_hmmd,bins);
        histogram_list_hmmd(i,:) = histogram.';
    end
    fprintf('Base de dades creada\n');
    db =  histogram_list_hmmd;
end

