function simulate150WavefunctionCurrents
x = linspace(-20,20,500);
t_fixed = 2.5;
dx = x(2)-x(1);
numSims = 150;
figure
hold on
colors = jet(numSims);
for i = 1:numSims
    x0 = -20 + 40*rand();
    sigma = 0.5 + 1.5*rand();
    k0 = 0.5 + 4.5*rand();
    psi = gaussianWavepacket(x, t_fixed, x0, sigma, k0);
    dpsi_dx = gradient(psi, dx);
    J = imag(conj(psi).*dpsi_dx);
    plot(x, J, 'Color', colors(i,:), 'LineWidth', 1);
end
xlabel('x')
ylabel('Probability Current J')
title(['Probability Current for 150 Wavefunctions at t = ', num2str(t_fixed)])
colorbar
hold off
end

function psi = gaussianWavepacket(x, t, x0, sigma, k0)
N = (2*pi*sigma^2)^(-1/4) * (1 + 1i*t/(2*sigma^2))^(-1/2);
psi = N .* exp( -(x - x0 - k0*t).^2./(4*sigma^2*(1+1i*t/(2*sigma^2))) + 1i*k0*x - 1i*(k0^2)*t/2 );
end
