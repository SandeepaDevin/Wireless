clear all;
N=10^4;
N2=1000;
ES=logspace(-1,1,10); %SNR from -10dB to 10 dB, N0 is set to 1

for jj=1:length(ES)
   Es=ES(jj);
   %display(jj);
   BER_mrc=0;
   BER_eql=0;
   BER_selcom=0;
   
   for ii=1:N2
   DT=randi(1,1,N); %random integers 0 to 1
   BT=sqrt(Es).*(2.*DT-1); % map to -1 and +1 - transmit symbol
   
   hh1=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N))); % three different components from three different channels received
   hh2=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N)));
   hh3=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N)));
   
   
   nn1=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N))); % different noises added.
   nn2=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N))); % in different channels
   nn3=sqrt(1/2)*(randn(1,N)+1i*(randn(1,N)));
  
   % 3-Maximum ratio combiner
   Rec_mrc=conj(hh1).*(BT.*hh1+nn1)+conj(hh2).*(BT.*hh2+nn2)+conj(hh3).*(BT.*hh3+nn3);
   dec_mrc=Rec_mrc>0;
   BER_mrc=BER_mrc+mean(abs(dec_mrc-DT));

   
   %equal gain combiner - sum of all received
   Eql_gain= exp(-1i*angle(hh1)).*(BT.*hh1+nn1) +exp(-1i*angle(hh2)).*(BT.*hh2+nn2) +exp(-1i*angle(hh3)).*(BT.*hh3+nn3);
   equal_gain=Eql_gain>0;
   BER_eql=BER_eql+mean(abs(equal_gain-DT));    
   
   %selection combiners
  maxxa=[ abs(hh1) abs(hh2) abs(hh3)];
  maximum_value= max(maxxa);
  
  if maximum_value==abs(hh1)   
       sel_comb=(1./hh1).*(BT.*hh1 +nn1);
  elseif maximum_value==abs(hh2)
       sel_comb=(1./hh2).*(BT.*hh2 +nn2);
  else    
       sel_comb=(1./hh3).*(BT.*hh3 +nn3);
  end
   
   sel_co=sel_comb>0;
   BER_selcom=BER_selcom+mean(abs(sel_co-DT));
   
    end
    rh=Es;
    
    BER_fadingth(jj)=0.5*(1-sqrt(rh/(rh+1))); %theoritical fading
    BER_mrc2(jj)=BER_mrc/N2;    %MRC receiver plot
    BER_eql2(jj)=BER_eql/N2;    %equal-gain plot
    BER_sel2(jj)=BER_selcom/N2; %selection combiner
 end
% 
 semilogy(10*log10(ES),BER_mrc2,'r');
 axis([-10 10 10^-6 1]);
 hold on;
 semilogy(10*log10(ES),BER_fadingth,'b');
 semilogy(10*log10(ES),BER_eql2,'k');
 semilogy(10*log10(ES),BER_sel2,'--m');
% 
legend('3-Max ratio combiner','theoritical fading','equal gain','selection combiner','Location','SouthEast')
