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