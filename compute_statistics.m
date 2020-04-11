function [] = compute_statistics()

d = dir('./data');





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
    
    for h = 1:length(min_time_value)
    min_time_value(h) = realmax;
    max_time_value(h) = realmin;
    end
    
    if directory(1) ~= '.'
        for j = 0:7 % per ogni precondizionatore
            path = strcat('./data/',directory,'/results/');
            files = dir(strcat(path,'Results_prec_',num2str(j),'*'));
            count = 0;
            all_time_algorithm = [];
            all_time_preconditioner = [];
            iters = [];
            total_iterations = 0;
            for k = 1:length(files) % per ogni esempio di un precondizionatore 
                count = count + 1;
                file = files(k).name;
                if file(1) ~= '.'
                    load(strcat(path,file));
                    
                    [~,num_iter] = min(residuals);
                    total_iterations = total_iterations + num_iter;
                    iters = [iters,num_iter];
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
            
            avg_num_iterations(j + 1) = mean(iters);
            avg_execution_time_alg(j + 1) = mean(all_time_algorithm);
            variance_time_alg(j +1 ) = var(all_time_algorithm);
            avg_executiom_time_prec(j+1) = mean(all_time_preconditioner);
            avg_step_time(j + 1) = sum(all_time_algorithm) / total_iterations;
            
        end
        
        save(strcat(path,'statistics'),'avg_num_iterations','avg_execution_time_alg', ...
        'variance_time_alg','avg_step_time','min_time_directory','max_time_directory','avg_executiom_time_prec')
        
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







