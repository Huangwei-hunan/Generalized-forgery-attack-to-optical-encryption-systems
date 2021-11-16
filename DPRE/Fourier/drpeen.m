function output=drpeen(A,R1,R2)
%DRPE in Fourier domain (encryption)
c1=fft2(A.*R1);
output=ifft2(c1.*R2);
