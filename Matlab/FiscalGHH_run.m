


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % MODELO NEOCLÁSICO DE CRECIMIENTO  % % % % % % % % % % %
% % % % % % % % % % %        CON SECTOR FISCAL        % % % % % % % % % % % 
% % % % % % % % % % %     ECONOMÍA COMPUTACIONAL      % % % % % % % % % % %
% % % % % % % % % % %              PUJ                % % % % % % % % % % %               
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% % -----------------------------------------------------------------------
% %     Este programa fue escrito por Santiago Téllez para la clase de 
% %     Economía computacional de la Universidad Javeriana. Se basa en los
% %     códigos de Michael Bar.
% % -----------------------------------------------------------------------

%% Inicio del código

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

% % Estado estacionario del modelo
Param_ss = [ omega; sigma; beta; delta; alpha; A_ss;...
             g_ss; tau_c_ss; tau_w_ss; tau_k_ss; s_x_ss;];

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

Param   = [k0; omega; sigma; beta; delta; alpha];
A       = [A0; ones(T,1)*A_ss];         %A(1) = A_ss*1.1; 
g       = [g0; ones(T,1)*g_ss];         %g(10:end)     = g_ss + 0.2;
tau_c   = [tau_c0; ones(T,1)*tau_c_ss]; %tau_c(10:end) = tau_c_ss + 0.2;
tau_w   = [tau_w0; ones(T,1)*tau_w_ss]; tau_w(40:end) = tau_w_ss + 0.2;
tau_k   = [tau_k0; ones(T,1)*tau_k_ss]; %tau_k(40:end) = tau_k_ss + 0.2;
s_x     = [s_x0; ones(T,1)*s_x_ss];     %s_x(40) = s_x_ss  + 0.05;
% % Matriz de políticas fiscales
GovInst = [g, tau_c, tau_w, tau_k, s_x];

% % ------------------------------------ % %
% % ------------- Gráficas ------------- % %
% % ------------------------------------ % %

VarList      = {'c_t','h_t','k_t','y_t','w_t','rk_t','R_t','lambda_t','tau_w_t'};
TitleList    = {'Consumo','Horas','Capital','Producto total','Salario','Renta del capital',...
                'Tasa de interés real','Utilidad marg. del consumo','Impuestos al trabajo'};
PlotSettings = struct([]);

PlotOptions = struct('VarList',VarList,'TitleList',TitleList,'PlotSettings',PlotSettings);

X=ModelAnticSolution(X0,Param_ss,Param,A,GovInst,PlotOptions);

