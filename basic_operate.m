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
%  卷积核作用演示
%  设定卷积核为4*4矩阵  效果是锐化  提高效果
%  哈哈  最终生成了奇怪的结果 emm
core = [-1 -1 -1
         -1 8 -1
         -1 -1 -1];
core_size = 3;
det = core_size-1;
[xx, yy] = size(pic_1);
x = round(xx/core_size);
y = round(yy/core_size);

next_pic = zeros(x, y);
pic_special = double(pic_1);
for i = 1:1:x
    for j = 1:1:y
        x_range = i:i+det;
        y_range = j:j+det;
        res1 = pic_special(x_range, y_range).*core;
        res = sum(sum(res1));
        next_pic(i, j) = res;
    end
end
figure();
imshow(next_pic);

% 最后可以看到，卷积核卷积出了一些奇怪的东西