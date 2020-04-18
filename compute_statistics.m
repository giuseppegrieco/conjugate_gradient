function [] = compute_statistics()

d = dir('./data');

f_g = fopen('./output_gmres.txt','w');

f = fopen('./output_normal.txt','w');

for i = 1:length(d) %per ogni dimensioni del grafo
    directory = d(i).name;
    variance_time_alg = zeros(8,1);
    avg_execution_time_alg = zeros(8,1);
    avg_step_time = zeros(8,1);
    avg_num_iterations = zeros(8,1);
    avg_executiom_time_prec = zeros(8,1);
    min_time_directory = strings;
    min_time_value = zeros(8,1);
    max_time_directory = strings;
    max_time_value = zeros(8,1);
    variance_step_time = zeros(8,1);
    variance_num_iterations = zeros(8,1);
    for h = 1:length(min_time_value)
    min_time_value(h) = realmax;
    max_time_value(h) = realmin;
    end
    
    if directory(1) ~= '.'
        vertex = cell2mat(extractBetween(directory,"vertex_","_arcs"));
        edges = cell2mat(extractBetween(directory,"_arcs_","_dval_inf_"));
        d_val_inf = cell2mat(extractBetween(directory,"_dval_inf_","_dval_sup_"));
       
        vertex = str2num(vertex);
        edges = str2num(edges);
        d_val_inf = str2num(d_val_inf);
       

        for j = 0:7 % per ogni precondizionatore
            path = strcat('./data/',directory,'/results/');
            files = dir(strcat(path,'Results_prec_',num2str(j),'*'));
            count = 0;
            
            all_time_algorithm = [];
            all_time_preconditioner = [];
            all_time_iter = [];
            iters = [];
            total_iterations = 0;
            count_divergence = 0;
            for k = 1:length(files) % per ogni esempio di un precondizionatore 
                count = count + 1;
                file = files(k).name;
                
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
                        if time_alg < min_time_value(j + 1)
                            min_time_value(j + 1) = time_alg; 
                            min_time_directory(j+1) = file;
                        end

                        if time_alg > max_time_value(j+1)
                            max_time_value(j+1) = time_alg;
                            max_time_directory(j+1) = file;
                        end
                    end
                        
                end
            end
            
            avg_num_iterations(j + 1) = mean(iters);
            variance_num_iterations(j + 1) = var(iters);
            avg_execution_time_alg(j + 1) = mean(all_time_algorithm);
            variance_time_alg(j +1 ) = var(all_time_algorithm);
            avg_executiom_time_prec(j+1) = mean(all_time_preconditioner);
            avg_step_time(j + 1) = mean(all_time_iter);
            variance_step_time(j + 1) = var(all_time_iter);
            num_of_divergences(j + 1) = count_divergence;
            
        end
        
        save(strcat(path,'statistics'),'avg_num_iterations','avg_execution_time_alg', ...
        'variance_time_alg','avg_step_time','min_time_directory','max_time_directory',...
        'avg_executiom_time_prec','variance_step_time','variance_num_iterations','num_of_divergences')
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
        d_range = -1;
        if d_val_inf == 1
            d_range = 2; 
        else
            d_range = 1;
        end
       
        fprintf(f,"\\multirow{4}{*}{$G_{%d, %d\\%%, %d}$} & No & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", vertex, density, d_range, avg_execution_time_alg(4),variance_time_alg(4) , avg_step_time(4), variance_step_time(4),  avg_num_iterations(4), variance_num_iterations(4),num_of_divergences(4));
        fprintf(f,"& Jacobi & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6}  \n", avg_execution_time_alg(1),variance_time_alg(1) , avg_step_time(1), variance_step_time(1),  avg_num_iterations(1), variance_num_iterations(1),num_of_divergences(1));
        fprintf(f,"& ILU & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", avg_execution_time_alg(2),variance_time_alg(2) , avg_step_time(2), variance_step_time(2),  avg_num_iterations(2), variance_num_iterations(2),num_of_divergences(2));
        fprintf(f,"& ICHOL & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\hline \n", avg_execution_time_alg(4),variance_time_alg(4) , avg_step_time(3), variance_step_time(3),  avg_num_iterations(3), variance_num_iterations(3),num_of_divergences(3));
        
        fprintf(f_g,"\\multirow{4}{*}{$G_{%d, %d\\%%, %d}$} & No & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", vertex, density, d_range, avg_execution_time_alg(8),variance_time_alg(8) , avg_step_time(8), variance_step_time(8),  avg_num_iterations(8), variance_num_iterations(8),num_of_divergences(8));
        fprintf(f_g,"& Jacobi & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d\\\\ \\cline{2-6} \n", avg_execution_time_alg(5),variance_time_alg(5) , avg_step_time(5), variance_step_time(5),  avg_num_iterations(5), variance_num_iterations(5),num_of_divergences(5));
        fprintf(f_g,"& ILU & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\cline{2-6} \n", avg_execution_time_alg(6),variance_time_alg(6) , avg_step_time(6), variance_step_time(6),  avg_num_iterations(6), variance_num_iterations(6),num_of_divergences(6));
        fprintf(f_g,"& ICHOL & (%.4f, %.4f) & (%.4f, %.4f) & (%.4f, %.4f) & %d \\\\ \\hline \n", avg_execution_time_alg(7),variance_time_alg(7) , avg_step_time(7), variance_step_time(7),  avg_num_iterations(7), variance_num_iterations(7),num_of_divergences(7));
        
        
    
    
    
    
        %disp('avg_num_iterations')
        %disp(avg_num_iterations)

        %disp('avg_execution_time_alg')
        %disp(avg_execution_time_alg)

        %disp('variance_time_alg')
        %disp(variance_time_alg)

        %disp('avg_executiom_time_prec')
        %disp(avg_executiom_time_prec)

        %disp('avg_step_time')
        %disp(avg_step_time)

        %disp('min_directories')
        %disp(min_time_directory)

        %disp('max_directories')
        %disp(max_time_directory)
    end
    
    
end







