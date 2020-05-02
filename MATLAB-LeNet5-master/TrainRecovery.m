function [CNN, state] = TrainRecovery()
%% �ָ�֮ǰ�Ľ�������Ž���ѵ�������߼�������������.
% n:������Ԫ���������а�˳���һ��Ԫ��Ϊ�������Ԫ�ĸ���,
% ���һ��Ԫ��Ϊ�������Ԫ�ĸ���������Ԫ��Ϊ���ز����Ԫ����.
% CNN: cell���飬���δ��A1, A2, A3, ...�� Loss.
% state: ������ֵΪtrue���ʾCNN��ѵ�����.�������羫��.
% Ԭ���飬2019-7

CNN = LoadNN();

if isempty(CNN)
    % ��ͷ��ʼѵ��.
    CNN = cell(1, 6);

    CNN{1} = cell(1, 6);    % C1�����
    for i=1:6
        CNN{1}{i} = rand(5, 5) - 0.5;
    end

    CNN{2} = cell(16, 6);   % C3�����
    for i=1:16
        for j=1:6
            CNN{2}{i, j} = rand(5, 5) - 0.5;
        end
    end

    CNN{3} = rand(120, 401) - 0.5;% ȫ����
    CNN{4} = rand(84, 121) - 0.5;% ȫ����
    CNN{5} = rand(10, 85) - 0.5;% ȫ����
    CNN{6} = [];            % loss, acc
end

disp('CNN infomation:'); disp(CNN);

%% �����������Ƿ���ѵ�����.
state = 0;
if isempty(CNN{end})
    return
end
EarlyStopping = 10; %CNN��ͣ����
loss = CNN{end}(3, 1:end-EarlyStopping);
best = max(loss);
count = 0;
for i = max(length(loss)+1, 1):length(CNN{end})
    if 0 <= CNN{end}(3,i) && CNN{end}(3,i) <= best
        count = count + 1;
        if count == EarlyStopping
            state = best;
        end
    else
        break
    end
end

end
