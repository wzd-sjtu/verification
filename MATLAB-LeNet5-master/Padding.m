function P = Padding(I, n)
%% �Ծ�����в��㣬����Χ��nȦ.
P = zeros(size(I) + 2 * n);
P(1+n:end-n, 1+n:end-n) = I;
end
