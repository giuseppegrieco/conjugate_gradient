function [] = create_data(arcs,d_values,iterations)
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


for arc = arcs
    for d = d_values
        directory_name = strcat('./data/edge_',num2str(arc),'_dval_',num2str(d));
        mkdir(directory_name)
        for i = 1:iterations
            file_name = strcat('Example_',num2str(i));
            [A, ~] = input_generator(100, arc, 1E-6, d, -100, 100);
            save(strcat(directory_name,'/',file_name),'A'); 
        end
    end
end