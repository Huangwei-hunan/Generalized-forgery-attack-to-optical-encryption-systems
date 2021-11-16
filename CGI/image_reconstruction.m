function [image_result,runTime] = image_reconstruction(masks,intensity,para)

[row,col,m] = size(masks);
P = reshape(masks, [row*col, m]);
P = P';
if para.x0flag == 1
    para.x0 = pinv(P)*intensity;
else
    para.x0 = ones(row * col,1);     
end

fprintf('Begin reconstruction of total variation (TV) compressive sensing. \n');
tic
[im_r_TV, ~] = fun_SPI_R_TV(masks,intensity, para);
runTime= toc;
image_result= im_r_TV;
end






