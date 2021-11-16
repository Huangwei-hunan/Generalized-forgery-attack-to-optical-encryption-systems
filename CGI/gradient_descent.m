function f_masks = gradient_descent(B,o_intensity)

image_num = size(B,3);             %image number
numpixel = size(B(:,:,1),1);       %image size
num_pattern = size(o_intensity,1);

%% image reshape
for i=1:image_num
    f_pattern(i,:) =reshape(B(:,:,i),1,[]); 
end
%% get fake masks
fprintf("Begin to get fake phase masks using gradient descent method...\n");
h = waitbar(0,'optimizing mask...');
for i = 1:num_pattern
    waitbar(i/num_pattern);
    I = o_intensity(i,:)';
    f_masks(:,:,i) = fun_fakemulp3(f_pattern,I);
end
close(h);


%% image reconstructing


