function [E, D, b] = input_generator(vertex, edges, min_d, max_d, min_b, max_b)

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
D = spdiags(diagonal(:), 0, edges, edges);

% Generation of the graph %

% Spanning tree %
s = floor(rand(1, vertex-1) .* (1:vertex-1)) + 1;
t = 2:vertex;
G = digraph(s, t, 'omitselfloops');
iter = edges - vertex + 1;

% Add iteratively all remains edges %
while (iter > 0)
    edge = randperm(vertex, 2);
    s = edge(:, 1);
    t = edge(:, 2);
    check = findedge(G, s, t);
    if check == 0
        G = addedge(G, s, t);
        iter = iter - 1;
    end
end

E = incidence(G);

% Generation of the known terms vector %
b_hat = unifrnd(min_b, max_b, vertex, 1);
kr = ones(vertex, 1);
o_proj = ((b_hat' * kr) / norm(kr)^2) * kr;
b = b_hat - o_proj;
