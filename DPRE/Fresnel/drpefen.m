function output=drpefen(A,R1,R2,d1,d2)
%DRPE in Fresnel domain (encryption)
lamda=632e-9;
dx=8e-6;
%R1=ones(32,32)
%R2=ones(32,32);
c1=angular_spectrum(dx,lamda,A.*R1,d1);
output=angular_spectrum(dx,lamda,c1.*R2,d2);