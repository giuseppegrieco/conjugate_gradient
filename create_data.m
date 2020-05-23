, function [] = create_data(vertexes,arcs,iterations,iterations_b)
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
    directory_name1 = strcat('./data/vertex_',num2str(vertexes(k)),'_arcs_',num2str(arcs(k)),'_dval_inf_1_dval_sup_100');
    directory_name2 = strcat('./data/vertex_',num2str(vertexes(k)),'_arcs_',num2str(arcs(k)),'_dval_inf_1E-06_dval_sup_1');
    mkdir(directory_name1)
    mkdir(directory_name2)
    for i = 1:iterations
        file_name_A1 = strcat('Example_',num2str(i));
        file_name_A2 = strcat('Example_',num2str(i));
        [A,A2, b] = input_gen2020-04-15-Note-16-47erator(vertexes(k), arcs(k), 1, 100, -100, 100, 1E-06, 1);
        save(strcat(directory_name1,'/',file_name_A1,'_A'),'A','b');
        A = A2;
        save(strcat(directory_name2,'/',file_name_A2,'_A'),'A','b'); 
        save(strcat(directory_name1,'/',file_name_A1,'_b_0'),'b');
        save(strcat(directory_name2,'/',file_name_A2,'_b_0'),'b');
        for j = 1:(iterations_b-1)
            b_hat = unifrnd(-100, 100, vertexes(k), 1);
            kr = ones(vertexes(k), 1);
            o_proj = ((b_hat' * kr) / norm(kr)^2) * kr;
            b = b_hat - o_proj;
            save(strcat(directory_name1,'/',file_name_A1,'_b_',num2str(j)),'b'); 
            save(strcat(directory_name2,'/',file_name_A2,'_b_',num2str(j)),'b'); 
        end
    end
end



