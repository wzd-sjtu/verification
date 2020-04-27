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
%  �����������ʾ
%  �趨�����Ϊ4*4����  Ч������  ���Ч��
%  ����  ������������ֵĽ�� emm
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

% �����Կ���������˾������һЩ��ֵĶ���