clc 
clear


%%
%��������ĸ������

%  �������Ŀ
num_input=1;

num_c1=6;
num_s2=6;
num_c3=16;
num_s4=16;
num_c5=120;
num_connect=84;
num_output=10;%  �����������Զ��ϼ��㣬�Ӷ��Ա���ַ�����ʶ��


%  �������ʱͼ��ĳߴ��Լ�����˳ߴ�
h_input=32;w_input=32;
h_c1=28;w_c1=28;
h_s2=14;w_s2=14;
h_c3=10;w_c3=10;
h_s4=5;w_s4=5;

h_c5=1;w_c5=1;%  ������������������һ����Ԫ
h_connect=1;w_connect=1;
h_output=1;w_output=1;
h_conv=5;w_conv=5;
h_pool=2;w_pool=2;

%  ������Ԫ��Ŀ�Լ�ƫ��

num_neure_input=32*32;
num_neure_c1=6*28*28;
num_neure_s2=6*14*14;
num_neure_c3=16*10*10;
num_neure_s4=5*5*16;
num_neure_c5=1*120;
num_neure_connect=1*84; %�м���һ��ȫ���Ӳ㣬����������
num_neure_output=10;

%  ������Ȩֵ�ĳߴ�
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

%  ѵ������
max_generations=100;
accuracy=0.99;
learning_rate=0.01;
step=1e-8;  %����or�����

e_w_c1=0;e_bias_c1=0;
e_w_s2=0;e_bias_s2=0;
e_w_c3=0;e_bias_c3=0;
e_w_s4=0;e_bias_s4=0;
e_w_c5=0;e_bias_c5=0;
e_w_output=0;e_bias_output=0;
%%
%  ������־����ʼ��
%  ����ĳ�ʼ��ʹ����Xavier initialization�������г�ʼ������ֹ�����ݶ���ʧ
%  ��ʼ������  m����������ά�ȣ�n���������ά�ȣ�������[-sqrt(6/(m+n)),sqrt(6/(m+n))]��������ľ��ȷֲ�����
%  ������ʹ��tanh��Ϊ�����ʱ�����ݲ������ݶ���ʧ�����
%  ����ֻ������������
w_num_c1=reshape((rand(1,num_weight_c1)-0.5)*sqrt(6/175),5,5,6);
%  �����Ǹ�����εľ��or�ػ�����
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


delta_w_c1=zeros(1,num_weight_c1);delta_w_c1=reshape(delta_w_c1,5,5,6);%Ȩֵ��ƫ�ø�����
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

%  ����涨ÿ����Ԫ�����
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


%  ĳһ��ľ���������
tablets=[1 0 0 0 1 1 1 0 0 1 1 1 1 0 1 1;
         1 1 0 0 0 1 1 1 0 0 1 1 1 1 0 1;
         1 1 1 0 0 0 1 1 1 0 0 1 0 1 1 1;
         0 1 1 1 0 0 1 1 1 1 0 0 1 0 1 1;
         0 0 1 1 1 0 0 1 1 1 1 0 1 1 0 1;
         0 0 0 1 1 1 0 0 1 1 1 1 0 1 1 1;
    ];