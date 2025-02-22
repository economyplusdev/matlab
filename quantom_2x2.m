function amplitudeAmplificationSimulation
n=3;
dim=2^n;
target=5;
s=ones(dim,1)/sqrt(dim);
gammaVals=linspace(0,2*pi,50);
kVals=0:10;
Z=zeros(length(kVals),length(gammaVals));
D=2*(s*s')-eye(dim);
for j=1:length(gammaVals)
    gamma=gammaVals(j);
    O=eye(dim);
    O(target,target)=exp(1i*gamma);
    for k=0:max(kVals)
        psi=(D*O)^k*s;
        Z(k+1,j)=abs(psi(target))^2;
    end
end
[p_true_max, ~] = max(Z(:));
fprintf('Probability of true: %.4f\n',p_true_max);
fprintf('Probability of false: %.4f\n',1-p_true_max);
[X,Y] = meshgrid(gammaVals,kVals);
figure
surf(X,Y,Z,'EdgeColor','none')
colormap jet
shading interp
colorbar
xlabel('\gamma')
ylabel('Iterations (k)')
zlabel('Probability')
title('Amplitude Amplification for 2x2=4')
view([-45 45])
end
