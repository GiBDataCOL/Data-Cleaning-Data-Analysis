
function ss_values = FiscalGHH_ss(Param_ss)

% % ------------------------------------- % %
% % ------- Parámetros del modelo ------- % %
% % ------------------------------------- % %

omega     = Param_ss(1);
sigma     = Param_ss(2);
beta      = Param_ss(3);
delta     = Param_ss(4);
alpha     = Param_ss(5);
A         = Param_ss(6);
g_ss      = Param_ss(7);
tau_c_ss  = Param_ss(8);
tau_w_ss  = Param_ss(9);
tau_k_ss  = Param_ss(10);
s_x_ss    = Param_ss(11);
habito    = Param_ss(12);
% % ------------------------------------------ % %
% % ----- Estado estacionario del modelo ----- % %
% % ------------------------------------------ % %

h_ss        = ((1-alpha)*A*(1-tau_w_ss)/(1+tau_c_ss)*((1-s_x_ss)/(1-tau_k_ss)*(1/beta-(1-delta))/(alpha*A))^(-alpha/(1-alpha)))^(1/(omega-1));
k_ss        = ((1-s_x_ss)/(1-tau_k_ss)*(1/beta-(1-delta))/(alpha*A))^(-1/(1-alpha))*h_ss;
c_ss        = A*k_ss^alpha*h_ss^(1-alpha)-delta*k_ss-g_ss;
lambda_ss   =  (c_ss-habito*c_ss-(h_ss^omega)/omega)^(-sigma)/(1+tau_c_ss); % Cambia

% % ------------------------------------------- % %
% % ------ Vector de estado estacionario ------ % %
% % ------------------------------------------- % %

ss_values = [h_ss; k_ss; c_ss; lambda_ss];
