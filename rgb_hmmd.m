function hmm_matrix = rgb_hmmd(rgb_photo)
%RGB_HMMD Realitza la conversi� d'una imatge RGB a imatge HMMD coma flotant
%   Completar explicaci�

    tamany = size(rgb_photo);
    hmm_matrix = zeros(tamany(1),tamany(2),3);
    
    for i=1:tamany(1)
        for j=1:tamany(2)
            % Convert data to array
            rgb_p = reshape(rgb_photo(i,j,:),[],1)';
            
            % max calculation
            max_v = max(rgb_p);           
            % min calculation
            min_v = min(rgb_p);         
            % diff calculation
            hmm_matrix(i,j,1) = max_v - min_v;        
            % sum calculation
            hmm_matrix(i,j,2) = (max_v + min_v)/2;    
            % hue calculation (PASSAR A IMPERATIU)
            y = double(rgb_p(2)-rgb_p(3))*sqrt(3);
            x = 2*double(rgb_p(1))- double(rgb_p(2)+rgb_p(3));
            hmm_matrix(i,j,3) = (atan2(y,x)+ pi)*360/(2*pi);
            %hue
            %hmmd_rep = squeeze(hmm_matrix(i,j,:));
        end
    end
end

