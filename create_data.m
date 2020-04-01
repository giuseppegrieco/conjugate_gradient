function [] = create_data(vertexes,arcs,d_values,iterations,iterations_b)
%function [ ] = create_data( arcs, plot_title, iterations)
%
% Create all data needed for the experiments
%
%   [] = f(arcs, d_values, iterations )
%
% Input:
%
% - arcs is a [ 1 x n ] integers vector denoting the combinations of edges
% used to generate different graphs.
%
% -  d_values is a [ 1 x n ] integers vector denoting the different
% combinations of ranges in which to choose the diagonal values of the diagonal matrix.
%
% - iterations is a integer denoting the number of different example to
% generate for each combination of edge and d_value

% Output:
%
% For each combination of d_value and edge create a directory containg a number 
% of different examples equal to the number of iterations chosen
%
%
%{
 =======================================
 Author: Mattia Sangermano, Giuseppe Grieco
 Date: 03-15-20
 =======================================
%}
lenvert = size(vertexes);

for k = 1:lenvert(2)
    for d = d_values'
        directory_name = strcat('./data/vertex_',num2str(vertexes(k)),'_edge_',num2str(arcs(k)),'_dval_inf_',num2str(d(1)),'dval_sup',num2str(d(2)));
        mkdir(directory_name)
        for i = 1:iterations
            file_name = strcat('Example_',num2str(i));
            [A, b] = input_generator(vertexes(k), arcs(k), d(1), d(2), -100, 100);
            save(strcat(directory_name,'/',file_name,'_b_0'),'A','b'); 
            for j = 1:(iterations_b-1)
                b_hat = unifrnd(-100, 100, vertexes(k), 1);
                kr = ones(vertexes(k), 1);
                o_proj = ((b_hat' * kr) / norm(kr)^2) * kr;
                b = b_hat - o_proj;
                save(strcat(directory_name,'/',file_name,'_b_',num2str(j)),'A','b'); 
            end

        end
    end
end



