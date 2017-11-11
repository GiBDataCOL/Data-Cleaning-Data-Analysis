clc
clear
close all


% 2-2 MODELO FISCAL
 
% % -----------------------------------------------------------------------
% %     Este programa fue escrito por Santiago Téllez para la clase de 
% %     Economía computacional de la Universidad Javeriana. Se basa en los
% %     códigos de Michael Bar.
% % -----------------------------------------------------------------------

% Inicio del código

clear all;
close all;
clc;

global T

% % ------------------------------------- % %
% % ------- Parámetros del modelo ------- % %
% % ------------------------------------- % %

beta   = 0.97;
sigma  = 2.35;
omega  = 3;
delta  = 0.07;
alpha  = 0.35;
habito = 0.15;   % Habito de consumo
A_ss   = 1; 
T = 250; % Número de períodos de la simulación: t = 0,1,2,...,T

% % ----------------------------------- % %
% % ------- Estado estacionario ------- % %
% % ----------------------------------- % %

% % Estado estacionario de las variables fiscales
g_ss     = 0.6;
tau_c_ss = 0;
tau_w_ss = 0;
tau_k_ss = 0;
s_x_ss   = 0;
gb       = g_ss;
rh       = 0.3;

% % Estado estacionario del modelo
Param_ss = [ omega; sigma; beta; delta; alpha; A_ss;...
             g_ss; tau_c_ss; tau_w_ss; tau_k_ss; s_x_ss;habito];

x = FiscalGHH_ss(Param_ss);

h_ss      = x(1);
k_ss      = x(2);
c_ss      = x(3);
lambda_ss = x(4);
y_ss      = A_ss*k_ss^alpha*h_ss^(1-alpha);
w_ss      = (1-alpha)*y_ss/h_ss;
rk_ss     = alpha*y_ss/k_ss;
I_ss      = y_ss-c_ss-g_ss;
i_ss      = (y_ss-c_ss-g_ss)/y_ss;
R_ss      = ((1-tau_k_ss)/(1-s_x_ss)*rk_ss + (1-delta));
pk_ss     = (1-tau_k_ss)*rk_ss + (1-delta)*(1-s_x_ss);


% % ---------------------------------- % %
% % ------- Valores de partida ------- % %
% % ---------------------------------- % %

% % Punto de partida de las simulaciones
k0     = k_ss;
A0     = A_ss;
g0     = g_ss;
tau_c0 = tau_c_ss;
tau_w0 = tau_w_ss;
tau_k0 = tau_k_ss;
s_x0   = s_x_ss;

% % Valores iniciales
X0(:,1) = ones(T+1,1)*c_ss;
X0(:,2) = ones(T+1,1)*h_ss;
X0(:,3) = ones(T+1,1)*k_ss;
X0(:,4) = ones(T+1,1)*lambda_ss;

% % ---------------------------------- % %
% % ---------- Simulaciones ---------- % %
% % ---------------------------------- % %

Param   = [k0; omega; sigma; beta; delta; alpha; habito; gb; rh];
A       = [A0; ones(T,1)*A_ss];         %A(1)      = A_ss*1.1; 
go       = [g0; ones(T,1)*g_ss];         %g(50)     = g_ss + 0.2;
taucons   = [tau_c0; ones(T,1)*tau_c_ss]; taucons(50:end) = tau_c_ss + 0.1;
tau_w   = [tau_w0; ones(T,1)*tau_w_ss]; %tau_w(40:end) = tau_w_ss + 0.2;
tau_k   = [tau_k0; ones(T,1)*tau_k_ss]; %tau_k(40:end) = tau_k_ss + 0.2; 
s_x     = [s_x0; ones(T,1)*s_x_ss];     %s_x(40) = s_x_ss  - 0.05;
% % Matriz de políticas fiscales
Gov = [go, taucons, tau_w, tau_k, s_x];

% % ------------------------------------ % %
% % ------------- Gráficas ------------- % %
% % ------------------------------------ % %

%% %%%%%%%%%%%%%% 4. %%%%

%% Permanente ARRIBA
VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','tau_c_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta del capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Impuestos al Consumo'};
PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,Gov,PlotOptions);

taucons   = [tau_c0; ones(T,1)*tau_c_ss];

%% Transitorio
taucons(50) = tau_c_ss + 0.1;

Gov = [go, taucons, tau_w, tau_k, s_x];

VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','tau_c_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta del capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Impuestos al Consumo'};

PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,Gov,PlotOptions);
taucons   = [tau_c0; ones(T,1)*tau_c_ss];

%% %%%%%%%%%%%%%%%%%%  5

close all
   
%%Permanente
tau_k(50:end) = tau_k_ss + 0.1; 


Gov = [go, taucons, tau_w, tau_k, s_x];
VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','tau_rk_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta del capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Impuesto Renta del Capital'};
PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,Gov,PlotOptions);
tau_k   = [tau_k0; ones(T,1)*tau_k_ss]; 

%% Trensitorio
close all
tau_k(50) = tau_k_ss + 0.1; 

Gov = [go, taucons, tau_w, tau_k, s_x];

Gov = [go, taucons, tau_w, tau_k, s_x];
VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','tau_rk_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Impuesto Renta del capital'};
PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,Gov,PlotOptions);
tau_k   = [tau_k0; ones(T,1)*tau_k_ss]; 



%% %%%%%%%%%%%%%%%%%%%% 6. 



close all
s_x(40) = s_x_ss  - 0.05;

Gov = [go, taucons, tau_w, tau_k, s_x];

VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','s_x_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta del capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Subsidio (Impuesto) a la Inversión'};
PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,Gov,PlotOptions);
s_x     = [s_x0; ones(T,1)*s_x_ss];


%% %%%%%%%%%%%%%%%%%%%%  7.


close all

go(50)     = g_ss + 0.2;

Gov = [go, taucons, tau_w, tau_k, s_x];

VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','g_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta del capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Gasto Público con persistencia'};
PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,Gov,PlotOptions);

go       = [g0; ones(T,1)*g_ss]; 
