function m = softmax(m)
%% softmax ������������ֵӳ�䵽[0, 1].
em = exp(m);
m = em./sum(em);
end
