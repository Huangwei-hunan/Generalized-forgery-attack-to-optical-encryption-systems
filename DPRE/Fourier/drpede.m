function output=drpede(A,R1,R2)
%DRPE in Fourier domain (decryption)
c1=fft2(A).*conj(R2);
output=ifft2(c1).*conj(R1);
output=abs(output);