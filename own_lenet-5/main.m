
%%
basic_set;

%  �涨ѵ�����ݺʹ洢����
train_number=100;
test_number=2000;

label_data=xlsread('label_complex.xls','B1:B10000');

file_path='image/';
%  ����һ��ε�ѵ��  ����Ҫ������֤��
data_accuracy=zeros(1,10);

%%
%  ÿ�ζ�ȡ��Ҫ���ж�Ӧ��ѵ��

