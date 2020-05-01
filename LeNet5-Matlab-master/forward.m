%lenet5��ǰ�򲿷֣�����Ϊ32*32����չMNISTͼimg

%----------------------------------c1��----------------------------------
for i=1:num_map_c1
    neuron_c1(:,:,i)=tanh(conv_2d(img,wt_c1(:,:,i))+bias_c1(i));%c1��ĵ�i��map����ԭͼimg���i������˵ľ�������ƫ���پ���tanh
end

%----------------------------------s2��-----------------------------------
for i=1:num_map_s2
    neuron_s2(:,:,i)=tanh(pooling(neuron_c1(:,:,i),wt_s2(i))+bias_s2(i));
end

%----------------------------------c3��----------------------------------
neuron_c3=neuron_c3*0;
for j=1:num_map_c3
    for i =1:num_map_s2
        if tbl(i,j)==1
            neuron_c3(:,:,j)=neuron_c3(:,:,j)+conv_2d(neuron_s2(:,:,i),wt_c3(:,:,i,j));
        end
    end
    neuron_c3(:,:,j)=tanh(neuron_c3(:,:,j)+bias_c3(j));
end

%---------------------------------s4��-----------------------------------
for i=1:num_map_s4
    neuron_s4(:,:,i)=tanh(pooling(neuron_c3(:,:,i),wt_s4(i))+bias_s4(i));
end

%---------------------------------c5��-----------------------------------
neuron_c5=neuron_c5*0;
for j=1:num_map_c5
    for i =1:num_map_s4
        neuron_c5(:,:,j)=neuron_c5(:,:,j)+conv_2d(neuron_s4(:,:,i),wt_c5(:,:,i,j));
    end
    neuron_c5(:,:,j)=tanh(neuron_c5(:,:,j)+bias_c5(j));
end

%--------------------------------output��---------------------------------
tmp_neuron_c5=reshape(neuron_c5,1,120);
for i=1:num_map_output
    neuron_output(:,:,i)=tmp_neuron_c5*wt_output(:,i);
    neuron_output(:,:,i)=tanh(neuron_output(:,:,i)+bias_output(i));
end
tmp_neuron_output=reshape(neuron_output,10,1);






