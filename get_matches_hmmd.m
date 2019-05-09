function sorted_values = get_matches_hmmd(photo_c,error,DistParameter,bins,histograma)
%Troba les 8 fotos més semblants en funció del model que escollim
%   Paràmetres:
%   - photo_c: és la foto que volem comparar. Ha de ser una matriu 480*640*3
%   - error: (String) mètrica d'error que utilitzarem
%   Opcions = [chi2,bhattacharyya,intersection,kolmogorov,seuclidean,minkowski,
%              mahalanobis, euclidean, cityblock, chebychev, spearman, jaccard,
%              hamming, cosine]
%   - bins: nombre de bins per a fer l'histograma
%   - histograma: és la base de dades sobre on es comparen les fotos
%   a color o de nivell de gris
%   Retorna:
%   - sorted_values: array 8x2 amb les 8 fotos que són més semblants

%Declaració de valors i vectors 
n_files = size(histograma,1);
%Convertim la foto a escala de grisos i calculem histograma
photo_hmmd_c = rgb2hmmd(photo_c);
histogram_c = imhist(photo_hmmd_c,bins).';
%Calculem la distància a cada foto
value = zeros(n_files(1),2);
for i=1:n_files
    %Distància euclidiana sqrt(a^2+b^2), per cada valor MODIFICAR PER A ACCEPTAR ALTRES MÈTRIQUES
    arr_comparar = histograma(i,:);
    switch error
        case 'chi2'
            value(i,:) = [i, pdist2(histogram_c,arr_comparar,@chi_2)];
        case 'bhattacharyya'
            value(i,:) = [i, pdist2(histogram_c,arr_comparar,@bhattacharyya_metric)];
        case 'intersection'
            value(i,:) = [i, pdist2(histogram_c,arr_comparar,@mult_metric)];
        case 'kolmogorov'
            value(i,:) = [i,kstest2(arr_comparar,histogram_c)];
        case {'seuclidean','minkowski','mahalanobis'}
            value(i,:) = [i, pdist2(histogram_c,arr_comparar,error,DistParameter)];
        otherwise
            value(i,:) = [i, pdist2(histogram_c,arr_comparar,error)];
    end
end

%Ordenem els resultats i mostrem les 8 (l'original i les 8 proximes) primeres fotos
% També guardem els noms en un fitxer txt i el num de la foto en un array
sorted_values = sortrows(value,2);
sorted_values(1:8,1);

%Finalment retornem els 8 primers valors ordenats
end

