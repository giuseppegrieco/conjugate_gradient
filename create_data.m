function [] = create_data(arcs,values,iterations)
for arc = arcs
    for d = values
        directory_name = strcat('./data/edge_',num2str(arc),'_dval_',num2str(d));
        mkdir(directory_name)
        for i = 1:iterations
            file_name = strcat('Example_',num2str(i));
            [A, ~] = input_generator(100, arc, 1E-6, d, -100, 100);
            save(strcat(directory_name,'/',file_name),'A'); 
        end
    end
end