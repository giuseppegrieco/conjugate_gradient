function [A, b] = input_generator(vertex, edges, min_d, max_d, min_b, max_b)

%function [A, b] = input_generator(vertex, edges, min_d, max_d, min_b, max_b)
%
% This function is used to generate the matrix A and the known terms vector
%
% Input:
%
% - vertex (integer): number of vertex of the graph;
%
% - edges (integer): number of edge of the graph;
%
% - min_d (real number): lower bound of the values in the diagonal of the
% diagonal matrix
%
% - max_d (real number): upper bound of the values in the diagonal of the
% diagonal matrix D
%
% - min_b (real number): lower bound of the values of the known term before
% the projection on the span of A
%
% - max_b (real number): upper bound of the values of the known term before
% the projection on the span of A

% Output:
%
% - A ([n x m]): matrix genereted by E * D * E'
%
% - b (real column vector): the known terms vector of the system given by A;
%
%
%
%
%{
 =======================================
 Authors: Mattia Sangermano, Giuseppe Grieco
 Date: 03-18-20
 =======================================
%}



% Check format input %d
if ~exist('vertex', 'var')
    error("Insert vertex number")
end
if vertex <= 0
    error("Vertex number is a number greater than 0")
end

if ~exist('edges', 'var')
    error("Insert edges number")
end
if edges <= 0
    error("Edges number is a number greater than 0")
end

if ~exist('min_d', 'var')
    error("Insert minimum for the uniform distribution of diagonal")
end
if min_d <= 0
    error("Minimum for the uniform distribution of diagonal must be greater than 0")
end

if ~exist('max_d', 'var')
    error("Insert maximum for the uniform distribution of diagonal")
end
if max_d <= 0
    error("Maximum for the uniform distribution of diagonal must be greater than 0")
end

if max_d < min_d
    error("Maximum for the uniform distribution of diagonal must be greater than the minimum");
end

if ~exist('min_b', 'var')
    error("Insert minimum for the uniform distribution of known terms vector")
end

if ~exist('max_b', 'var')
    error("Insert maximum for the uniform distribution of known terms vector")
end

if max_b < min_b
    error("Maximum for the uniform distribution of known terms vector must be greater than the minimum");
end

% Generation of the diagonal matrix %
diagonal = unifrnd(min_d, max_d, edges, 1);

% Computes inverse of diagonal %
inverse_diagonal = 1./diagonal;
D = spdiags(inverse_diagonal(:), 0, edges, edges);

% Generation of the graph %

% Spanning tree %
s = floor(rand(1, vertex-1) .* (1:vertex-1)) + 1;
t = 2:vertex;
G = digraph(s, t, 'omitselfloops');

if edges > (vertex * (vertex - 1)) / 2
    % Add spanning tree %
    A_tree = adjacency(G);
    A = ones(vertex, vertex);
    s = find(A);
    s_tree = find(A_tree);
    s = setdiff(s, s_tree);
    
    % Set to zeros diagonal in order to prevent self loops %
    d = zeros(vertex, 1);
    d(1) = 1;
    for i = 2:vertex
        d(i) = d(i - 1) + vertex + 1;
    end
    s = setdiff(s, d);
    for i = 1:vertex
        A(i, i) = 0;
    end
    
    % Set to zeros arch not requested %
    set_to_zero = randperm(length(s), (vertex * (vertex - 1)) - edges);    
    for o = set_to_zero
        j = ceil(s(o) / vertex);
        i = mod(s(o), vertex);
        if i == 0
            i = vertex;
        end
        A(i, j) = 0;
    end
    G = digraph(A);
else
    % Add remains edge %
    A = adjacency(G);

    % Obtain possible edges to add %
    s = find(~A);
    d = zeros(vertex, 1);

    % Remove diagonal to omit self loops %
    d(1) = 1;
    for i = 2:vertex
        d(i) = d(i - 1) + vertex + 1;
    end
    s = setdiff(s, d);

    % Generate random edges to add %
    set_to_one = randperm(length(s), edges - vertex + 1);
    for o = set_to_one
        j = ceil(s(o) / vertex);
        i = mod(s(o), vertex);
        if i == 0
            i = vertex;
        end
        A(i, j) = 1;
    end
    G = digraph(A);
end

E = incidence(G);

% Generation of the known terms vector %
b_hat = unifrnd(min_b, max_b, vertex, 1);
kr = ones(vertex, 1);
o_proj = ((b_hat' * kr) / norm(kr)^2) * kr;
b = b_hat - o_proj;

% Computes A %
A = E*D*E';