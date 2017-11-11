% Ejercicio 3.2 Robustez del estadístico t-student

clc
clear all
close all

% Muestra 1
x0=[1,4,3,6,5]';
y0=[5,4,7,6,10]';

[tEstat0]=tEstadistico(x0,y0);

%--------------------------------------------------

m=10;       % número de observaciones de la primera muestra
n=10;       % número de observaciones de la primera muestra
alfa=0.1;   % significancia
Iter=10000; % Numero de iteraciones
Pobla=5;    % De cual poblacion saco la muestra (ver .pdf) (1 a 5)

[alfhaG]=SimulaT(m,n,alfa,Iter,Pobla);







