function simulateRydbergSpectrumComparison
R = 1.097373e7;
n_j = 2;
n_i_values = 3:6;
predicted = zeros(size(n_i_values));
experimental = [656.3, 486.1, 434.1, 410.2];
for idx = 1:length(n_i_values)
    n_i = n_i_values(idx);
    inv_lambda = R*(1/(n_j^2) - 1/(n_i^2));
    lambda = 1/inv_lambda;
    predicted(idx) = lambda*1e9;
end
fprintf('Transition (n_i -> n_j): Predicted (nm)   Experimental (nm)   Difference (nm)\n');
for idx = 1:length(n_i_values)
    fprintf('%d -> %d:             %.2f            %.2f              %.2f\n', n_i_values(idx), n_j, predicted(idx), experimental(idx), abs(predicted(idx)-experimental(idx)));
end
figure
hold on
plot(n_i_values, predicted, 'bo-', 'LineWidth',2, 'MarkerSize',8);
plot(n_i_values, experimental, 'rx--', 'LineWidth',2, 'MarkerSize',8);
xlabel('Initial Energy Level n_i');
ylabel('Wavelength (nm)');
title('Rydberg Formula: Predicted vs. Experimental Spectral Lines');
legend('Predicted','Experimental','Location','Best');
grid on
hold off
end
