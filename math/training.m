numSamples = 500 * 100;
[X, Y] = generateData(numSamples);
maxYValue = max(abs(Y));
Y = Y / maxYValue;
inputSize = 6;
outputSize = 1;
maxInputValue = max(abs(X(:,1:2)), [], 'all');
X(:,1:2) = X(:,1:2) / maxInputValue;
layers = [
    featureInputLayer(inputSize, Normalization="none")
    fullyConnectedLayer(200, WeightLearnRateFactor=10, WeightL2Factor=0.001)
    reluLayer
    batchNormalizationLayer
    fullyConnectedLayer(100, WeightLearnRateFactor=10, WeightL2Factor=0.001)
    reluLayer
    batchNormalizationLayer
    fullyConnectedLayer(50, WeightLearnRateFactor=10, WeightL2Factor=0.001)
    reluLayer
    batchNormalizationLayer
    fullyConnectedLayer(25, WeightLearnRateFactor=10, WeightL2Factor=0.001)
    reluLayer
    batchNormalizationLayer
    fullyConnectedLayer(10, WeightLearnRateFactor=10, WeightL2Factor=0.001)
    reluLayer
    batchNormalizationLayer
    fullyConnectedLayer(5, WeightLearnRateFactor=10, WeightL2Factor=0.001)
    reluLayer
    batchNormalizationLayer
    fullyConnectedLayer(outputSize)
    regressionLayer
];
options = trainingOptions("adam", "MaxEpochs", 450, "MiniBatchSize", 256, "InitialLearnRate", 0.00005, "ValidationPatience", 10, "Plots", "training-progress", "Verbose", true, "GradientThreshold", 1);
[net, info] = trainNetwork(X, Y, layers, options);
save('trainedMathModel.mat', 'net', 'maxInputValue', 'maxYValue');
operators = {'+', '-'};
numTests = 10;
for i = 1:numTests
    num1 = randi([1, 10]);
    num2 = randi([1, 10]);
    opIndex = randi(2);
    opSymbol = operators{opIndex};
    testMathModel(net, maxInputValue, maxYValue, num1, num2, opSymbol, opIndex);
end