function s = Accuracy(CNN, Train, Tag, N)
%% ����������CNN�ڲ��Լ�Test�ϵ�׼ȷ��.Tag�ǲ��Լ��ı�ǩ.
% CNN: cell���飬���δ��A1, A2, A3, ...�� Loss.
% Train:���ݼ�.
% Tag:���ݼ���ǩ.
% s: CNN׼ȷ��.
% Ԭ���飬2019-7

if isempty(Train) || isempty(Tag)
    s = -1;
    return
end
if nargin < 4
    N = size(Test, 3);
end

r = zeros(1, N);
for k = 1:N
    I = Train(:, :, k);
    % ���,�ػ� 32 -> 28 -> 14
    C1 = cell(1, 6); S2 = cell(1, 6);
    for n = 1:6
        C1{n} = reLU(conv2(I, CNN{1}{n}, 'valid'));
        S2{n} = Sampling(C1{ n });
    end
    % ���,�ػ� 14 -> 10 -> 5
    C3 = cell(1, 16); S4 = cell(1, 16);
    F0 = zeros(16 * 5*5, 1);
    for n = 1:16
        Sum = zeros(10, 10);
        for j = 1:6
            Sum = Sum+conv2(S2{j},CNN{2}{n,j},'valid');
        end
        C3{n} = reLU(Sum);
        S4{n} = Sampling(C3{n});
        s = 1 + (n-1) * 25;
        F0(s:s+24) = S4{n}(:);
    end
    % ȫ���� 400 -> 120 -> 84 -> 10
    F1 = reLU(CNN{3} * [1; F0]);
    F2 = reLU(CNN{4} * [1; F1]);
    F3 = reLU(CNN{5} * [1; F2]);
    Out = softmax(F3);
    % softmax
    [a, p] = max(Out);
    [b, tag] = max(Tag(:, k));
    r(k) = p==tag;
end

s = mean(r);

end
