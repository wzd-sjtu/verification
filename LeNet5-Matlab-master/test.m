c_num=0;
mse=0;
for img_ids=1:100:test_num
    %for img_id=1:train_num
    fprintf('���ڲ��Ե�%d--%d��ͼƬ...\n',img_ids,img_ids+99);
    for img_id=img_ids:img_ids+99
        %fprintf('���ڲ��Ե�%d-%d��ͼƬ...\n',epoch,img_id);
        img=data_test(:,:,img_id);
        %img=data_train(:,:,img_id);
        label=stdout_test(:,img_id);
        %label=stdout_train(:,img_id);
        forward;
        mse=mse+norm(label-tmp_neuron_output);
        [v,pos]=max(tmp_neuron_output);
        %if label_test(img_id)==pos-1
        if label_test(img_id)==pos-1
            c_num=c_num+1;
        end
    end
end
acc=c_num/test_num;
%acc=c_num/train_num;
%fprintf('���Ϊ��%f\n',mse);
%plot(epoch,acc,'*');drawnow;hold on;

fid=fopen('result.txt','a+');
fprintf(fid,'��%d��ѵ���������׼ȷ��Ϊ%f\n',epoch,acc);
fclose(fid);