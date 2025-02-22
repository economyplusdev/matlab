numSamples = 500;
[X,Y] = generateData(numSamples);
classNames = ["Blue","Yellow"];
inputSize = size(X,2);
numClasses = numel(classNames);
layers = [featureInputLayer(inputSize,Normalization="none")
          fullyConnectedLayer(10)
          reluLayer
          fullyConnectedLayer(numClasses)
          softmaxLayer
          classificationLayer];
options = trainingOptions("sgdm",...
    'MaxEpochs',1000,...
    'MiniBatchSize',20,...
    'InitialLearnRate',0.05,...
    'Momentum',0.9,...
    'ExecutionEnvironment','cpu',...
    'Plots','training-progress',...
    'Verbose',false);
net = trainNetwork(X,Y,layers,options);
save('trainedModel.mat','net');

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
