
function Paths = ModelAnticSolution(X0,Param_ss,Param,A,GovInst,PlotOptions)

if  nargin<6
    Plot = 0;
else
    Plot = 1;
end

% % --------------------------------- % %
% % ----- Parámetros del modelo ----- % %
% % --------------------------------- % %

global T

A_t     = A;
k0      = Param(1);     % Capital inicial
omega   = Param(2);     % Inverso de la elasticidad de Frisch
sigma   = Param(3);     % Inverso de la elasticidad de sustitución intertemporal
beta    = Param(4);     % Factor de descuento
delta   = Param(5);     % Tasa de depreciación del capital
alpha   = Param(6);     % Participación del capital en la producción total
habito  = Param(7);
% % ------------------------------------------ % %
% % ----- Estado estacionario del modelo ----- % %
% % ------------------------------------------ % %

x = FiscalGHH_ss(Param_ss);

A_ss      = Param_ss(6);
g_ss      = Param_ss(7);
tau_c_ss  = Param_ss(8);
tau_w_ss  = Param_ss(9);
tau_rk_ss = Param_ss(10);
s_x_ss    = Param_ss(11);

h_ss      = x(1);
k_ss      = x(2);
c_ss      = x(3);
lambda_ss = x(4);
y_ss      = A_ss*k_ss^alpha*h_ss^(1-alpha);
w_ss      = (1-alpha)*y_ss/h_ss;
rk_ss     = alpha*y_ss/k_ss;
I_ss      = y_ss-c_ss-g_ss;
i_ss      = (y_ss-c_ss-g_ss)/y_ss;
R_ss      = ((1-tau_rk_ss)/(1-s_x_ss)*rk_ss + (1-delta));
pk_ss     = (1-tau_rk_ss)*rk_ss + (1-delta)*(1-s_x_ss);
tau_ss    = tau_c_ss.*c_ss - s_x_ss.*I_ss + tau_w_ss.*w_ss.*h_ss + tau_rk_ss.*rk_ss.*k_ss - g_ss;

% % --------------------------------------- % %
% % ------ Sendas óptimas del modelo ------ % %
% % --------------------------------------- % %

options = optimset('MaxFunEvals', 2000000, 'MaxIter', 200000, 'TolFun', 0.005, 'TolX', 1e-10);

tic
X = fsolve('FiscalGHH_eq',X0,options,Param,A,GovInst);
toc

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% % Instrumentos fiscales

% G         = [g_t, tau_c_t, tau_w_t, tau_rk_t, s_x_t]: matriz de políticas fiscales
% g_t       = [g_0, g_1, ... , g_T]':                   gasto de consumo del gobierno
% tau_c_t   = [tau_c_0, tau_c_1, ... , tau_c_T]':       impuestos al consumo
% tau_c_tF  = [tau_c_1, tau_c_2, ... , tau_c_T+1]':     impuestos al consumo (t+1)
% tau_w_t   = [tau_w_0, tau_w_1, ... , tau_w_T]':       impuestos a la remuneración del salario
% tau_rk_t  = [tau_rk_0, tau_rk_1, ... , tau_rk_t]':    impuestos a la remuneración del capital
% tau_rk_tF = [tau_rk_1, tau_rk_2, ... , tau_rk_t+1]':  impuestos a la remuneración del capital (t+1)
% s_x_t     = [s_x_0, s_x_1, ... , s_x_T]':             subsidios a la inversión
% s_x_tF    = [s_x_1, s_x_2, ... , s_x_T+1]':           subsidios a la inversión (t+1)

g_t       = GovInst(:,1);
tau_c_t   = GovInst(:,2);
tau_w_t   = GovInst(:,3);
tau_rk_t  = GovInst(:,4);
tau_rk_tF = [tau_rk_t(2:end); tau_rk_t(end)];
s_x_t     = GovInst(:,5);
s_x_tF    = [s_x_t(2:end); s_x_t(end)];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% % Sendas de variables endógenas

% c_t       = [c_0, c_1, ... , c_T]'
% h_t       = [h_0, h_1, ... , h_T]'
% k_tF      = [k_1, k_2, ... , k_T, k_T+1]'
% k_t       = [k_0, k_1, ... , k_T]'
% h_t       = [h_0, h_1, ... , h_T]'
% lambda_t  = [lambda_0, lambda_1, ... , lambda_T]'
% lambda_tF = [lambda_1, lambda_2, ... , lambda_T+1]'

c_t       = X(:,1);
h_t       = X(:,2);
k_tF      = X(:,3);
k_t       = [k0; k_tF(1:end-1)];
lambda_t  = X(:,4);

% % Variables "auxiliares"

% y_t   = [y_0, y_1, ... , y_T]'
% w_t   = [w_0, w_1, ... , w_T]'
% rk_t  = [rk_0, rk_1, ... , rk_t]'
% rk_tF = [rk_1, rk_2, ... , rk_t+1]'

y_t   = A_t.*k_t.^alpha.*h_t.^(1-alpha); 
w_t   = (1-alpha)*y_t./h_t;
rk_t  = alpha*y_t./k_t;
rk_tF = [rk_t(2:end); rk_t(end)];
I_t   = y_t-c_t-g_t;
i_t   = (y_t - c_t - g_t)./y_t;
R_tF  = 1./(1-s_x_t).*((1-tau_rk_tF).*rk_tF + (1-s_x_tF).*(1-delta));
R_t   = [R_ss; R_tF(1:end-1)];
pk_t  = (1-tau_rk_t).*rk_t + (1-s_x_t)*(1-delta);
tau_t = tau_c_t.*c_t - s_x_t.*I_t + tau_w_t.*w_t.*h_t + tau_rk_t.*rk_t.*k_t - g_t;

% % ---------------------------------------- % %
% % -------- Estructuras del modelo -------- % %
% % ---------------------------------------- % %

EndogVariables  = struct('c_t',c_t,'h_t',h_t,'k_t',k_t,'lambda_t',lambda_t,'y_t',y_t,'w_t',w_t,...
                          'rk_t',rk_t,'I_t',I_t,'i_t',i_t,'R_t',R_t,'pk_t',pk_t);
FiscalVariables = struct('g_t',g_t,'tau_c_t',tau_c_t,'tau_w_t',tau_w_t,'tau_rk_t',tau_rk_t,'s_x_t',s_x_t,'tau_t',tau_t);
Simulations     = struct('EndogVariables',EndogVariables,'FiscalVariables',FiscalVariables);

EndogVariables_ss  = struct('c_t',c_ss,'h_t',h_ss,'k_t',k_ss,'lambda_t',lambda_ss,'y_t',y_ss,'w_t',w_ss,...
                         'rk_t',rk_ss,'I_t',I_ss,'i_t',i_ss,'R_t',R_ss,'pk_t',pk_ss);
FiscalVariables_ss = struct('g_t',g_ss,'tau_c_t',tau_c_ss,'tau_w_t',tau_w_ss,'tau_rk_t',tau_rk_ss,'s_x_t',s_x_ss,'tau_t',tau_ss);
SteadyStates       = struct('EndogVariables_ss',EndogVariables_ss,'FiscalVariables_ss',FiscalVariables_ss);

Paths = struct('Simulations',Simulations,'SteadyStates',SteadyStates);

if Plot == 1
    PlotPaths(Simulations,SteadyStates,PlotOptions);
end

end

