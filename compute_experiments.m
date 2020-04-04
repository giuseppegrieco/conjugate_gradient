function [] = compute_experiments()
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
                        [x, residuals, time] = conjugate_gradient(A, b);

                    elseif preconditioner >= 4
                        prec = preconditioner - 4 ;
                        if prec ~=3
                            
                            [P, Pb, Px] = cg_preconditioner(A, b, prec);
                            f = @(x) P(A,x);
                            
                            tic;
                            [x,~,~,~,residuals] = gmres(f,Pb,[],1e-13,length(b));
                            time = toc;
                            x = Px(x);

                        else
                            tic;
                            [x,~,~,~,residuals] = gmres(A,b,[],1e-13,length(b));
                            time = toc;
                        end
                    else
                        [x, residuals, time] = conjugate_gradient(A, b, preconditioner);
                    end
                    
                    save(strcat(path,'/','Results_prec_',num2str(preconditioner),'_',b_file),'x','residuals','time');
                end
            end
        end
    end
end
