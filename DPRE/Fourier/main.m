%%%%%%%%%%%%%%%
% DPRE in fourier domain 
%%%%%%%%%%%%%%%
clc;
close all;
clear;

%% 
N=2;            %mask number
numpixel = 64; %image size
iter_max=1000;
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
    targetall(:,:,i) = drpeen(original_image(:,:,i),orgphasemask(:,:,1),orgphasemask(:,:,2));
    temp = targetall(:,:,i);
end


%% iteration algorithm 
fakephasemask=exp(1i*2*pi*rand(numpixel,numpixel,N));
for iter=1:iter_max
    iter;
    for ii=1:N 
        summation=0;
        for mm=1:image_num 
            inputpat=abs(fake_image(:,:,mm));
            temp1=inputpat;
            if ii>1
                for kk=1:(ii-1)
                    temp1=fft2(temp1.*fakephasemask(:,:,kk));
                end
            end
            outputpat=targetall(:,:,mm);
            temp2=outputpat;
            temp2=fft2(temp2);
            if ii<N
                for kk1=(ii+1):N
                    kk=(N+ii+1)-kk1;
                    temp2=temp2.*conj(fakephasemask(:,:,kk));
                    temp2=ifft2(temp2);
                end
            end
            maskcom=temp2.*conj(temp1);
            summation=summation+maskcom;
        end
        fakephasemask(:,:,ii)=exp(1i*angle(summation));
    end
end

%% decryption
for i = 1:image_num
    o_result(:,:,i) = drpede(targetall(:,:,i),orgphasemask(:,:,1),orgphasemask(:,:,2));
end

for i=1:image_num
    f_result(:,:,i) = drpede(targetall(:,:,i),fakephasemask(:,:,1),fakephasemask(:,:,2));
end

figure;
for i =1:image_num
    subplot(image_num,4,4*i-3);imshow(original_image(:,:,i));title("original image");
    subplot(image_num,4,4*i-2);imshow(o_result(:,:,i));title("reconstruction result");
    subplot(image_num,4,4*i-1);imshow(fake_image(:,:,i));title("fake image");
    subplot(image_num,4,4*i);imshow(f_result(:,:,i));title("reconstruction result");
end








