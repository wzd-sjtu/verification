%%
%  读入一张图片的原始矩阵
pic_1 = imread('1.png');
%  把这张图片显示出来
imshow(pic_1);

%%
%  将图片进行灰度化  避免颜色对识别造成影响
pic_1 = rgb2gray(pic_1);
%  再把图片显示出来
figure();
imshow(pic_1);
%%
%  分离背景
%  在这里应当先进行阈值分割
[h, w] = size(pic_1);
% %  全局阈值
% T = 0.5*(min(pic_1(:))+max(pic_1(:)));
% done = false;
% 
% while ~done
%     %  获取大于坐标
%     g = pic_1>T;
%     Tn = 0.5*(mean(pic_1(g))+mean(pic_1(g)));
%     done = abs(T-Tn)<0.1;
%     T=Tn;
% end
%  经过判断  139貌似是比较好的阈值
%  方便进行图像分割

for i=1:h
    for j=1:w
        if abs(pic_1(i, j)-139) > 0 
            pic_1(i, j) = 0;
        end
    end
end
imshow(pic_1);

%%
%  分割图片
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
%  分别生成图片文件
num = 5;%这里有5个数字
start_num = 0;
state =false;
%开始和结束的地方
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
%  其实是可以左右同时进行分割的
%  显示分割好的图片类型
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
