function softMaxResult = softMax(Array)
    [~,cols] = size(Array);
    ArrayCal = zeros(3,cols);
    ArrayCal(1,:) = exp(Array);
    sumOfArray = sum(ArrayCal(1,:));
    ArrayCal(2,:) = ArrayCal(1,:)/sumOfArray;
    softMaxResult = ArrayCal(2,:);
end