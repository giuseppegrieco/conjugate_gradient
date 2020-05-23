function [] = compute_experiments(name_folder,num_different_example, num_different_b,min_error)

%   prec 0: Jacobi
%   prec 1: ILU
%   prec 2: Ichol
%   prec 3: no prec
%   prec 4: gmres Jacobi
%   prec 5: gmres ILU
%   prec 6: gmres Ichol
%   prec 7: gmres no pre


data_directory = dir(strcat('./',name_folder));
base_path_data_folder = strcat('./',name_folder,'/');

for index_sub_directory = 1:length(data_directory)
    directory = data_directory(index_sub_directory).name;
    if directory(1) ~= '.'
        path_results = strcat(base_path_data_folder,directory,'/results');
        mkdir(path_results);
        for index_example = 1:num_different_example

            a_matrix_filename = strcat('Example_',num2str(index_example),'_A');
            load(strcat(base_path_data_folder,directory,'/',a_matrix_filename),'A');
            
            for index_b = 0:num_different_b - 1 
                b_vector_filename = strcat('Example_',num2str(index_example),'_b_',num2str(index_b));
                load(strcat(base_path_data_folder,directory,'/',b_vector_filename),'b');

                for preconditioner = 0:7
                    
                    if preconditioner == 3
                        [x, residuals, ~, time_alg] = conjugate_gradient(A, b, min_error);
                        time_prec = 0;
                        
                    elseif preconditioner >= 4
                        prec = preconditioner - 4 ;
                        if prec ~=3
                            
                            t_prec = tic();
                            [P, Pb, Px] = cg_preconditioner(A, b, prec);
                            f = @(x) P(A,x);
                            time_prec = toc(t_prec);
                            
                            t_alg = tic();
                            [x,~,~,~,residuals] = gmres(f,Pb,[],min_error,length(b));
                            time_alg = toc(t_alg);
                            x = Px(x);

                        else
                            time_prec = 0;
                            t_alg = tic();
                            [x,~,~,~,residuals] = gmres(A,b,[],min_error,length(b));
                            time_alg = toc(t_alg);
                        end
                    else
                        [x, residuals, time_prec, time_alg] = conjugate_gradient(A, b, min_error, preconditioner);
                    end
                    save(strcat(path_results,'/','Results_prec_',num2str(preconditioner),'_',b_vector_filename),'x','residuals','time_prec','time_alg');
                end
            end
        end
    end
end
