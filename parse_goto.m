function [] = parse_goto()
    
    function [n, i] = get_next_number(str, i)
        n = str2num(cell2mat(str(i)));
        n_size = size(n);
        while(n_size(1) == 0)
            i = i + 1;
            n = str2num(cell2mat(str(i)));
            n_size = size(n);
        end
    end

    directory = dir("./goto");
    for file_idx = 1:length(directory)
        file_name = directory(file_idx).name;
        if file_name ~= "." && file_name ~= ".."
            file_path = strcat("./goto/", directory(file_idx).name);
            fid = fopen(file_path);
            
            % nodes
            nodes_line = split(fgetl(fid), "=");
            nodes_line = split(nodes_line(2), " ");
            nodes = str2num(cell2mat(nodes_line(2)));
            
            % skip unused lines
            fgetl(fid);
            fgetl(fid);
            
            source_line = split(fgetl(fid), " ");
            sinks_line = split(fgetl(fid), " ");
            
            [n, i] = get_next_number(source_line, 1);
            source_idx = n;
            [n, i] = get_next_number(source_line, i + 1);
            source_val = n;
            
            [n, i] = get_next_number(sinks_line, 1);
            sink_idx = n;
            [n, i] = get_next_number(sinks_line, i + 1);
            sink_val = n;
            
            b = zeros(nodes, 1);
            b(source_idx) = source_val;
            b(sink_idx) = sink_val;
            
            file_s = split(directory(file_idx).name, "_");
            edges = nodes * str2num(cell2mat(file_s(2)));
            
            % read arcs
            D = [];
            S = [];
            T = [];
            line = fgetl(fid);
            for i = 1:edges
                edge_line = split(line, " ");
                
                % from
                [from, k] = get_next_number(edge_line, 1);
                S = [S; from];
                
                % to
                [to, k] = get_next_number(edge_line, k + 1);
                T = [T; to];
                
                % skip 0
                [~, k] = get_next_number(edge_line, k + 1);
                
                % capacity
                [capacity, k] = get_next_number(edge_line, k + 1);
                D = [D; capacity];
                
                % cost
                i = k + 1;
                [cost, k] = get_next_number(edge_line, k + 1);
                
                line = fgetl(fid);
            end
            
            % create the graph
            G = digraph(S, T, 'omitselfloops');
            
            % save result
            instance_str = split(file_s(3), ".");
            path_result = "./graphs/goto_" + nodes + "_" +  edges + "_" + instance_str(1);
            save(path_result, "G", "D", "b");
            
            fclose(fid);
        end
    end
end