function [] = eig_plot()

[E, D, b] = input_generator(100, 1000, 1e-6, 1, 5, 10);
A1 = sparse(E*inv(D)*E');
G1 = abs(eig(A1));

[EG, D, b] = input_generator(100, 1000, 1e-6, 100, 5, 10);
A2 = sparse(E*inv(D)*E');
G2 = abs(eig(A2));

[E, D, b] = input_generator(100, 99*50, 1e-6, 1, 5, 10);
A3 = sparse(E*inv(D)*E');
G3 = abs(eig(A3));

[EG, D, b] = input_generator(100, 99*50, 1e-6, 100, 5, 10);
A4 = sparse(E*inv(D)*E');
G4 = abs(eig(A4));


dim = size(G1);
x_axis = 1:dim(1);

tiledlayout(2,2)

nexttile
scatter(x_axis, G1);

title(sprintf('Densità: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A1) / (10000), 1e-6, 1), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)

nexttile
scatter(x_axis, G2)
title(sprintf('Densità: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A2) / (10000), 1e-6, 100), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)

nexttile
scatter(x_axis, G3)
title(sprintf('Densità: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A3) / (10000), 1e-6, 1), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)

nexttile
scatter(x_axis, G4)
title(sprintf('Densità: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A4) / (10000), 1e-6, 100), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)