clc
clear all
close all

%% Importación de datos de Engel.xlsx

[data,names] = xlsread('Engel.xlsx');

N=size(data,1);
cons=ones(N,1);

X=horzcat(cons,data(:,2));
y=data(:,3);

%% Ingreso contra gasto en comida y un intercepto

%%% ------------------- OLS  ------------------------- %%% 

[b,bint,r,rint,stats] = regress(y,X);

%%% ------------------- Cuantílica ------------------- %%% 

Options.til    = 70;                                % 4:cuartil, 5:quintil, 10:decil, 100:percentil, ....
Options.betha0 = b;                                 % Betha inicial - Por defecto el de OLS
Options.graph  = 'on';                              % Graficar betha contra cuantil 
Options.p      = [0.05,0.1,0.25,0.5,0.75,0.9,0.95]; % Ingresar Manualmente los cuantiles
Options.Method = 'Laplace';                         % Método: 'tradicional' o 'Laplace'
Options.tau    = 3;

[Output]=Cuantilica(y,X,Options);

% La salida <Output> se presenta como una estructura








