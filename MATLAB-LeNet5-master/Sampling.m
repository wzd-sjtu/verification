function S = Sampling(I)
%% ��I���гػ�������mean-pool.
[m, n] = size(I);
S=(I(1:2:m-1,1:2:n-1)+I(2:2:m,1:2:n-1)+I(1:2:m-1,2:2:n)+I(2:2:m,2:2:n))/4;
end
