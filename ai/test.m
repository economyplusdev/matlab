load('trainedModel.mat','net');
numSamples = 200;
[XTest,trueLabels] = generateData(numSamples);
predictedLabels = classify(net,XTest);
accuracy = sum(predictedLabels == trueLabels)/numel(trueLabels);
fprintf('Test Accuracy: %.2f%%\n',accuracy*100);
confusionchart(trueLabels,predictedLabels);

function [X,Y] = generateData(numSamples)
X = zeros(numSamples,2);
labels = strings(numSamples,1);
for i = 1:numSamples
    x1 = 2*rand;
    x2 = rand;
    X(i,:) = [x1 x2];
    if (x1>1 && x2>0.5) || (x1<1 && x2<0.5)
        labels(i) = "Blue";
    else
        labels(i) = "Yellow";
    end
end
Y = categorical(labels);
end
