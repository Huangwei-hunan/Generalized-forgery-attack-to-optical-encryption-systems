function output=drpefde(A,R1,R2,d1,d2)
%DRPE in Fresnel domain (decryption)
lamda=632e-9;
dx=8e-6;
c1=angular_spectrum(dx,lamda,A,-d2);
output=angular_spectrum(dx,lamda,c1.*conj(R2),-d1);
output=output.*conj(R1);
output=abs(output);