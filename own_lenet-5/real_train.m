
for i=1:10000
    %  这里的这个label是需要读取进来的emm 这个该怎么搞？
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
