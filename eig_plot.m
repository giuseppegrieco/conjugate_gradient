function [] = eig_plot()

[A, b] = input_generator(1000, 999, 1e-6, 1, 5, 10);
A1 = A;
G1 = abs(eig(A1));

[A, b] = input_generator(1000, 999, 1e-6, 1, 5, 10);
A2 =  A;
G2 = abs(eig(A2));

[A, b] = input_generator(1000, 999, 1e-6, 1, 5, 10);
A3 = A;
G3 = abs(eig(A3));

[A, b] = input_generator(1000, 999, 1e-6, 1, 5, 10);
A4 = A;
G4 = abs(eig(A4));


dim = size(G1);
x_axis = 1:dim(1);

tiledlayout(2,2)

nexttile
scatter(x_axis, G1);

title(sprintf('Densit�: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A1) / (1000000), 1e-6, 1), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)

nexttile
scatter(x_axis, G2)
title(sprintf('Densit�: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A2) / (1000000), 1e-6, 100), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)

nexttile
scatter(x_axis, G3)
title(sprintf('Densit�: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A3) / (1000000), 1e-6, 1), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)

nexttile
scatter(x_axis, G4)
title(sprintf('Densit�: %f, Distribuzione di D: uniforme(min:%.1E, max:%d)', nnz(A4) / (1000000), 1e-6, 100), 'FontSize', 17);
set(gca,'yscale','log')
xlabel('i-esimo autovalore', 'FontSize', 15)
ylabel('log(|\lambda|)', 'FontSize', 15)