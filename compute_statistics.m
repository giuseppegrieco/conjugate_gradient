function [] = compute_statistics(data_path,output_gmres_path,output_cg_path)

data_directory = dir(strcat(data_path));

f_g = fopen(output_gmres_path,'w');

f = fopen(output_cg_path,'w');

for index_graph_configuration = 1:length(data_directory) %per ogni dimensioni del grafo
    directory_graph_configuration = data_directory(index_graph_configuration).name;
    variance_time_alg = zeros(8,1);
    avg_execution_time_alg = zeros(8,1);
    avg_executiom_time_prec = zeros(8,1);
    avg_step_time = zeros(8,1);
    variance_step_time = zeros(8,1);
    avg_num_iterations = zeros(8,1);
    variance_num_iterations = zeros(8,1);
    num_of_divergences = zeros(8,1); 
    
    if directory_graph_configuration(1) ~= '.'
        vertex = cell2mat(extractBetween(directory_graph_configuration,"vertex_","_arcs"));
        vertex = str2num(vertex);
        
        edges = cell2mat(extractBetween(directory_graph_configuration,"_arcs_","_dval_inf_"));
        edges = str2num(edges);
        
        d_val_inf = cell2mat(extractBetween(directory_graph_configuration,"_dval_inf_","_dval_sup_"));
        d_val_inf = str2num(d_val_inf);
       

        for preconditioner = 0:7 % per ogni precondizionatore
            path = strcat(data_path,'/',directory_graph_configuration,'/results/');
            files = dir(strcat(path,'Results_prec_',num2str(preconditioner),'*'));
            
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
        density = -1;
        switch edges
            case 50000
                density = 10;
            case 292000
                density = 50;
            case 680000
                density = 90;
            case 12500
                density = 10;
            case 73000
                density = 50;
            case 170000
                density = 90;
            case 250000
                density = 1;
            case 500000
                density = 1;
            otherwise
                display(class(edges))
        end
        
        if d_val_inf == 1
            d_range = 2; 
        else
            d_range = 1;
        end
        
        fprintf(f,"\\multirow{4}{*}{$G_{%d, %d\\%%, %d}$} & No & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", vertex, density, d_range, avg_execution_time_alg(4),variance_time_alg(4) , avg_step_time(4), variance_step_time(4),  avg_num_iterations(4), variance_num_iterations(4),num_of_divergences(4));
        fprintf(f,"& Jacobi & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6}  \n", avg_execution_time_alg(1),variance_time_alg(1) , avg_step_time(1), variance_step_time(1),  avg_num_iterations(1), variance_num_iterations(1),num_of_divergences(1));
        fprintf(f,"& ILU & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", avg_execution_time_alg(2),variance_time_alg(2) , avg_step_time(2), variance_step_time(2),  avg_num_iterations(2), variance_num_iterations(2),num_of_divergences(2));
        fprintf(f,"& ICHOL & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\hline \n", avg_execution_time_alg(3),variance_time_alg(3) , avg_step_time(3), variance_step_time(3),  avg_num_iterations(3), variance_num_iterations(3),num_of_divergences(3));
        
        fprintf(f_g,"\\multirow{4}{*}{$G_{%d, %d\\%%, %d}$} & No & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", vertex, density, d_range, avg_execution_time_alg(8),variance_time_alg(8) , avg_step_time(8), variance_step_time(8),  avg_num_iterations(8), variance_num_iterations(8),num_of_divergences(8));
        fprintf(f_g,"& Jacobi & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d\\\\ \\cline{2-6} \n", avg_execution_time_alg(5),variance_time_alg(5) , avg_step_time(5), variance_step_time(5),  avg_num_iterations(5), variance_num_iterations(5),num_of_divergences(5));
        fprintf(f_g,"& ILU & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", avg_execution_time_alg(6),variance_time_alg(6) , avg_step_time(6), variance_step_time(6),  avg_num_iterations(6), variance_num_iterations(6),num_of_divergences(6));
        fprintf(f_g,"& ICHOL & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\hline \n", avg_execution_time_alg(7),variance_time_alg(7) , avg_step_time(7), variance_step_time(7),  avg_num_iterations(7), variance_num_iterations(7),num_of_divergences(7));
        
    end
    
    
end







