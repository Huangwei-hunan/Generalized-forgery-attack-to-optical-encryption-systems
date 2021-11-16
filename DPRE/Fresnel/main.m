%%%%%%%%%%%%%%%
% DPRE in Fresnel domain 
%%%%%%%%%%%%%%%
clc;
close all;
clear;

%% 
N=2;            %mask number
numpixel = 64; %image size
iter_max=1000;
dist=0.05;
image_num=1;  % number of encryption images.
%% read image
o_image_path = dir('../original_image/*.png');
for i=1:image_num
    original_image(:,:,i) = imresize(im2double(imread([o_image_path(i).folder,'\',o_image_path(i).name])),[numpixel,numpixel],'bilinear');

end

f_image_path = dir('../fake_image/*.png');
for i=1:image_num
    fake_image(:,:,i) = imresize(im2double(imread([f_image_path(i).folder,'\',f_image_path(i).name])),[numpixel,numpixel],'bilinear');
end

%% original masks
orgphasemask = exp(1i*2*pi*rand(numpixel,numpixel,N));
for i=1:image_num
    targetall(:,:,i) = drpefen(original_image(:,:,i),orgphasemask(:,:,1),orgphasemask(:,:,2),dist,dist);
    temp = targetall(:,:,i);
end


%% iteration algorithm 
fakephasemask=exp(1i*2*pi*rand(numpixel,numpixel,N));
for iter=1:iter_max
    for ii=1:N 
        summation=0;
        for mm=1:image_num
        inputpat=abs(fake_image(:,:,mm));
        temp1=inputpat;
        if ii>1
            for kk=1:(ii-1)
            temp1=angular_spectrum(8e-6,632e-9,temp1.*fakephasemask(:,:,kk),dist);
            end
        end
        outputpat=targetall(:,:,mm);
        temp2=outputpat;
        if ii<N
            for kk1=(ii+1):N
                kk=(N+ii+1)-kk1;
                temp2=angular_spectrum(8e-6,632e-9,temp2,-dist);
                temp2=temp2.*conj(fakephasemask(:,:,kk));                
            end
        end
        temp2=angular_spectrum(8e-6,632e-9,temp2,-dist);
        maskcom=temp2.*conj(temp1);
        summation=summation+maskcom;
        end
        fakephasemask(:,:,ii)=exp(1i*angle(summation));
    end
end

%% decryption
for i = 1:image_num
    o_result(:,:,i) = drpefde(targetall(:,:,i),orgphasemask(:,:,1),orgphasemask(:,:,2),dist,dist);
end

for i=1:image_num
    f_result(:,:,i) = drpefde(targetall(:,:,i),fakephasemask(:,:,1),fakephasemask(:,:,2),dist,dist);
end

figure;
for i =1:image_num
    subplot(image_num,4,4*i-3);imshow(original_image(:,:,i));title("original image");
    subplot(image_num,4,4*i-2);imshow(o_result(:,:,i));title("reconstruction result");
    subplot(image_num,4,4*i-1);imshow(fake_image(:,:,i));title("fake image");
    subplot(image_num,4,4*i);imshow(f_result(:,:,i));title("reconstruction result");
end


%% reconstruction result save
for i =1:image_num
    imwrite(o_result(:,:,i),['result/original_',num2str(i),'.png']);
    imwrite(f_result(:,:,i),['result/fake_',num2str(i),'.png']);
end







