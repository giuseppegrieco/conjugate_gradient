function [] = compute_experiments()

%   prec 0: Jacobi
%   prec 1: ILU
%   prec 2: Ichol
%   prec 3: no prec
%   prec 4: gmres Jacobi
%   prec 5: gmres ILU
%   prec 6: gmres Ichol
%   prec 7: gmres no prec
%
%
%
%


d = dir('./data');

for i = 1:length(d)
    directory = d(i).name;
    if directory(1) ~= '.'
        path = strcat('./data/',directory,'/results');
        mkdir(path);
        for k = 1:10
            a_file = strcat('Example_',num2str(k),'_A');
            load(strcat('./data/',directory,'/',a_file),'A'); 
            for l = 0:4
                b_file = strcat('Example_',num2str(k),'_b_',num2str(l));
                load(strcat('./data/',directory,'/',b_file),'b');
                for preconditioner = 0:7
                    if preconditioner == 3
                        [x, residuals, ~,time_alg] = conjugate_gradient(A, b);
                        time_prec = 0;
                    elseif preconditioner >= 4
                        prec = preconditioner - 4 ;
                        if prec ~=3
                            
                            t_prec = tic();
                            [P, Pb, Px] = cg_preconditioner(A, b, prec);
                            f = @(x) P(A,x);
                            time_prec = toc(t_prec);
                            
                            t_alg = tic();
                            [x,~,~,~,residuals] = gmres(f,Pb,[],1e-13,length(b));
                            time_alg = toc(t_alg);
                            x = Px(x);

                        else
                            time_prec = 0;
                            t_alg = tic();
                            [x,~,~,~,residuals] = gmres(A,b,[],1e-13,length(b));
                            time_alg = toc(t_alg);
                        end
                    else
                        [x, residuals, time_prec, time_alg] = conjugate_gradient(A, b, preconditioner);
                    end
                    
                    save(strcat(path,'/','Results_prec_',num2str(preconditioner),'_',b_file),'x','residuals','time_prec','time_alg');
                end
            end
        end
    end
end
