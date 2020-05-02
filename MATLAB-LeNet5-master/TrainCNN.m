function CNN = TrainCNN(Train, Label, Test, Tag, alpha)
%% �ڸ��������ݼ���ѵ��������:��LeNet-5����ѵ��.
% Train: �������ݼ���ÿһ�д���һ��input.
% Label: ���ݼ������ǩ��ÿһ�д���һ��output.
% Test: �������Լ���ÿһ�д���һ��input.
% Tag: ���Լ������ǩ��ÿһ�д���һ��output.
% alpha: ��ʼѧϰ��.
% CNN: cell���飬���δ��A1, A2, A3, ...�� Loss.
% Ԭ���飬2019-7

%% ��ʼֵ
if nargin < 4
    alpha = 1e-2; % ��ʼѧϰ��
end
iter = 1000; % ��������������
[CNN, state] = TrainRecovery();% �ָ�ѵ��
start = size(CNN{end}, 2); % ��һ�ε�������
if state
    fprintf('CNN:����[%g]��,����%g.\n', start, state);
    return
end
fprintf('�ӵ�[%g]����ʼ����.\n', start);
p = alpha * 0.99^start;
lr = p * 0.99.^(0:iter); % ѧϰ�����������˥��

%profile on;
%profile clear;
%% ��ʼ����
sy = size(Label, 1);
num = 200;%size(Train, 3);
% ��һ�д�����ڶ������д��׼ȷ��
errs = zeros(3, iter);
count = 0; EarlyStopping = 10; %CNN��ͣ����
queue = cell(EarlyStopping+1, 1); %����������CNN����
for i = 1:iter
    tic;
    alpha = lr(i);
    % �����
    total = zeros(1, num);
    for k = 1 : num % ����Ԫ��
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
        % ������ Loss = -sigma(target * ln(output))
        total(:, k) = - dot(Label(:, k), log(Out));

        % BP-���򴫲�
        err3 = (Out-Label(:, k)) .* Grad(F3);
        B3 = CNN{5} - alpha * err3 * [1; F2]';

        err2 = (CNN{5}(:, 2:end)' * err3) .* Grad(F2);
        B2 = CNN{4} - alpha * err2 * [1; F1]';

        err1 = (CNN{4}(:, 2:end)' * err2) .* Grad(F1);
        B1 = CNN{3} - alpha * err1 * [1; F0]';

        % ������ػ���
        err0 = reshape(CNN{3}(:, 2:end)' * err1, 5, 5, 16); % תΪ����
        A2 = CNN{2}; A1 = CNN{1};
        bp = cell(1, 16);
        for n = 1:16
            bp{n} = Upsampling(err0(:,:,n)) .* Grad(C3{n});% �ϲ���:S4->C3
            for j = 1:6
                grad = conv2(rot180(S2{j}), bp{n}, 'valid'); % C3->S2
                A2{n,j} = A2{n,j} - alpha * grad;
            end
        end
        for n = 1:6
            err = zeros(14, 14);
            for j = 1:16
                err = err + conv2(bp{j}, rot180(A2{j,n}), 'full');
            end
            err = Upsampling(err) .* Grad(C1{n}); % �ϲ���:S2->C1
            grad = conv2(rot180(I), err, 'valid'); % C1->I
            A1{n} = A1{n} - alpha * grad;
        end
        CNN{3} = B1; CNN{4} = B2; CNN{5} = B3;
        CNN{2} = A2; CNN{1} = A1;
    end
    queue = circshift(queue, 1);
    queue{1} = CNN;
    e = mean(total);
    errs(1, i) = e;
    s = Accuracy(CNN, Train, Label, num);
    t = Accuracy(CNN, Test, Tag, num);
    best = max(errs(3, 1:i)); % ǰi-1����õĽ��
    errs(1, i) = e; errs(2, i) = s; errs(3, i) = t;
    if t <= best
        count = count + 1;
        if count == EarlyStopping
            CNN = queue{end};
            Loss = SaveResult(CNN, CNN{end}, errs, i-EarlyStopping, 1);
            return
        end
    else
        count = 0;
    end
    % ����Ȩ��
    if t >= 0
        Loss = SaveResult(CNN, CNN{end}, errs, i, 10);
    end
    fprintf('%g err=%g lr=%g acc=%g %g use %gs\n',i+start,e,alpha,s,t,toc);
end
%profile viewer;
end
