function B = rot180(A)
% ��������ת180��.
[m,n] = size(A);
B = A(m:-1:1,n:-1:1);
end
