function [X, Y] = generateData(numSamples)
    X = zeros(numSamples, 6);
    Y = zeros(numSamples, 1);
    operations = {'+', '-', '*', '/'};
    validSamples = 0;
    maxSamples = numSamples;

    while validSamples < maxSamples
        num1 = randi([-20, 20]);
        num2 = randi([-20, 20]);
        opIndex = randi([1, length(operations)]);
        op = operations{opIndex};

        validSamples = validSamples + 1;
        X(validSamples, 1) = num1;
        X(validSamples, 2) = num2;
        operator_one_hot = zeros(1, 4);
        operator_one_hot(opIndex) = 1;
        X(validSamples, 3:6) = operator_one_hot;

        if rand() < 0.2
            Y(validSamples) = num1^2 + sin(num2);
        elseif rand() < 0.4
            Y(validSamples) = cos(num1) + num2^3;
        elseif rand() < 0.6
            Y(validSamples) = num1 * sin(num2) + num2 / (num1 + 1e-8); 
        else
            switch op
                case '+'
                    Y(validSamples) = num1 + num2;
                case '-'
                    Y(validSamples) = num1 - num2;
                case '*'
                    Y(validSamples) = num1 * num2;
                case '/'
                    if num2 == 0
                        Y(validSamples) = 0; 
                    else
                        Y(validSamples) = num1 / num2;
                    end
            end
        end

        if isnan(Y(validSamples))
            Y(validSamples) = 0;
        end
    end

    shuffleIdx = randperm(validSamples);
    X = X(shuffleIdx, :);
    Y = Y(shuffleIdx);
end