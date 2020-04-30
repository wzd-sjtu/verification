%%
%  读入一张图片的原始矩阵  可以考虑使用运行节来分块运行
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

%  首先求得pic_1的图形矩阵大小  h=60,w=160，分别是图形的宽和高
[h, w] = size(pic_1);

% %  全局阈值
%  以下是求解阈值的过程，只不过不太重要，已经求好了
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

%  0表示纯黑，255表示白色，色块的灰度是由0-250的参数决定的

%  对图片矩阵里面的每一个位置进行判断，若灰度大于139，则直接变成纯黑
%  可以有效抑制噪声，同时分离出来图形的状况
for i=1:h
    for j=1:w
        if abs(pic_1(i, j)-139) > 0 
            pic_1(i, j) = 0;
        end
    end
end
imshow(pic_1);

%%
%  分割图片 本质上是获取各个图片之间的完全纯黑部分，将他们变成白色，从而分离图形
[h, w] = size(pic_1);
for j = 1:w
   t = 0;
   for i = 1:h
       if pic_1(i, j) == 0
           t = t + 1;
       end
       if t > h-2
          %  一类数据里面，一共有60个元素，如果有58个元素是纯黑的，那么这一列就被视为空间间隔
          %  变成纯白色  表示一列数据变成了纯白色
          pic_1(:, j) =250;
       end
   end
end
%  可以看到完成了划分
imshow(pic_1);

%% 
%  分别生成图片文件
num = 5;%这里有5个数字  表示验证码有5个数字

%  
start_num = 0;
%  表示是否的一个状态
state =false;
%  下面这个参数是每一个字符开始坐标和结束坐标（列坐标）
sta=0;
en=0;

% 存储数据的一个结构体，在这里存储生成的矩阵
result = struct;

for j = 1:w-1
    %  前一个元素是纯白 之后一个元素不是纯白，表示一个字符开始
    if pic_1(1,j)==250 && pic_1(1,j+1)~=250
       %  开始坐标
       sta = j+1;
       %  存储这是第几个字符  比如第一个字符标号为1
       start_num =start_num+1;
       %  状态变量，表示进入了字符的区间
       state=true;
    end
    %  如果前一个字符不是纯白而后一个字符是纯白，并且在字符区间里面
    if pic_1(1,j)~=250 && pic_1(1,j+1)==250 && state==true
       %  结尾坐标
       en = j;
       %  将这一部分矩阵存储到tmp变量里面
       tmp = pic_1(:,sta:en);
       %result.pic(start_num)=zeros(h,en-sta);
       
       %  将数据存储到结构体里面，具体可以点开变量进行识别
       result(start_num).pic=tmp;
       %  字符区间状态变成false，表示不再是字符区间了，防止误判
       state=false;
       
    end
end
%  对于生成的矩阵图形化显示出来
for i=1:5
    figure;
    imshow(result(i).pic);
end
%%
%  其实是可以左右同时进行分割的
%  显示分割好的图片类型
for i=1:1:5
   %imshow(result(i).pic) ;
   result(i).pic=double(result(i).pic);
end


%  下面是对生成的图片进行标准化，统一变成20*60的规格，具体逻辑很好懂
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
