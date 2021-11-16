clc;
close all;
clear;
numpixel = 64;              %image size(width and height)
samplingRatio = 0.8;        %sampling ratio
para.tol = 1e-2;            %TV Iterative median condition
para.min_iter = 30;         % minimum times of iteration
para.x0flag = 0;            % initialization flag of the reconstructed image 0: all one; 1: pinv(A)*b.

image_num=2;                % number of image using for encryption

%% Read images
o_image_path = dir('original_image\*.png');
for i=1:image_num
    original_image(:,:,i) = imresize(im2double(imread([o_image_path(i).folder,'\',o_image_path(i).name])),[numpixel,numpixel],'bilinear');
end

f_image_path = dir('fake_image\*.png');
for i=1:image_num
    fake_image(:,:,i) = imresize(im2double(imread([f_image_path(i).folder,'\',f_image_path(i).name])),[numpixel,numpixel],'bilinear');
end

%% original masks generating
num_pattern =round(samplingRatio * numpixel * numpixel); % number of illumination patterns
o_masks =  rand(numpixel,numpixel,num_pattern);

%% encrypting
for i=1:image_num
    temp= sum(sum(repmat(original_image(:,:,i),[1,1,num_pattern]).*o_masks));
    o_intensity(:,i) = reshape(temp,[],1);
end

%% using iterative gradient descent algorithm genreate fake masks
f_masks = gradient_descent(fake_image,o_intensity);


%% reconstructed image
for i=1:image_num
    [image_result_o(:,:,i),~] = image_reconstruction(o_masks,o_intensity(:,i),para);
end

for i=1:image_num
    [image_result_g(:,:,i),~] = image_reconstruction(f_masks,o_intensity(:,i),para);
end


%% image_reveal
figure;
for i =1:image_num
    subplot(image_num,4,4*i-3);imshow(original_image(:,:,i));title("original image");
    subplot(image_num,4,4*i-2);imshow(image_result_o(:,:,i));title("reconstruction result");
    subplot(image_num,4,4*i-1);imshow(fake_image(:,:,i));title("fake image");
    subplot(image_num,4,4*i);imshow(image_result_g(:,:,i));title("reconstruction result");
end


% %% image save
% for i =1:image_num
%     imwrite(image_result_o(:,:,i),['result/original_',num2str(i),'.png']);
%     imwrite(image_result_g(:,:,i),['result/fake_',num2str(i),'.png']);
% end






