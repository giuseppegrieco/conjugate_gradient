function [] = compute_experiments(name_folder,path_results,min_error)

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
        load(strcat(base_path_data_folder,directory),'A','b');
        for preconditioner = 0:5

            if preconditioner == 2
                [x, residuals, ~, time_alg] = conjugate_gradient(A, b, min_error);
                time_prec = 0;

            elseif preconditioner >= 3
                prec = preconditioner - 3 ;
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
            save(strcat(path_results,'/',erase(directory,".mat"),'_prec_',num2str(preconditioner),'.mat'),'x','residuals','time_prec','time_alg');
        end
    end
end
