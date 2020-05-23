function [] = parse_gridgen()
    directory = dir("./gridgen");
    for file_idx = 1:length(directory)
        file_name = directory(file_idx).name;
        if file_name ~= "." && file_name ~= ".."
            file_path = strcat("./gridgen/", directory(file_idx).name);
            fid = fopen(file_path);
            
            % skip first 2 line
            fgetl(fid);
            fgetl(fid);
            
            % nodes
            nodes_line = split(fgetl(fid), " ");
            nodes = str2num(cell2mat(nodes_line(3)));
            
            % skip grid size
            fgetl(fid);
            
            % sources and sinks
            sources_and_sinks_line = split(fgetl(fid), " ");
            sources = str2num(cell2mat(sources_and_sinks_line(3)));
            sinks = str2num(cell2mat(sources_and_sinks_line(5)));
            
            % skip unused info
            for i = 1:5
                fgetl(fid);
            end
            
            % sources/sinks
            b = zeros(nodes, 1);
            
            for i = 1:(sources+sinks)
                 source_and_sink_line = split(fgetl(fid), " ");
                 idx = str2num(cell2mat(source_and_sink_line(2)));
                 val = str2num(cell2mat(source_and_sink_line(3)));
                 b(idx) = val;
            end
            
            file_s = split(directory(file_idx).name, "_");
            edges = nodes * str2num(cell2mat(file_s(2)));
            
            % read arcs
            D = [];
            S = [];
            T = [];
            for i = 1:edges
                edge_line = split(fgetl(fid), " ");
                from = str2num(cell2mat(edge_line(2)));
                S = [S; from];
                to = str2num(cell2mat(edge_line(3)));
                T = [T; to];
                capacity = str2num(cell2mat(edge_line(5)));
                D = [D; capacity];
                cost = str2num(cell2mat(edge_line(6)));
            end
            
            % create the graph
            G = digraph(S, T, 'omitselfloops');
            
            % save result
            instance_str = split(file_s(3), ".");
            path_result = "./graphs/gridgen_" + nodes + "_" +  edges + "_" + instance_str(1);
            save(path_result, "G", "D", 'b');
            
            fclose(fid);
        end
    end
end