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

%%

% 下面是反向传播过程，公式遵循以前的数据



tmp_delta_neure_output=(tmp_neure_output-label).*(1-tmp_neure_output.^2);
delta_neure_output=reshape(tmp_delta_neure_output,1,1,10);

%%
%全连接层误差
tmp_delta_neure_connect=tmp_delta_neure_output'*w_num_output';
tmp_delta_neure_connect=tmp_delta_neure_connect.*(1-tmp_neure_connect.^2);
delta_neure_connect=reshape(tmp_delta_neure_connect,1,1,84);

%计算output层权值更新以及偏置

for j=1:num_output
    for i=1:num_connect
       delta_w_output(i,j)=tmp_neure_connect(i)*tmp_delta_neure_output(j);
    end
    delta_bias_output(j)=tmp_delta_neure_output(j);
end

%%
%  计算c5层的神经元误差

tmp_delta_neure_c5=tmp_delta_neure_connect*w_num_connect';
tmp_delta_neure_c5=tmp_delta_neure_c5.*(1-tmp_neure_c5.^2);
delta_neure_c5=reshape(tmp_delta_neure_c5,1,1,120);

%  计算全连接层的权值更新和偏置
for j=1:num_connect
    for i=1:num_c5
        %  原来是在这里出现了储存问题
       delta_w_connect(i,j)=tmp_neure_c5(i)*tmp_delta_neure_connect(j);
    end
    delta_bias_connect(j)=tmp_delta_neure_connect(j);
end

%%
%计算s4层神经元误差

for i=1:num_s4
   for x=1:h_s4 
      for y=1:w_s4
         delta_neure_s4(x,y,i)=reshape(w_num_c5(x,y,i,:),1,120)*tmp_delta_neure_c5'*(1-neure_s4(x,y,i)^2);
         
      end
   end
end

% 计算c5层的权值更新

for j=1:num_c5
   for i=1:num_s4
      for x=1:h_s4
         for y=1:w_s4
            delta_w_c5(x,y,i,j)=neure_s4(x,y,i)*delta_neure_c5(:,:,j); 
         end
      end

   end
   
   delta_bias_c5(j)=delta_neure_c5(:,:,j);
end



%%
% 计算c3层的神经元误差

for i=1:num_c3
   for x=1:h_c3
      for y = 1:w_c3
          %  由于用了平均权值，所以要乘上1/4  这一点是比较关键的
         delta_neure_c3(x,y,i)=w_num_s4(i)*delta_neure_s4(fix((x+1)/2),fix((y+1)/2),i)*(1-neure_c3(x,y,i)^2)*(1/4);
      end
   end
end

%  计算s4层的权值更新和偏置
%  在计算之前提前把这里的数据归零，防止以前的数据造成影响
delta_w_s4=delta_w_s4*0;
for i=1:num_s4
   for x=1:h_c3
       for y=1:w_c3
          delta_w_s4(i)=delta_w_s4(i)+neure_c3(x,y,i)*delta_neure_s4(fix((x+1)/2),fix((y+1)/2),i);
          
       end
   end
end
delta_w_s4=delta_w_s4/4;
delta_bias_s4=reshape(sum(sum(delta_neure_s4)),1,16);

%%
%  s2层神经元误差
%  记得利用表格确定是否存在连接

delta_neure_s2=delta_neure_s2*0;
for i=1:num_s2
   for j=1:num_c3
      if tablets(i,j)==1
          for x=1:h_c3
             for y=1:w_c3
                delta_neure_s2(x:x+4,y:y+4,i)=delta_neure_s2(x:x+4,y:y+4,i)+delta_neure_c3(x,y,j).*w_num_c3(:,:,i,j);
                
             end
          end
      end
   end
end
delta_neure_s2=delta_neure_s2.*(1-neure_s2.^2);

%  计算c3的权值更新

for j=1:num_c3
   for i=1:num_s2
      for x=1:h_conv
         for y=1:w_conv
            delta_w_c3(x,y,i,j)=sum(sum(delta_neure_c3(:,:,j).*neure_s2(x:x+h_c3-1,y:y+w_c3-1,i)));
            
         end
      end
   end
   delta_bias_c3(j)=sum(sum(delta_neure_c3(:,:,j)));
end

%%
%  c1层
for i=1:num_c1
   for x=1:h_c1
      for y=1:w_c1
         delta_neure_c1(x,y,i)=w_num_s2(i)*delta_neure_s2(fix((x+1)/2),fix((y+1)/2),i)*(1-neure_c1(x,y,i)^2)*(1/4);
         %  这里用到了平均卷积，故乘上1/4
      end
   end
end

%  计算s2的权值更新
delta_w_s2=delta_w_s2*0;
for i=1:num_s2
   for x=1:h_c1
      for y=1:w_c1
          delta_w_s2(i)=delta_w_s2(i)+neure_c1(x,y,i)*delta_neure_s2(fix((x+1)/2),fix((y+1)/2),i);
          
      end
   end
end
delta_w_s2=delta_w_s2/4;
delta_bias_s2=reshape(sum(sum(delta_neure_s2)),1,6);

%%
% 根据输入对c1进行相应的更新
for i=1:num_c1
   for x=1:h_conv
      for y=1:w_conv
         delta_w_c1(x,y,i)=sum(sum(delta_neure_c1(:,:,i).*img(x:x+h_c1-1,y:y+w_c1-1)));
         
      end
   end
   delta_bias_c1(i)=sum(sum(delta_neure_c1(:,:,i)));
   
end

%%

%  下面进行各种权值的更新

w_num_c1=w_num_c1-delta_w_c1*learning_rate;
w_num_s2=w_num_s2-delta_w_s2*learning_rate;
w_num_c3=w_num_c3-delta_w_c3*learning_rate;
w_num_s4=w_num_s4-delta_w_s4*learning_rate;
%  貌似权值的更新出现了很大的问题emm  我裂开了！
w_num_c5=w_num_c5-delta_w_c5*learning_rate;
w_num_connect=w_num_connect-delta_w_connect*learning_rate;
w_num_output=w_num_output-delta_w_output*learning_rate;

bias_c1=bias_c1-delta_bias_c1*learning_rate;
bias_s2=bias_s2-delta_bias_s2*learning_rate;
bias_c3=bias_c3-delta_bias_c3*learning_rate;
bias_s4=bias_s4-delta_bias_s4*learning_rate;
bias_c5=bias_c5-delta_bias_c5*learning_rate;
bias_connect=bias_connect-delta_bias_connect*learning_rate;
bias_output=bias_output-delta_bias_output*learning_rate;
