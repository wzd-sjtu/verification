%%
%  下面是测试模块
right=0;
for i=1:1:100
    sign=label_data(1,i);
    img=imread([file_path,num2str(i-1),'.png']);
    img=double(rgb2gray(img));

    [~,num]=max(tmp_neure_output);
    predict_num=num-1;
    if predict_num==sign
       right=right+1; 
    end
end