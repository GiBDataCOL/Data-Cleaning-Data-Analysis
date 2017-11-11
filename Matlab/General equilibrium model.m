% Replication of Ulyssea's paper
      clear
      clear -global
      clc
      cd "C:/Users/nparra/Dropbox/Fedesarrollo/Informalidad empresarial"
      pwd
      more off
      pkg load statistics
         
% Model's parametrization and assume functional forms for the objects

  % 4.1 Parametrization
  
      % Given parameters from the FIRST STAGE
      
      global tau_w    = 0.375              % Statutory values for payroll taxes
      global tau_y    = 0.293              % Statutory values for revenue taxes
      global alpha    = 0.664              % Share of labor income in total income
      global kappa_f  = 0.129              % Predicted exit prob. for the average firm
      global v0       = 7.700              % Minimum size of potential entrant equal to one
      global sigma_sq = 0.150              % Moment of the size dist. in both sectors
      global gamma_f  = 0.500              % Moment of the size dist. in both sectors 
      
      % Given moments form the real data for the SECOND STAGE: preparation
      
      inf_worker_r              = 0.354               % PNAD
      inf_firm_r                = 0.686               % ECINF and RAIS
      inf_firm_one_r            =                % ECINF and RAIS
      inf_firm_two_r            =                % ECINF and RAIS
      inf_firm_three_r          =                % ECINF and RAIS
      inf_firm_four_r           =                % ECINF and RAIS
      inf_firm_five_r           =                % ECINF and RAIS
      inf_workerformal_two_r    =                % ECINF
      inf_workerformal_three_r  =                % ECINF
      inf_workerformal_four_r   =                % ECINF
      inf_workerformal_five_r   =                % ECINF
      inf_firm_dist_75_r        = 0.849              % ECINF
      inf_firm_dist_95_r        = 0.958               % ECINF
      inf_firm_dist_99_r        = 0.993               % ECINF
      for_firm_dist_25_r        = 0.295               % RAIS
      for_firm_dist_50_r        = 0.563               % RAIS
      for_firm_dist_75_r        = 0.774               % RAIS
      for_firm_dist_95_r        = 0.953               % RAIS
      
      % Mass of potential entrants
      
      global M = 10;
      
      % Observed wage
      global w = 3.463;                      % Mean real wage form prime age males in the period (1997-2003)
      
      % Draw stochastic components
      
      X1 =  unifrnd (0,1,[M 1])     % First step to produce random numbers with Pareto distribution
      X2 =  normrnd (0,1,[M 1])
      
  % 4.3.1 Algorithm
    
    % i. Guess the SECOND STAGE
      global kappa_i   = 0.308
      global gamma_i   = 0.258
      global b_i       = 4.197
      global b_f       = 3.724
      global etha      = 4.205
      global C_f       = 5298.2
      global C_i       = 2564.4
      
      phi_2nd_stage = [kappa_i gamma_i b_i b_f etha C_f C_i]
    
    % ii. Obtain the post-entry productivity grid
      
      %v_matrix          = (v0)./(X1.^(1/etha))
      %v_matrix          = (v0)./((1.-X1).^(1./etha))
            location  = v0
            scale     = v0/etha
            shape     = 1/etha

      v_matrix          = gpinv(X1,location,scale,shape)
      epsilon_matrix    = sqrt(sigma_sq).*X2
      log_theta_matrix  = log(v_matrix).+epsilon_matrix
      theta_matrix      = exp(log_theta_matrix)
      
      minimo = log(min(theta_matrix))
      %maximo = max(log_theta_matrix)+sqrt(sigma_sq)
      maximo= log(max(theta_matrix))
     
    % Begin LOOPS//////////////////////////////////////////////
    
      rho         = 1;
      sigma_e     = sqrt(sigma_sq);
      Na          = 100;
      mu          = 0;
            
      % Tauchen method modified for unit root AR(1)
      [states, transmatrix] =  TauchenMethod(mu,sigma_sq,rho,Na,minimo,maximo,0,0) 
      exp_states = exp(states)
      v_matrix
      theta_matrix
      
      % Identify the row in the transition matrix
      V_i= ones(rows(v_matrix),1)
            
      for i=1:rows(v_matrix),

        difference  = abs(v_matrix(i,1).-exp_states);
        min_diff    = min(difference);
        inds        = find(difference==min_diff);
        [row, col]  = ind2sub(size(difference),inds);
        
        % Expected value if they entry to informal sector
          clear labor profit_i
        for k=1:rows(exp_states),
          clear -global theta
          global theta=exp_states(k,1);
          clear x fval
            
            % Objective function
            function obj=phi(L)
              global theta alpha b_i w gamma_i C_i
              obj=-((theta * (L ^alpha))-((1 +(L/b_i))*L*w)-(gamma_i*w));
            endfunction
            
            % Inequalities
            function r=h(L)
              r=[L];
            endfunction
            
          x0=[1]  
          [L, fval, info, iter, nf, lambda] = sqp (x0, @phi, [],@h)
          labor(k,1)=L;
          profit_i(k,1)=-fval/kappa_i;
        end;
        
          labor             % Labor matrix for every possible productivity states
          profit_i          % Profits associated with each labor optimum decision

        for j=1:rows(exp_states),
          ganancia=profit_i(j,1);
          v_i(j,1)=max([0 ganancia]);  % 
        end;
        
        V_i(i,1) =sum((v_i.*transmatrix(row,:)'));
        V_i
        
        % Expected value if they entry to formal sector
        for k=1:rows(exp_states),
          clear -global theta l_hat
          global theta=exp_states(k,1);
          %s = roots([3/b_f, 2, -1-tau_w]);

              %disp('The first root is: '), disp(s(1));
              %disp('The second root is: '), disp(s(2));
          global l_hat=0.56082;
          clear L fval
            % Objective function
            function obj=phi(L)
              global tau_y theta alpha b_f w gamma_f
              obj=-((1-tau_y)*theta*(L^alpha)-((1+(L/b_f))*w*(L^2))-(gamma_f*w));
            endfunction
            
            % Inequalities
            function r=h(L)
              global l_hat
              r=[L;
                l_hat-L];
            endfunction
            
          x0=[1]  
          [L, fval, info, iter, nf, lambda] = sqp (x0, @phi, [],@h)

          pre_labor1(k,1)=L;
          pre_labor1(k,2)=-fval/kappa_f;
          
          clear L fval
            % Objective function
            function obj=phi(L)
              global tau_y tau_w theta alpha b_f w gamma_f l_hat
              obj=-((1-tau_y)*theta*(L^alpha)-((1+(l_hat/b_f))*w*(l_hat^2)+((1+tau_w)*w*(L-l_hat)))-(gamma_f*w));
            endfunction
            
            % Inequalities
            function r=h(L)
              global l_hat
              r=[L-l_hat];
            endfunction

           x0=[l_hat]  
          [L, fval, info, iter, nf, lambda] = sqp (x0, @phi, [],@h)

          pre_labor2(k,1)=L;
          pre_labor2(k,2)=-fval/kappa_f;
          
          clear labor
        if pre_labor1(k,2)>=pre_labor2(k,2)
          labor(k,1)=pre_labor1(k,1);
          profit_f(k,1)= pre_labor1(k,2);
          decision(k,1)=1;
          else
          labor(k,1)=pre_labor2(k,1);
          profit_f(k,1)= pre_labor2(k,2);
          decision(k,1)=2;
        endif;
         end;
          labor
          profit_f
          
          clear v_f
        for j=1:rows(exp_states),
          v_f(j,1)=max([0 profit_f(j,1)]);
        end;
          v_f
        
        V_f(i,1) =sum((v_f.*transmatrix(row,:)'));
        V_f
    
    end;
    
    decision
    V_i
    V_f
    
    sector=zeros([rows(v_matrix) 3])
        for j=1:rows(v_matrix),
            if (V_f(j,1)-C_f>=max([0 V_i(j,1)-C_i]))
              sector(j,1)=1;
            endif
            
            if (V_i(j,1)-C_i>max([0 V_f(j,1)-C_f]))
              sector(j,2)=1;
            endif
            
            if (sector(j,1)==1 && sector(j,2)==1)
              sector(j,3)=1;
            endif
        end;
        
  sector
        

  

  
  
