close all; clear; clc;
% Lenet_Binary Parameters
% load('.\lenet_binary\lenet_conv_parameters\conv1.mat'); 

load('.\parameters\conv1_w.mat');
load('.\parameters\conv1_b.mat');
load('.\parameters\conv2_w.mat');
load('.\parameters\conv2_b.mat');
load('.\parameters\ip1_w.mat');
load('.\parameters\ip1_b.mat');
load('.\parameters\ip2_w.mat');
load('.\parameters\ip2_b.mat');

image = double(imread('1.jpg'))/255; %归一化
% 第一层convolution层 Binary
% A = zeros(24,24,20);
% for i = 1:size(conv1_w,4)
%     A(:,:,i) = convolution(image,conv1_w(:,:,1,i)) + conv1_b(i);
% end

% 第一层convolution层 Comm
A = zeros(24,24,20);
for i = 1:20
    A(:,:,i) = convolution(image,conv1_w(i,1,:,:)) + conv1_b(i);
end

% 第二层maxpooling层
B = zeros(12,12,20);
for i = 1:20
    for row = 1:12
        for col = 1:12
            B(row,col,i) = max(max(A(2*row-1:2*row,2*col-1:2*col,i)));
        end
    end
end

% 第三层convolution层
C = zeros(8,8,50);
for i = 1:50
    for j = 1:20
        C(:,:,i) = C(:,:,i) + convolution(B(:,:,j),conv2_w(i,j,:,:));
    end
    C(:,:,i) = C(:,:,i) + conv2_b(i);
end

% 第四层maxpooling层
D = zeros(4,4,50);
for i = 1:50
    for row = 1:4
        for col = 1:4
            D(row,col,i) = max(max(C(2*row-1:2*row,2*col-1:2*col,i)));
        end
    end
end

% 第五层InnerProduct层
DRow = zeros(1,800);
for index = 1:50
    DRow(index*16-15:index*16) = [D(1,1:4,index),D(2,1:4,index),D(3,1:4,index),D(4,1:4,index)];
end
E = ip1_w * DRow' + ip1_b';

% 第六层reLu层
F = (E>0).*E;

% 第七层InnerProduct层
G = ip2_w*F + ip2_b';

[~,result] = max(softMax(G'));

disp(['The classification Result is ',num2str(result-1)]);