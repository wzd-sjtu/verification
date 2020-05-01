%%
close all;
clear all;
%  ����һ��ͼƬ��ԭʼ����  ���Կ���ʹ�����н����ֿ�����
pic_1 = imread('test.png');
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

%  �����ʹ�ñ���ɫ�ָ�  �򻯹���

max_num=mode(mode(pic_1));

pic_1(pic_1~=max_num) = 250;
pic_1(pic_1==max_num) = 0;
imshow(pic_1);


%%
%ȥ��������
[h,w] = size(pic_1);
tmp_pic = padarray(pic_1,[1 1]);
for i=2:h+1
    for j=2:w+1
        q=sum(sum(tmp_pic(i-1:i+1,j-1:j+1)));
        if sum(sum(tmp_pic(i-1:i+1,j-1:j+1)==250))==1
           pic_1(i-1,j-1)=0; 
        end
    end
end

imshow(pic_1);
%%
%  ��������С��ֵ��������û��������

% %  �������pic_1��ͼ�ξ����С  h=60,w=160���ֱ���ͼ�εĿ�͸�
% [h, w] = size(pic_1);
% 
% % %  ȫ����ֵ
% %  �����������ֵ�Ĺ��̣�ֻ������̫��Ҫ���Ѿ������
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
% %  �����ж�  139ò���ǱȽϺõ���ֵ
% %  �������ͼ��ָ�
% 
% %  0��ʾ���ڣ�255��ʾ��ɫ��ɫ��ĻҶ�����0-250�Ĳ���������
% 
% %  ��ͼƬ���������ÿһ��λ�ý����жϣ����Ҷȴ���139����ֱ�ӱ�ɴ���
% %  ������Ч����������ͬʱ�������ͼ�ε�״��
% for i=1:h
%     for j=1:w
%         if abs(pic_1(i, j)-T) > 0 
%             pic_1(i, j) = 0;
%         end
%     end
% end
% imshow(pic_1);

% %%
% %  �ָ�ͼƬ �������ǻ�ȡ����ͼƬ֮�����ȫ���ڲ��֣������Ǳ�ɰ�ɫ���Ӷ�����ͼ��
% [h, w] = size(pic_1);
% for j = 1:w
%    t = 0;
%    for i = 1:h
%        if pic_1(i, j) == 0
%            t = t + 1;
%        end
%        if t > h-2
%           %  һ���������棬һ����60��Ԫ�أ������58��Ԫ���Ǵ��ڵģ���ô��һ�оͱ���Ϊ�ռ���
%           %  ��ɴ���ɫ  ��ʾһ�����ݱ���˴���ɫ
%           pic_1(:, j) =250;
%        end
%    end
% end
% %  ���Կ�������˻���
% imshow(pic_1);

%% 
%  �ֱ�����ͼƬ�ļ�
num = 5;%������5������  ��ʾ��֤����5������
[h, w] = size(pic_1);
%  
start_num = 0;
%  ��ʾ�Ƿ��һ��״̬
state =false;
%  �������������ÿһ���ַ���ʼ����ͽ������꣨�����꣩
sta=0;
en=0;

% �洢���ݵ�һ���ṹ�壬������洢���ɵľ���
result = struct;

for j = 1:w-1
    %  ǰһ��Ԫ���Ǵ��� ֮��һ��Ԫ�ز��Ǵ��ף���ʾһ���ַ���ʼ
    if all(pic_1(:,j)==zeros(h,1)) && state==false
       %  ��ʼ����
       sta = j;
       %  �洢���ǵڼ����ַ�  �����һ���ַ����Ϊ1
       start_num =start_num+1;
       %  ״̬��������ʾ�������ַ�������
       state=true;
    end
    %  ���ǰһ���ַ����Ǵ��׶���һ���ַ��Ǵ��ף��������ַ���������
    if any(pic_1(:,j)~=zeros(h,1)) && state==true
       %  ��β����
       en = j;
       %  ����һ���־���洢��tmp��������
       line = round((sta+en)/2);
       %result.pic(start_num)=zeros(h,en-sta);
       
       %  �����ݴ洢���ṹ�����棬������Ե㿪��������ʶ��
       result(start_num).line=line;
       %  �ַ�����״̬���false����ʾ�������ַ������ˣ���ֹ����
       state=false;
       
    end
end
result(start_num).line=round((sta+w)/2);
%  ����ѷָ��ͼ��չʾ����

for i=1:start_num-1
   result(i).pic=pic_1(:,result(i).line:result(i+1).line);
   
end
for i=1:start_num
    figure;
    imshow(result(i).pic);
end
%%
%  ��ʵ�ǿ�������ͬʱ���зָ��
%  ��ʾ�ָ�õ�ͼƬ����
for i=1:1:5
   %imshow(result(i).pic) ;
   result(i).pic=double(result(i).pic);
end


%  �����Ƕ����ɵ�ͼƬ���б�׼����ͳһ���50*40�Ĺ�񣬾����߼��ܺö�
qq=zeros(h,40);
for i=1:5
   max_lie = 40;
   [h,w]=size(result(i).pic);
   for j=1:max_lie-w
       result(i).pic = [result(i).pic zeros(h,1)];
   end
   figure();
   imshow(result(i).pic);
end
