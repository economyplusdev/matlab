load('trainedMathModel.mat', 'net', 'maxInputValue');
prompt = 'Enter a mathematical problem (e.g., 1+6 or y=mx+b): ';
userInput = input(prompt, 's');
try
    operatorIndex = regexp(userInput, '[+\-*/]');
    if ~isempty(operatorIndex)
        operator = userInput(operatorIndex);
        num1 = str2double(userInput(1:operatorIndex - 1));
        num2 = str2double(userInput(operatorIndex + 1:end));
        if isnan(num1) || isnan(num2)
            error('Invalid numbers in the equation.');
        end
        switch operator
            case '+'
                opIndex = 1;
                correctResult = num1 + num2;
            case '-'
                opIndex = 2;
                correctResult = num1 - num2;
            case '*'
                opIndex = 3;
                correctResult = num1 * num2;
            case '/'
                opIndex = 4;
                correctResult = num1 / num2;
            otherwise
                error('Invalid operator.');
        end
        testInput = [num1, num2, opIndex, 0, 0, 0];
        testInput(:, 1:2) = testInput(:, 1:2) / maxInputValue;
        predictedResult = predict(net, testInput);
        fprintf('Input: %s\n', userInput);
        fprintf('Predicted Result: %.4f\n', predictedResult);
        fprintf('Correct Result: %.4f\n', correctResult);
        visualizePossibleSolutions3D(net, testInput, maxInputValue, num1, num2, predictedResult, correctResult);
    elseif contains(userInput, 'y=') && contains(userInput, 'x')
        equationParts = strsplit(userInput, {'y=', 'x'});
        m = str2double(equationParts{2});
        b = str2double(equationParts{3});
        if isnan(m) || isnan(b)
            error('Invalid linear equation format. Ensure you have numbers for m and b.');
        end
        num1 = 0;
        num2 = m * num1 + b;
        testInput = [num1, num2, 0, 0, 0, 0];
        testInput(:, 1:2) = testInput(:, 1:2) / maxInputValue;
        predictedResult = predict(net, testInput);
        correctResult = b;
        fprintf('Input: y = %.2fx + %.2f\n', m, b);
        fprintf('Predicted y-value for x = 0: %.4f\n', predictedResult);
        fprintf('Correct y-value for x = 0: %.4f\n', correctResult);
        visualizePossibleSolutions3D(net, testInput, maxInputValue, num1, num2, predictedResult, correctResult);
    else
        error('Invalid input format. Please enter input in the format: number operator number (e.g. 1+6) or y=mx+b.');
    end
catch ME
    fprintf('Error: %s\n', ME.message);
    fprintf('Please enter input in the format: number operator number (e.g. 1+6) or y=mx+b.\n');
end

function visualizePossibleSolutions3D(net, inputData, maxInputValue, originalNum1, originalNum2, predictedResult, correctResult)
    figure;
    num1Range = linspace(originalNum1 * 0.8, originalNum1 * 1.2, 20);
    num2Range = linspace(originalNum2 * 0.8, originalNum2 * 1.2, 20);
    [X, Y] = meshgrid(num2Range, num1Range);
    Z = zeros(size(X));
    for i = 1:size(X, 1)
        for j = 1:size(X, 2)
            tempInput = inputData;
            tempInput(1) = Y(i, j);
            tempInput(2) = X(i, j);
            tempInput(:, 1:2) = tempInput(:, 1:2) / maxInputValue;
            Z(i, j) = predict(net, tempInput);
        end
    end
    surf(X, Y, Z);
    xlabel('Input 2 (Varied)');
    ylabel('Input 1 (Varied)');
    zlabel('Predicted Result');
    title('Possible Solutions and AI Behavior');
    colorbar;
    view(30, 45);

    hold on;
    deviation = abs(predictedResult - correctResult);
    markerSize = 10 + deviation * 10; 
    plot3(originalNum2, originalNum1, predictedResult, 'ro', 'MarkerSize', markerSize, 'MarkerFaceColor', 'r');

    plot3(originalNum2, originalNum1, correctResult, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

    plot3([originalNum2, originalNum2], [originalNum1, originalNum1], [predictedResult, correctResult], 'k--', 'LineWidth', 2);

    text(originalNum2, originalNum1, (predictedResult + correctResult) / 2, sprintf('Deviation: %.4f', deviation), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

    hold off;

    legend('Predicted Solutions', 'Predicted Result (Size = Deviation)', 'Correct Result', 'Deviation Line');
end