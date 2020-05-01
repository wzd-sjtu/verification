%  这个是卷积函数 
%  core是卷积核，input是需要卷积运算的矩阵
function dst=conv_c(src,kernal)
    [sh sw]=size(src);
    [kh kw]=size(kernal);
    dh=sh-kh+1;
    dw=sw-kw+1;
    dst=zeros(dh,dw);
    for i=1:dh
        for j=1:dw
            dst(i,j)=sum(sum(kernal.*src(i:i+kh-1,j:j+kw-1)));
        end
    end
end