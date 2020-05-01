%%
%  这里是演示卷积核作用的，可以不用管
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
%  导入另一张图片
%  可以显著看到  图片完成了锐化
pic_2 = imread('2.jpg');
pic_2 = rgb2gray(pic_2);
figure();
imshow(pic_2);

core(pic_2);
%%
%  卷积核作用演示
%  设定卷积核为4*4矩阵  效果是锐化  提高效果
%  卷积核应当是对每一个点都进行操作才是合理的
%  哈哈  最终生成了奇怪的结果 emm
function core(pic_1)
    core_matrix = [1 1 1
             1 -7 1
             1 1 1];
    core_matrix2 = [-1 -1 -1
                     -1 9 -1
                     -1 -1 -1]
    core_matrix3 = [2 0 0
                    0 -1 -1
                    0 0 -1];
    core_size = 3;
    det = core_size-1;
    [xx, yy] = size(pic_1);
    x = round(xx/core_size);
    y = round(yy/core_size);

    next_pic = zeros(xx, yy);
    pic_special = double(pic_1);
    for i = 1:1:xx-det
        for j = 1:1:yy-det
            x_range = i:i+det;
            y_range = j:j+det;
            res1 = pic_special(x_range, y_range).*core_matrix3;
            res = sum(sum(res1));
            next_pic(i, j) = res;
        end
    end
    figure();
    imshow(next_pic);
end
% 最后可以看到，卷积核卷积出了一些奇怪的东西
