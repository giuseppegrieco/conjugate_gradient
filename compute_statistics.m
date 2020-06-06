function [] = compute_statistics(data_path,output_cg_path)

    all_vertexes = [1024,4096,16384];
    all_edges = [[8192,32768,65536];[32768,262144,1048576];[131072,1048576,-1]];

    f = fopen(output_cg_path,'w');

    i = 1;
    for vertex = all_vertexes
        edges = all_edges(i,:);
        for edge = edges
            if(edge ~= -1)
                all_time_algorithm = [];
                all_time_preconditioner = [];
                all_iters = [];
                for preconditioner = 0:5
                    time_algorithm = 0;
                    time_preconditioner = 0;
                    iters = 0;
                    for iter = 1:5  
                        file = strcat(data_path,'goto_',num2str(vertex),'_',num2str(edge),'_',num2str(iter),'_prec_',num2str(preconditioner));
                        load(file);

                        [~,num_iter] = min(residuals);

                        iters = iters + num_iter;
                        time_algorithm = time_algorithm + time_alg;
                        time_preconditioner = time_preconditioner + time_prec;

                    end

                    all_time_algorithm(preconditioner + 1) = time_algorithm / 5;
                    all_time_preconditioner(preconditioner + 1) = time_preconditioner / 5;
                    all_iters(preconditioner + 1) = iters / 5; 

                end

                fprintf(f,'{$goto-%.4f-%.4f$} & %.4f & %.4f & %.4f & %.4f & %.4f & %.4f \\ \hline',log2(vertex),edge/vertex,all_time_algorithm(3),all_iters(3),all_time_algorithm(1),all_iters(1),all_time_algorithm(2),all_iters(2));
            end
        end
    end
end


%{

for index_graph_configuration = 1:length(data_directory) %per ogni dimensioni del grafo
    directory_graph_configuration = data_directory(index_graph_configuration).name;
    variance_time_alg = zeros(6,1);
    avg_execution_time_alg = zeros(6,1);
    avg_executiom_time_prec = zeros(6,1);
    avg_step_time = zeros(6,1);
    variance_step_time = zeros(6,1);
    avg_num_iterations = zeros(6,1);
    variance_num_iterations = zeros(6,1);
    num_of_divergences = zeros(6,1); 
    
    if directory_graph_configuration(1) ~= '.'
        split = split(directory_graph_configuration,"_");
        
        vertex = cell2mat(split(2));
        vertex = str2num(vertex);
        
        edges = cell2mat(split(3));
        edges = str2num(edges);
        
        example_number = cell2mat(split(4));
        example_number = str2num(example_number);
       

        for preconditioner = 0:5 % per ogni precondizionatore
            path = strcat(data_path);
            files = dir(strcat(path,'goto_','*','_prec_',num2str(preconditioner),'*'));
            
            all_time_algorithm = [];
            all_time_preconditioner = [];
            all_time_iter = [];
            iters = [];
            total_iterations = 0;
            count_divergence = 0;
            for index_example = 1:length(files) % per ogni esempio di un precondizionatore 
                file = files(index_example).name;
                
                if file(1) ~= '.'
                    load(strcat(path,file));
                    [~,num_iter] = min(residuals);
                    
                    if num_iter ~= length(residuals) && ((length(residuals) - num_iter) > 1)
                        count_divergence = count_divergence + 1;
                    else
                        total_iterations = total_iterations + num_iter;
                        iters = [iters,num_iter];
                        all_time_iter = [all_time_iter, time_alg/length(residuals)];
                        all_time_algorithm = [all_time_algorithm,time_alg];
                        all_time_preconditioner = [all_time_preconditioner,time_prec];
                    end
                        
                end
            end
            
            avg_num_iterations(preconditioner + 1) = mean(iters);
            variance_num_iterations(preconditioner + 1) = var(iters);
            avg_execution_time_alg(preconditioner + 1) = mean(all_time_algorithm);
            variance_time_alg(preconditioner +1 ) = var(all_time_algorithm);
            avg_executiom_time_prec(preconditioner+1) = mean(all_time_preconditioner);
            avg_step_time(preconditioner + 1) = mean(all_time_iter);
            variance_step_time(preconditioner + 1) = var(all_time_iter);
            num_of_divergences(preconditioner + 1) = count_divergence;
            
        end
        
        save(strcat(path,'statistics'),'avg_num_iterations','avg_execution_time_alg', ...
        'variance_time_alg','avg_step_time','avg_executiom_time_prec', ...
        'variance_step_time','variance_num_iterations','num_of_divergences')
        density = vertex / edges;
        
        fprintf(f,"\\multirow{4}{*}{$G_{%d, %d\\%%, %d}$} & No & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", vertex, density, d_range, avg_execution_time_alg(3),variance_time_alg(3) , avg_step_time(3), variance_step_time(3),  avg_num_iterations(3), variance_num_iterations(3),num_of_divergences(3));
        fprintf(f,"& Jacobi & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6}  \n", avg_execution_time_alg(1),variance_time_alg(1) , avg_step_time(1), variance_step_time(1),  avg_num_iterations(1), variance_num_iterations(1),num_of_divergences(1));
        fprintf(f,"& ICHOL & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\hline \n", avg_execution_time_alg(2),variance_time_alg(2) , avg_step_time(2), variance_step_time(2),  avg_num_iterations(2), variance_num_iterations(2),num_of_divergences(2));
        
        fprintf(f_g,"\\multirow{4}{*}{$G_{%d, %d\\%%, %d}$} & No & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", vertex, density, d_range, avg_execution_time_alg(6),variance_time_alg(6) , avg_step_time(6), variance_step_time(6),  avg_num_iterations(6), variance_num_iterations(6),num_of_divergences(6));
        fprintf(f_g,"& Jacobi & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d\\\\ \\cline{2-6} \n", avg_execution_time_alg(4),variance_time_alg(4) , avg_step_time(4), variance_step_time(4),  avg_num_iterations(4), variance_num_iterations(4),num_of_divergences(4));
        fprintf(f_g,"& ICHOL & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\hline \n", avg_execution_time_alg(5),variance_time_alg(5) , avg_step_time(5), variance_step_time(5),  avg_num_iterations(5), variance_num_iterations(5),num_of_divergences(5));
        
    end
    
    


%}



