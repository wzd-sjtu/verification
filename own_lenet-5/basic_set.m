clc 
clear


%%
%定义网络的各层参数

%  各层的数目
num_input=1;

num_c1=6;
num_s2=6;
num_c3=16;
num_s4=16;
num_c5=120;
num_connect=84;
num_output=10;%  这里的输出可以多上几层，从而对别的字符进行识别


%  各层操作时图像的尺寸以及卷积核尺寸
h_input=32;w_input=32;
h_c1=28;w_c1=28;
h_s2=14;w_s2=14;
h_c3=10;w_c3=10;
h_s4=5;w_s4=5;

h_c5=1;w_c5=1;%  第五层卷积过后仅仅出现一个神经元
h_connect=1;w_connect=1;
h_output=1;w_output=1;
h_conv=5;w_conv=5;
h_pool=2;w_pool=2;

%  各层神经元数目以及偏置

num_neure_input=32*32;
num_neure_c1=6*28*28;
num_neure_s2=6*14*14;
num_neure_c3=16*10*10;
num_neure_s4=5*5*16;
num_neure_c5=1*120;
num_neure_connect=1*84; %中间有一步全连接层，最后是输出层
num_neure_output=10;

%  以下是权值的尺寸
num_weight_c1=5*5*6;
num_weight_s2=6;
num_weight_c3=5*5*16*6;
num_weight_s4=16;
num_weight_c5=5*5*16*120;
num_weight_connect=120*84;
num_weight_output=84*10;

num_bias_c1=6;
num_bias_s2=6;
num_bias_c3=16;
num_bias_s4=16;
num_bias_c5=120;
num_bias_connect=84;
num_bias_output=10;

%  训练参数
max_generations=100;
accuracy=0.99;
learning_rate=0.01;
step=1e-8;  %步长or误差率

e_w_c1=0;e_bias_c1=0;
e_w_s2=0;e_bias_s2=0;
e_w_c3=0;e_bias_c3=0;
e_w_s4=0;e_bias_s4=0;
e_w_c5=0;e_bias_c5=0;
e_w_output=0;e_bias_output=0;
%%
%  网络各种矩阵初始化
%  这里的初始化使用了Xavier initialization方法进行初始化，防止出现梯度消失
%  初始化方法  m是输入数据维度，n是输出数据维度，产生在[-sqrt(6/(m+n)),sqrt(6/(m+n))]区间里面的均匀分布参数
%  可以在使用tanh作为激活函数时让数据不出现梯度消失的情况
%  不妨只考虑输入的情况
w_num_c1=reshape((rand(1,num_weight_c1)-0.5)*sqrt(6/175),5,5,6);
%  这里是各个层次的卷积or池化参数
w_num_s2=(rand(1,num_weight_s2)-0.5)*(sqrt(6/5));
w_num_c3=(rand(1,num_weight_c3)-0.5)*(sqrt(6/550));w_num_c3=reshape(w_num_c3,5,5,6,16);
w_num_s4=(rand(1,num_weight_s4)-0.5)*(sqrt(6/5));
w_num_c5=(rand(1,num_weight_c5)-0.5)*(sqrt(6/3400));w_num_c5=reshape(w_num_c5,5,5,16,120);
w_num_connect=(rand(1,num_weight_connect)-0.5)*sqrt(6/200);w_num_connect=reshape(w_num_connect,120,84);
w_num_output=(rand(1,num_weight_output)-0.5)*(sqrt(6/100));w_num_output=reshape(w_num_output,84,10);
bias_c1=zeros(1,num_bias_c1);
bias_s2=zeros(1,num_bias_s2);
bias_c3=zeros(1,num_bias_c3);
bias_s4=zeros(1,num_bias_s4);
bias_c5=zeros(1,num_bias_c5);
bias_connect=zeros(1,num_bias_connect);
bias_output=zeros(1,num_bias_output);


delta_w_c1=zeros(1,num_weight_c1);delta_w_c1=reshape(delta_w_c1,5,5,6);%权值及偏置更新量
delta_w_s2=zeros(1,num_weight_s2);
delta_w_c3=zeros(1,num_weight_c3);delta_w_c3=reshape(delta_w_c3,5,5,6,16);
delta_w_s4=zeros(1,num_weight_s4);
delta_w_c5=zeros(1,num_weight_c5);delta_w_c5=reshape(delta_w_c5,5,5,16,120);
delta_w_connect=zeros(1,num_weight_connect);delta_w_connect=reshape(delta_w_connect,120,84);
delta_w_output=zeros(1,num_weight_output);delta_w_output=reshape(delta_w_output,84,10);

delta_bias_c1=zeros(1,num_bias_c1);
delta_bias_s2=zeros(1,num_bias_s2);
delta_bias_c3=zeros(1,num_bias_c3);
delta_bias_s4=zeros(1,num_bias_s4);
delta_bias_c5=zeros(1,num_bias_c5);
delta_bias_connect=zeros(1,num_bias_connect);
delta_bias_output=zeros(1,num_bias_output);

%  下面规定每层神经元的输出
neure_c1=zeros(h_c1,w_c1,num_c1);
neure_s2=zeros(h_s2,w_s2,num_s2);
neure_c3=zeros(h_c3,w_c3,num_c3);
neure_s4=zeros(h_s4,w_s4,num_s4);
neure_c5=zeros(h_c5,w_c5,num_c5);
neure_connect=zeros(h_connect,w_connect,num_connect);
neure_output=zeros(h_output,w_output,num_output);

delta_neure_c1=zeros(h_c1,w_c1,num_c1);
delta_neure_s2=zeros(h_s2,w_s2,num_s2);
delta_neure_c3=zeros(h_c3,w_c3,num_c3);
delta_neure_s4=zeros(h_s4,w_s4,num_s4);
delta_neure_c5=zeros(h_c5,w_c5,num_c5);
delta_neure_connect=zeros(h_connect,w_connect,num_connect);
delta_neure_output=zeros(h_output,w_output,num_output);


%  某一层的矩阵在这里
tablets=[1 0 0 0 1 1 1 0 0 1 1 1 1 0 1 1;
         1 1 0 0 0 1 1 1 0 0 1 1 1 1 0 1;
         1 1 1 0 0 0 1 1 1 0 0 1 0 1 1 1;
         0 1 1 1 0 0 1 1 1 1 0 0 1 0 1 1;
         0 0 1 1 1 0 0 1 1 1 1 0 1 1 0 1;
         0 0 0 1 1 1 0 0 1 1 1 1 0 1 1 1;
    ];