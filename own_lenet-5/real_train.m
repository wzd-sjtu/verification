for j=1:3
    for i=1:train_number
        %  ��������label����Ҫ��ȡ������emm �������ô�㣿
        sign=label_data(1,i);
        label=zeros(10,1);
        label(fix(sign)+1)=1;


        img=imread([file_path,num2str(i-1),'.png']);
        img=double(rgb2gray(img));
        %img(img==255)=0;
        lenet_5;
    end
end