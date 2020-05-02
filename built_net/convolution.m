% 传统意义上的卷积
% function result = convolution(image,core)
%     [imageSize,~] = size(image);
%     [coreSize,~] = size(core);
%     result = zeros(imageSize-(coreSize-1));
%     for rowIndex = 1:size(result,1)
%         for colIndex = 1:size(result,1)
%             result(rowIndex,colIndex) = sum(sum(double(image(rowIndex:rowIndex+coreSize-1,colIndex:colIndex+coreSize-1)).*double(core)));
%         end
%     end
% end

function result = convolution(image,core)
    [imageSize,~] = size(image);
    coreSize = 5;
    result = zeros(imageSize-(coreSize-1));
    for rowIndex = 1:size(result,1)
        for colIndex = 1:size(result,1)
            for x = 1:5
                for y = 1:5
                    result(rowIndex,colIndex) = result(rowIndex,colIndex) + image(rowIndex + x - 1, colIndex + y - 1)*double(core(1,1,x,y));
                end
            end
        end
    end
end