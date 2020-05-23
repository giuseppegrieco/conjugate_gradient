function [] = plot_residuals(A, b, min_error)

%generation and plot of our conjugate gradient results without preconditioner
[~, residuals] = conjugate_gradient(A, b , min_error);
num_iterations = size(residuals);
num_iterations = num_iterations(2);
semilogy((1:num_iterations), residuals);

%generation and plot of our conjugate gradient results using preconditioner
hold on
for preconditioner = [0, 1, 2]
    [~, residuals] = conjugate_gradient(A, b, min_error, preconditioner);
    num_iterations = size(residuals);
    num_iterations = num_iterations(2);
    semilogy((1:num_iterations), residuals);
end
hold off
legend('No prec', 'Jacobi', 'ILU', 'I. Cholesky')
