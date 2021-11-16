function [fakepattern] = fun_fakemulp3(fakeimage,intensity)

sizetrain=size(fakeimage,1);
pixel=sqrt(size(fakeimage,2));    %pixel
fakepattern=rand(pixel,pixel);    %fake mask
maxieration=300;                  %number of iterations
learnrate=0.001*ones(pixel);
m=0;
for iter=1:maxieration
    temp=0;
    for ii=1:sizetrain
        learnrate=0.001*ones(pixel);
        temp1=reshape(fakeimage(ii,:),[pixel pixel]);
        output=sum(sum(temp1.*fakepattern(:,:)));
        target=intensity(ii,1);
        weight1(:,:)=fakepattern(:,:)+(target-output)*learnrate.*temp1;
        learnrate(weight1>1)=0;
        learnrate(weight1<0)=0;
        fakepattern(:,:)=fakepattern(:,:)+(target-output)*learnrate.*temp1;
        m=m+1;
        temp = temp+norm(target-output);
    end 
    temp=temp/sizetrain;
    if(temp<0.5)                     % threshold
        break;
    end
end
end