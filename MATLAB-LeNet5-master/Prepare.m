function [Data, Label, Test, Tag] = Prepare()
%% ����Ԥ��������cifar-10-batches-mat���ݣ�ת��Ϊ�Ҷ�ͼ��.
% Data: ���ݼ���ÿһ����һ��input.
% Label�����ݼ���ǩ��ÿһ����һ��output.
% Test: ��֤����ÿһ����һ��input.
% Tag����֤����ǩ��ÿһ����һ��output.

clc;

if exist('cifar-10.mat', 'file')
    fprintf('Loading "cifar-10.mat".\n');
    load('cifar-10.mat');
    return;
end

Data = zeros(32, 32, 5*10000);
Label = zeros(10, 5*10000);
for i = 1:5
    batch = ['cifar-10-batches-mat\data_batch_',num2str(i),'.mat'];
    [data, labels] = load_batch(batch);
    s = (i-1) * 10000 + 1;
    Data(:, :, s:s+9999) = data;
    Label(:, s:s+9999) = labels;
    clear data labels;
end
test = ['cifar-10-batches-mat\test_batch.mat'];
[Test, Tag] = load_batch(test);
save('cifar-10.mat')
end

function [Data, Label] = load_batch(batch)
%% ����cifar-10-batches-matĿ¼��ָ����batch.
% batch: �ļ�����.

load(batch);

if exist('data', 'var') && exist('labels', 'var')
    data = data';
    labels = labels';
    n = length(labels);
    data = reshape(data, 32, 32, 3, n);
    Data = zeros(32, 32, n);
    for i=1:n
        g = rot90(rgb2gray(data(:, :, :, i)), -1);
        Data(:, :, i) = double(g) / 255 - 0.5;
    end
    Label = zeros(10, n) + 0.001;
    Label(linspace(1,10*n-9,n)+double(labels)) = 1;
    fprintf('Loading batch: %s.\n', batch_label);
else
    Data = [];
    Label = [];
end
end
