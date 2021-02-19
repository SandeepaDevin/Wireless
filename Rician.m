N = 1000000; 
var = 1/30;
mu1 = sqrt(15/32); %mean of inphase
mu2 = sqrt(15/32); %mean of quadrature

x1 = sqrt(var)*randn([1 N]) + mu1; %inphase
x2 = sqrt(var)*randn([1 N]) + mu2; %quadrature

y = x1 +(1i*x2); %simulated signal 
r = abs(y);

x_step = 1/1000;
x = 0:x_step:5;
n = hist(r,x);
r1 = (n./(N*x_step)); %simulated distribution after normalize

s = sqrt(mu1^2 + mu2^2);

r2 = (x/(var)).*exp(-(x.^2 + s^2)/(2*var)).*besseli(0,x*s/var); %theoritical distribution
K=(s^2)/2*var; %k factor

%%%%%%%%%%%%%%%%% PDF SIMULATION %%%%%%%%%%%%%%%%%%%%%%%

%plot simulated one
plot(x,r1)
grid
hold
%plot theoritical
plot(x,r2,'r')
hold off

%%%%%%%%%%%%%%% CDF SIMULATION %%%%%%%%%%%%%%%%%%%%

rx=(cumsum(r1)./1*x_step);  %simulation cdf plot 0.01 was added so overlap be visible.
plot(x,rx,'r')
grid
hold on
ry= 1-marcumq(s/var,x/var); %theoritical cdf fn
plot(x,ry,'b')
hold off
