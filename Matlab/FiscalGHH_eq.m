
function variab_paths = FiscalGHH_eq(X,Param,A,GovInst)


% % ------------------------------------- % %
% % ------- Parámetros del modelo ------- % %
% % ------------------------------------- % %

k0    = Param(1); % Capital inicial
omega = Param(2); % Inverso de la elasticidad de Frisch
sigma = Param(3); % Inverso de la elasticidad de sustitución intertemporal
beta  = Param(4); % Factor de descuento
delta = Param(5); % Tasa de depreciación del capital
alpha = Param(6); % Participación del capital en la producción total
habito= Param(7); % parámetro del Hábito
gb    = Param(8);
rh    = Param(9);
% % ------------------------------------ % %
% % -------- Variables exógenas -------- % %
% % ------------------------------------ % %

% % Productividad total de los factores

%A_t     = [A_0, A_1, ... , A_T]': matriz con choques a la productividad de los factores
A_t      = A(1:end);

% % Instrumentos fiscales

% G        = [g_t, tau_c_t, tau_w_t, tau_k_t, s_x_t]: matriz de políticas fiscales
% g_t      = [g_0, g_1, ... , g_T]':                gasto de consumo del gobierno
% tau_c_t  = [tau_c_0, tau_c_1, ... , tau_c_T]':    impuestos al consumo
% tau_c_tF = [tau_c_1, tau_c_2, ... , tau_c_T+1]':  impuestos al consumo (t+1)
% tau_w_t  = [tau_w_0, tau_w_1, ... , tau_w_T]':    impuestos a la remuneración del salario
% tau_k_t  = [tau_k_0, tau_k_1, ... , tau_k_T]':    impuestos a la remuneración del capital
% tau_k_tF = [tau_k_1, tau_k_2, ... , tau_k_T+1]':  impuestos a la remuneración del capital (t+1)
% s_x_t    = [s_x_0, s_x_1, ... , s_x_T]':          subsidios a la inversión
% s_x_tF   = [s_x_1, s_x_2, ... , s_x_T+1]':        subsidios a la inversión (t+1)

g_t      = GovInst(:,1);
g_tb     = [g_t(1:end-1); g_t(end-1)];
tau_c_t  = GovInst(:,2);
tau_w_t  = GovInst(:,3);
tau_k_t  = GovInst(:,4);
tau_k_tF = [tau_k_t(2:end); tau_k_t(end)];
s_x_t    = GovInst(:,5);
s_x_tF   = [s_x_t(2:end); s_x_t(end)];

% % ----------------------------------- % %
% % ------- Variables endógenas ------- % %
% % ----------------------------------- % %

% % Sendas de variables endógenas

% c_t       = [c_0, c_1, ... , c_T]'
% h_t       = [h_0, h_1, ... , h_T]'
% k_tF      = [k_1, k_2, ... , k_T, k_T+1]'
% k_t       = [k_0, k_1, ... , k_T]'
% h_t       = [h_0, h_1, ... , h_T]'
% lambda_t  = [lambda_0, lambda_1, ... , lambda_T]'
% lambda_tF = [lambda_1, lambda_2, ... , lambda_T+1]'

c_t       = X(:,1);
c_tb      = [c_t(1:end-1);c_t(end-1)];
h_t       = X(:,2);
k_tF      = X(:,3);
k_t       = [k0; k_tF(1:end-1)];
lambda_t  = X(:,4);
lambda_tF = [lambda_t(2:end); lambda_t(end)];

% % Variables "auxiliares"

% y_t   = [y_0, y_1, ... , y_T]'
% w_t   = [w_0, w_1, ... , w_T]'
% rk_t  = [rk_0, rk_1, ... , rk_t]'
% rk_tF = [rk_1, rk_2, ... , rk_t+1]'

y_t   = A_t.*k_t.^alpha.*h_t.^(1-alpha); 
w_t   = (1-alpha)*y_t./h_t;
rk_t  = alpha*y_t./k_t;
rk_tF = [rk_t(2:end); rk_t(end)];

% % ----------------------------------- % %
% % ------ Ecuaciones del modelo ------ % %
% % ----------------------------------- % %

Labor       = h_t.^(omega-1) - ((1-tau_w_t)./(1+tau_c_t)).*w_t;
Euler       = lambda_t - beta./(1-s_x_t).*lambda_tF.*((1-tau_k_tF).*rk_tF + (1-s_x_tF).*(1-delta));
ResConstr   = c_t + k_tF + g_t - y_t - (1-delta)*k_t;
lambda      = lambda_t - ((c_t-habito*c_tb-(h_t.^(omega))./(omega)).^(-sigma))./(1+tau_c_t); %Cambia
g           =  (1-rh)*gb + rh*g_tb -g_t;
% % -------------------------------------- % %
% % -------- Vector de soluciones -------- % %
% % -------------------------------------- % %

variab_paths = [Labor,Euler,ResConstr,lambda, g];
