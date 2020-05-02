%  ������ص�����  �����Ƿָ�õ�����

%  ���Կ�������˰�ͼ�������һЩ�򵥵Ĵ���
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
%����Ķ��������û��ȷ����emm

%%

%  0�Ǻ�ɫ  255�ǰ�ɫ
% img(img~=255)=30;
% img(img==255)=0;

%c1�����
%  ���ݾ�����γ�����Ӱ����� ����ľ���˻�û�н��б任�����Գ��ֵĽ���Ƿǳ���ֵ�
for i=1:num_c1
    neure_c1(:,:,i)=tanh(conv_c(img,w_num_c1(:,:,i))+bias_c1(i));
    %figure;
    %imshow(neure_c1(:,:,i));
end

%%
%s2�ػ���
%  ���ֳػ�������һЩ�Ƚ���ֵĶ��� 
for i=1:num_s2
   neure_s2(:,:,i)=tanh(pooling(neure_c1(:,:,i),w_num_s2(i))+bias_s2(i));
   %figure;
   %imshow(neure_s2(:,:,i));
end

%%
% c3�����
%  ��������ʵ��ľ������

%  ����ĳ�ֹ�����о������
%  �����ѵ������
%  �����ȡ��ֵ�ڳ�ʼ��ʱ�Ѿ�����˿���emm

%  ����ΪʲôҪ����0�� ��Ϊ�������мӷ��ģ��������0�ᷢ���������޵��ӵĲҾ�
neure_c3=neure_c3*0;

for j=1:num_c3
   for i=1:num_s2
       %  ����õľ�����þ���
      if tablets(i,j)==1
         neure_c3(:,:,j)=neure_c3(:,:,j)+conv_c(neure_s2(:,:,i),w_num_c3(:,:,i,j)); 
      end
   end
   neure_c3(:,:,j)=tanh(neure_c3(:,:,j)+bias_c3(j));
end

%%
%  s4�ػ���

for i=1:num_s4
    neure_s4(:,:,i)=tanh(pooling(neure_c3(:,:,i),w_num_s4(i))+bias_s4(i));
end

%%
%  C5��
%  ÿһ����Ԫ��ǰ������в�������һ��һ����120����Ԫ

%  ����ҲҪ���г���0�Ĳ���
neure_c5=neure_c5*0;
%  ��ֹ���治�����ӷ������ֲҾ磬�Ǿ�û������ѵ����
for j=1:num_c5
   for i=1:num_s4
      neure_c5(:,:,j)=neure_c5(:,:,j)+conv_c(neure_s4(:,:,i),w_num_c5(:,:,i,j));
      
   end
   neure_c5(:,:,j)=tanh(neure_c5(:,:,j)+bias_c5(j));
end

%%
% ȫ���Ӳ� connect
% ��ʵ���Դ�120��ֱ�����ӵ�������
% ��������һ��tmp�������任һ����״
tmp_neure_c5=reshape(neure_c5,1,120);
for i=1:num_connect
    neure_connect(:,:,i)=tmp_neure_c5*w_num_connect(:,i);
    neure_connect(:,:,i)=tanh(neure_connect(:,:,i)+bias_connect(i));
end

%%
%  �����
%  ��ʱȷ����10���������һ��
tmp_neure_connect=reshape(neure_connect,1,84);
for i=1:num_output
   neure_output(:,:,i)=tmp_neure_connect*w_num_output(:,i);
   neure_output(:,:,i)=tanh(neure_output(:,:,i)+bias_output(i));
end

tmp_neure_output=reshape(neure_output,10,1);

%%

% �����Ƿ��򴫲����̣���ʽ��ѭ��ǰ������



tmp_delta_neure_output=(tmp_neure_output-label).*(1-tmp_neure_output.^2);
delta_neure_output=reshape(tmp_delta_neure_output,1,1,10);

%%
%ȫ���Ӳ����
tmp_delta_neure_connect=tmp_delta_neure_output'*w_num_output';
tmp_delta_neure_connect=tmp_delta_neure_connect.*(1-tmp_neure_connect.^2);
delta_neure_connect=reshape(tmp_delta_neure_connect,1,1,84);

%����output��Ȩֵ�����Լ�ƫ��

for j=1:num_output
    for i=1:num_connect
       delta_w_output(i,j)=tmp_neure_connect(i)*tmp_delta_neure_output(j);
    end
    delta_bias_output(j)=tmp_delta_neure_output(j);
end

%%
%  ����c5�����Ԫ���

tmp_delta_neure_c5=tmp_delta_neure_connect*w_num_connect';
tmp_delta_neure_c5=tmp_delta_neure_c5.*(1-tmp_neure_c5.^2);
delta_neure_c5=reshape(tmp_delta_neure_c5,1,1,120);

%  ����ȫ���Ӳ��Ȩֵ���º�ƫ��
for j=1:num_connect
    for i=1:num_c5
        %  ԭ��������������˴�������
       delta_w_connect(i,j)=tmp_neure_c5(i)*tmp_delta_neure_connect(j);
    end
    delta_bias_connect(j)=tmp_delta_neure_connect(j);
end

%%
%����s4����Ԫ���

for i=1:num_s4
   for x=1:h_s4 
      for y=1:w_s4
         delta_neure_s4(x,y,i)=reshape(w_num_c5(x,y,i,:),1,120)*tmp_delta_neure_c5'*(1-neure_s4(x,y,i)^2);
         
      end
   end
end

% ����c5���Ȩֵ����

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
% ����c3�����Ԫ���

for i=1:num_c3
   for x=1:h_c3
      for y = 1:w_c3
          %  ��������ƽ��Ȩֵ������Ҫ����1/4  ��һ���ǱȽϹؼ���
         delta_neure_c3(x,y,i)=w_num_s4(i)*delta_neure_s4(fix((x+1)/2),fix((y+1)/2),i)*(1-neure_c3(x,y,i)^2)*(1/4);
      end
   end
end

%  ����s4���Ȩֵ���º�ƫ��
%  �ڼ���֮ǰ��ǰ����������ݹ��㣬��ֹ��ǰ���������Ӱ��
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
%  s2����Ԫ���
%  �ǵ����ñ��ȷ���Ƿ��������

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

%  ����c3��Ȩֵ����

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
%  c1��
for i=1:num_c1
   for x=1:h_c1
      for y=1:w_c1
         delta_neure_c1(x,y,i)=w_num_s2(i)*delta_neure_s2(fix((x+1)/2),fix((y+1)/2),i)*(1-neure_c1(x,y,i)^2)*(1/4);
         %  �����õ���ƽ��������ʳ���1/4
      end
   end
end

%  ����s2��Ȩֵ����
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
% ���������c1������Ӧ�ĸ���
for i=1:num_c1
   for x=1:h_conv
      for y=1:w_conv
         delta_w_c1(x,y,i)=sum(sum(delta_neure_c1(:,:,i).*img(x:x+h_c1-1,y:y+w_c1-1)));
         
      end
   end
   delta_bias_c1(i)=sum(sum(delta_neure_c1(:,:,i)));
   
end

%%

%  ������и���Ȩֵ�ĸ���

w_num_c1=w_num_c1-delta_w_c1*learning_rate;
w_num_s2=w_num_s2-delta_w_s2*learning_rate;
w_num_c3=w_num_c3-delta_w_c3*learning_rate;
w_num_s4=w_num_s4-delta_w_s4*learning_rate;
%  ò��Ȩֵ�ĸ��³����˺ܴ������emm  ���ѿ��ˣ�
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
