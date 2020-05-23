function [] = create_data(min_b, max_b)

    function [b] = gen_b(vertex, min_b, max_b)
        b_hat = unifrnd(min_b, max_b, vertex, 1);
        kr = ones(vertex, 1);
        o_proj = ((b_hat' * kr) / norm(kr)^2) * kr;
        b = b_hat - o_proj; 
    end

    directory = dir("./graphs");
    for file_idx = 1:length(directory)
        file_name = directory(file_idx).name;
        if file_name ~= "." && file_name ~= ".."
            file_path = strcat("./graphs/", directory(file_idx).name);
            
            file_name_s = split(file_name, "_");
            vertex = str2num(cell2mat(file_name_s(2)));
            edges = str2num(cell2mat(file_name_s(3)));
            istance_s = split(cell2mat(file_name_s(4)), ".");
            istance = str2num(cell2mat(istance_s(1)));
            
            load(file_path, 'G', 'D', 'b');
            
            E = incidence(G);
            inverse_diagonal = 1./D;
            ID = spdiags(inverse_diagonal(:), 0, edges, edges);
            A = E*ID*E';

            out_name_s = split(file_name, ".");
            out_name = out_name_s(1);
            path_result = "./data/" + out_name;
            save(path_result, 'A', 'b');
        end
    end
end