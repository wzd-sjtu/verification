function CNN = LoadNN(file)
%% ��ָ��Ŀ¼��������������.
% file: CNN���Ŀ¼.
% ����CNN: cell���飬���δ��A1, A2, A3, ...�� Loss.
% Ԭ���飬2019-7

if nargin == 0
    file = 'CNN_s*.mat';
end

cnn = dir(file);
if ~isempty(cnn)
    load(cnn(end).name);
    fprintf('Load CNN [%s] succeed.\n', cnn(end).name);
else
    CNN = cell(0);
    fprintf('Load CNN Networks failed.\n');
end

end
