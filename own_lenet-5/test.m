%  导入相关的数据  这里是分割好的数据

%  可以看到卷积核把图像进行了一些简单的处理
%input_data=result;

% data1=img;
% data1(data1==255)=0;
% figure;
% imshow(data1);
% core=[1/9 1/9  1/9;
%       1/9  1/9 1/9;
%       1/9 1/9  1/9];
% tmp_data1=conv_c(data1,core);
% figure;
% imshow(tmp_data1);
%具体的读入操作还没有确定的emm

%%

%  0是黑色  255是白色
% img(img~=255)=30;
% img(img==255)=0;

%c1卷积层
%  根据卷积核形成六个影像矩阵 这里的卷积核还没有进行变换，所以出现的结果是非常奇怪的
for i=1:num_c1
    neure_c1(:,:,i)=tanh(conv_c(img,w_num_c1(:,:,i))+bias_c1(i));
    %figure;
    %imshow(neure_c1(:,:,i));
end

%%
%s2池化层
%  发现池化出来了一些比较奇怪的东西 
for i=1:num_s2
   neure_s2(:,:,i)=tanh(pooling(neure_c1(:,:,i),w_num_s2(i))+bias_s2(i));
   %figure;
   %imshow(neure_s2(:,:,i));
end

%%
% c3卷积层
%  下面进行适当的卷积操作

%  按照某种规则进行卷积操作
%  这个是训练矩阵
%  这里的取均值在初始化时已经完成了考虑emm

%  这里为什么要乘上0？ 因为后面是有加法的，如果不乘0会发生输入无限叠加的惨剧
neure_c3=neure_c3*0;

for j=1:num_c3
   for i=1:num_s2
       %  定义好的卷积作用矩阵
      if tablets(i,j)==1
         neure_c3(:,:,j)=neure_c3(:,:,j)+conv_c(neure_s2(:,:,i),w_num_c3(:,:,i,j)); 
      end
   end
   neure_c3(:,:,j)=tanh(neure_c3(:,:,j)+bias_c3(j));
end

%%
%  s4池化层

for i=1:num_s4
    neure_s4(:,:,i)=tanh(pooling(neure_c3(:,:,i),w_num_s4(i))+bias_s4(i));
end

%%
%  C5层
%  每一个神经元和前面的所有层连接在一起。一共有120个神经元

%  这里也要进行乘上0的操作
neure_c5=neure_c5*0;
%  防止后面不断做加法，出现惨剧，那就没法正常训练了
for j=1:num_c5
   for i=1:num_s4
      neure_c5(:,:,j)=neure_c5(:,:,j)+conv_c(neure_s4(:,:,i),w_num_c5(:,:,i,j));
      
   end
   neure_c5(:,:,j)=tanh(neure_c5(:,:,j)+bias_c5(j));
end

%%
% 全连接层 connect
% 其实可以从120层直接连接到输出层的
% 这里做了一个tmp矩阵来变换一下形状
tmp_neure_c5=reshape(neure_c5,1,120);
for i=1:num_connect
    neure_connect(:,:,i)=tmp_neure_c5*w_num_connect(:,i);
    neure_connect(:,:,i)=tanh(neure_connect(:,:,i)+bias_connect(i));
end

%%
%  输出层
%  暂时确定是10个输出尝试一下
tmp_neure_connect=reshape(neure_connect,1,84);
for i=1:num_output
   neure_output(:,:,i)=tmp_neure_connect*w_num_output(:,i);
   neure_output(:,:,i)=tanh(neure_output(:,:,i)+bias_output(i));
end

tmp_neure_output=reshape(neure_output,10,1);