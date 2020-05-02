%%
%  下面是测试模块
right=0;
file_path='image/';
label_data=xlsread('label_complex.xls');

for i=1:1000
    if mod(i,100)==0
        disp(i)
    end
    sign=label_data(i,1);
    img=imread([file_path,num2str(i-1),'.png']);
    img(img==255)=0;   
    img=double(rgb2gray(img));

    test;
    [~,num]=max(tmp_neure_output);
    predict_num=num-1;
    if predict_num==sign
       right=right+1; 
    end
    
end
% disp(sign)
% disp(predict_num)