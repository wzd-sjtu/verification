%%
%  ����һ��ͼƬ��ԭʼ����
pic_1 = imread('1.png');
%  ������ͼƬ��ʾ����
imshow(pic_1);

%%
%  ��ͼƬ���лҶȻ�  ������ɫ��ʶ�����Ӱ��
pic_1 = rgb2gray(pic_1);
%  �ٰ�ͼƬ��ʾ����
figure();
imshow(pic_1);
%%
%  ���뱳��
%  ������Ӧ���Ƚ�����ֵ�ָ�
[h, w] = size(pic_1);
% %  ȫ����ֵ
% T = 0.5*(min(pic_1(:))+max(pic_1(:)));
% done = false;
% 
% while ~done
%     %  ��ȡ��������
%     g = pic_1>T;
%     Tn = 0.5*(mean(pic_1(g))+mean(pic_1(g)));
%     done = abs(T-Tn)<0.1;
%     T=Tn;
% end
%  �����ж�  139ò���ǱȽϺõ���ֵ
%  �������ͼ��ָ�

for i=1:h
    for j=1:w
        if abs(pic_1(i, j)-139) > 0 
            pic_1(i, j) = 0;
        end
    end
end
imshow(pic_1);

%%
%  �ָ�ͼƬ
[h, w] = size(pic_1);
for j = 1:w
   t = 0;
   for i = 1:h
       if pic_1(i, j) == 0
           t = t + 1;
       end
       if t > h-2
          pic_1(:, j) =250;
       end
   end
end
imshow(pic_1);

%% 
%  �ֱ�����ͼƬ�ļ�
num = 5;%������5������
start_num = 0;
state =false;
%��ʼ�ͽ����ĵط�
sta=0;
en=0;
result = struct;
for j = 1:w-1
    if pic_1(1,j)==250 && pic_1(1,j+1)~=250
       sta = j+1;
       start_num =start_num+1;
       state=true;
    end
    if pic_1(1,j)~=250 && pic_1(1,j+1)==250 && state==true
       en = j;
       tmp = pic_1(:,sta:en);
       %result.pic(start_num)=zeros(h,en-sta);
       result(start_num).pic=tmp;
       state=false;
       
    end
end
%%
%  ��ʵ�ǿ�������ͬʱ���зָ��
%  ��ʾ�ָ�õ�ͼƬ����
for i=1:1:5
   %imshow(result(i).pic) ;
   result(i).pic=double(result(i).pic);
end

qq=zeros(h,20);
for i=1:5
   max_lie = 20;
   [h,w]=size(result(i).pic);
   for j=1:max_lie-w
       result(i).pic = [result(i).pic zeros(h,1)];
   end
   figure();
   imshow(result(i).pic);
end
