clear all;
N=10^4;
N2=1000;
ES=logspace(-1,1,10); %SNR from -10dB to 10 dB, N0 is set to 1

for jj=1:length(ES)
   Es=ES(jj);
   %display(jj);
   BER_fading=0;
   BER_noise=0;
   
   for ii=1:N2
   DT=randi(1,1,N); %random integers 0 to 1
   BT=sqrt(Es).*(2.*DT-1); % map to -1 and +1 - transmit symbol
   hh=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N))); % channel
   
   nn=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N))); % noise
   
   yy=BT.*hh+nn; %trasnmit with noise
   
   yyn=BT+nn; %transmit without noise
   
   zz=conj(hh).*yy;
   
   dec_fading=zz>0; %pskdemod, qamdemod
  
   dec_noise=yyn>0;
   
   BER_fading=BER_fading+mean(abs(dec_fading-DT));
   
   BER_noise=BER_noise+mean(abs(dec_noise-DT));
   end
   rh=Es;
   BER_fading2(jj)=BER_fading/N2;
   %BER_mrc2(jj)=BER_mrc/N2;
   BER_fadingth(jj)=0.5*(1-sqrt(rh/(rh+1)));
   BER_noise2(jj)=BER_noise/N2;
   BER_noiseth(jj)=qfunc(sqrt(2*Es));
end

%plot the noise and fading of simulation
semilogy(10*log10(ES),BER_noise2,'r');
axis([-10 10 10^-6 1]);
hold on;
semilogy(10*log10(ES),BER_fading2,'b');


%plotting the noise and fading of theoritical
semilogy(10*log10(ES),BER_noiseth,'ko');
semilogy(10*log10(ES),BER_fadingth,'ko');
legend('noise','fading')
