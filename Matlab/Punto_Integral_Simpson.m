% Punto 3.1 Integración Numérica

clc
clear all

%f=@(x) (sqrt(1+x.^3)); a=0; b=4;
%f=@(x) (1/((x+1)*x)); a=0; b=100;
f=@(x) ((1/sqrt(2*pi()))*(exp((-x.^2)/2))); a=-0.96; b=0.96;

n=1000;

[Integral]=IntegralSimpson(f,a,b,n);
Integral
