%%
%  ��������ʾ��������õģ����Բ��ù�
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
%  ������һ��ͼƬ
%  ������������  ͼƬ�������
pic_2 = imread('2.jpg');
pic_2 = rgb2gray(pic_2);
figure();
imshow(pic_2);

core(pic_2);
%%
%  �����������ʾ
%  �趨�����Ϊ4*4����  Ч������  ���Ч��
%  �����Ӧ���Ƕ�ÿһ���㶼���в������Ǻ����
%  ����  ������������ֵĽ�� emm
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
% �����Կ���������˾������һЩ��ֵĶ���
