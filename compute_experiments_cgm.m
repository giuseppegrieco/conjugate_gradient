function [] = compute_experiments_cgm()

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


d = dir('./data_mat');

for i = 1:length(d)
    directory = d(i).name;
    if directory(1) ~= '.'
        path = strcat('./data_mat/',directory,'/results');
        mkdir(path);
        for k = 1:10
            a_file = strcat('Example_',num2str(k),'_A');
            load(strcat('./data_mat/',directory,'/',a_file),'A'); 
            for l = 0:4
                b_file = strcat('Example_',num2str(k),'_b_',num2str(l));
                load(strcat('./data_mat/',directory,'/',b_file),'b');
                for preconditioner = 0:3
                    prec = preconditioner;
                    if preconditioner == 3
                        t_alg = tic();
                        [x, ~, ~, ~, residuals] = pcg(A, b, 1e-13,length(b));
                        time_alg = toc(t_alg);
                        time_prec = 0;
                    else
                        t_prec = tic();
                        [P, Pb, Px] = cg_preconditioner(A, b, prec);
                        f = @(x) P(A,x);
                        time_prec = toc(t_prec);

                        t_alg = tic();
                        [x,~,~,~,residuals] = pcg(f,Pb,1e-13,length(b));
                        time_alg = toc(t_alg);
                        x = Px(x);
                    end
                    
                    save(strcat(path,'/','Results_prec_',num2str(preconditioner),'_',b_file),'x','residuals','time_prec','time_alg');
                end
            end
        end
    end
end
