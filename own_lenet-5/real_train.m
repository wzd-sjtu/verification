
for i=1:10000
    %  ��������label����Ҫ��ȡ������emm �������ô�㣿
    sign=label_data(i,1);
    %disp(sign);
    label=zeros(10,1);
    label(fix(sign)+1)=1;
    
    if mod(i,100)==0
        disp(i);
    end

    img=imread([file_path,num2str(i-1),'.png']);
    %img(img==255)=0;   
    img=double(rgb2gray(img));
    lenet_5;
end
