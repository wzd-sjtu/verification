
%%
basic_set;

%  �涨ѵ�����ݺʹ洢����
train_number=100;
test_number=2000;

label_data=xlsread('label.xls');

file_path='image02/';
%  ����һ��ε�ѵ��  ����Ҫ������֤��
data_accuracy=zeros(1,10);

%%
%  ÿ�ζ�ȡ��Ҫ���ж�Ӧ��ѵ��

