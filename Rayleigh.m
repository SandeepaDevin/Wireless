N = 1000000;
p=1;    %variance
X1=p*randn([1 N]); %zero-mean inphase
X2=p*randn([1 N]);  %zero-mean quadrature
r= abs(X1+1i*(X2)); %simulation pdf rayleigh

x_step=1/500;   %bin size
x=0:x_step:5;   %no of bins 
n=hist(r,x);

r1=(n./(N*x_step)); %normalize histogram to summation become one
r2=(x/(p^2)).*exp(-(x.^2)/(2*p^2)); %theoritical expression

%%%%%%%%%%%%%%%%% PDF SIMULATION %%%%%%%%%%%%%%%%%%%%%%%

%plot simulated one
plot(x,r1)
grid
hold
%plot theoritical
plot(x,r2,'r')
hold off

%%%%%%%%%%%%%%% CDF SIMULATION %%%%%%%%%%%%%%%%%%%%

%cdfplot(r1) didn't work

rx=0.01+(cumsum(r1)./1*x_step);  %simulation cdf plot 0.01 was added so overlap be visible.
plot(x,rx,'r')
grid
hold on
ry=1-exp(-(x.^2)/(2*p^2)); %theoritical cdf fn
plot(x,ry,'b')
hold off









