clear all;
N=10^3;
N2=1000;
ES=logspace(-1,1,10); %SNR from -10dB to 10 dB, N0 is set to 1

K1=0; K2=3; K3=10;
k1=10.^((0.1)*K1); k2=10.^((0.1)*K2); k3=10.^((0.1)*K3);

vark1=0.8/(k1+1); vark2=0.5/(k2+1);  vark3=0.5/(k3+1);
muk1=sqrt((2*k1*vark1)/2); muk2=sqrt((2*k2*vark2)/2); muk3=sqrt((2*k3*vark3)/2);

for jj=1:length(ES)
   Es=ES(jj);
   %display(jj);
   BER_ray=0;
   BER_K1=0; BER_K2=0;BER_K3=0;
   
   for ii=1:N2
   DT=randi(1,1,N); %random integers 0 to 1
   BT=sqrt(Es).*(2.*DT-1);
   
   hh=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N))); % channel
   hhk1=sqrt(vark1)*(randn(1,N)+muk1+1i*(randn(1,N)+muk1)); % channel
   hhk2=sqrt(vark2)*randn(1,N)+muk2+1i*(sqrt(vark2)*randn(1,N)+muk2); % channel
   hhk3=sqrt(vark3)*randn(1,N)+muk3+1i*(sqrt(vark3)*randn(1,N)+muk3); % channel
  
   nn=sqrt(1/2)*(randn(1,N)+1i*randn(1,N));
   nn1=sqrt(1/2)*(randn(1,N)+1i*randn(1,N)); % noise
   nn2=sqrt(1/2)*(randn(1,N)+1i*randn(1,N));
   nn3=sqrt(1/2)*(randn(1,N)+1i*randn(1,N));

   yy=BT.*hh+nn;
   yyk1=BT.*hhk1+nn1;
   yyk2=BT.*hhk2+nn2;
   yyk3=BT.*hhk3+nn3;%receive with noise
   %yyn=BT+nn; %transmit without noise
   
   zz=conj(hh).*yy;
   zz1=conj(hhk1).*yyk1;
   zz2=conj(hhk2).*yyk2;
   zz3=conj(hhk3).*yyk3;
   
   dec_ray=zz>0;
   dec_K1=zz1>0;   %pskdemod, qamdemod
   dec_K2=zz2>0;
   dec_K3=zz3>0;
   %dec_noise=yyn>0;
   
   BER_ray=BER_ray+mean(abs(dec_ray-DT));
   BER_K1=BER_K1+mean(abs(dec_K1-DT));
   BER_K2=BER_K2+mean(abs(dec_K2-DT));
   BER_K3=BER_K3+mean(abs(dec_K3-DT));
   %BER_noise=BER_noise+mean(abs(dec_noise-DT));
   end
   rh=Es;
   BER_ray1(jj)=BER_ray/N2;
   BER_K11(jj)=BER_K1/N2;
   BER_K22(jj)=BER_K2/N2;
   BER_K33(jj)=BER_K3/N2;
   %BER_noise2(jj)=BER_noise/N2;
   %BER_noiseth(jj)=qfunc(sqrt(2*Es));
end

%plot the noise and fading of simulation
semilogy(10*log10(ES),BER_K11,'r');
axis([-10 10 10^-6 1]);
hold on;
semilogy(10*log10(ES),BER_K22,'b');
semilogy(10*log10(ES),BER_K33,'g');
semilogy(10*log10(ES),BER_ray1,'m');
title('rician for different K-factors')
legend('Rician K=0dB','Rician K=3dB','Rician K=10dB','Rayleigh','Location','SouthEast')
