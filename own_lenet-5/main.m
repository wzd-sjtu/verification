
%%
basic_set;

%  规定训练内容和存储内容
train_number=100;
test_number=2000;

label_data=xlsread('label_complex.xls','B1:B10000');

file_path='image/';
%  进行一万次的训练  首先要生成验证码
data_accuracy=zeros(1,10);

%%
%  每次读取都要进行对应的训练

