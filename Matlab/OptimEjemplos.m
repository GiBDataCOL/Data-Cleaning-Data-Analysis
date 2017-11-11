
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % %  EJEMPLOS DE RUTINAS DE OPTIMIZACI�N  % % % % % % % % %
% % % % % % % % %          ECONOM�A COMPUTACIONAL       % % % % % % % % %
% % % % % % % % %                  PUJ                  % % % % % % % % %              
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% % -----------------------------------------------------------------------
% %     Este c�digo contiene algunos ejemplos de rutinas de optimizaci�n de
% %     Matlab usando las funciones fminbnd, fminsearch y fminunc.
% % -----------------------------------------------------------------------


%% Funci�n f(x) = x cos(x^2)

clear;
close all;
clear global;
warning('off');
clc;

% % Definici�n de la funci�n usando el comando inline y funciones an�nimas
f = @(x)x.*cos(x.^2);
% % f = inline('x.*cos(x.^2)');

x = 0:0.005:3;
y = feval(f,x);
z = f(x);

figure()

plot(x,y,'b','LineWidth',1.5);
title('$$f(x)=x\cos{x^2}$$','interpreter','latex','fontsize',20);

% % ------------------------------ % %
% % ---------- Opciones ---------- % %
% % ------------------------------ % %

plotIter            = 1;
    GoldenSearch    = 0;
    Simplex         = 0;
    NewtonRaphson   = 0;
    BFGS            = 1;

% % ------------------------------ % %
% % ------------------------------ % %

global history

% % Valores iniciales
initval = 1.2;

% % Para el m�todo de b�squeda de oro, se definen a y b
a = 0.5;
b = 2.5;

% % ------------------------------- % %
% % ---- M�todos sin derivadas ---- % %
% % ------------------------------- % %

% % M�todo de b�squeda de oro
history = [];
options = optimset('Display','iter','OutputFcn',@myoutput);
[xOptim,feval,~,output] = fminbnd(f,a,b,options);
xIter   = history;
fIter   = f(xIter);
fprintf(['El punto �ptimo del m�todo de b�squeda de oro es ',num2str(xOptim),'\ncon valor inicial ',num2str(initval),' alcanzado en ',...
          num2str(output.iterations),' iteraciones! \n']);
      
if plotIter == 1 && GoldenSearch == 1;
    if  xOptim>max(x)
        x = 0:0.005:(ceil(xOptim+1));
    elseif xOptim<min(x)
        x = (floor(xOptim-1)):0.005:3;
    end
    y = f(x);  
    figure()
    plot(x,y,'b','LineWidth',2.5);
    title('$$f(x)=x\cos{x^2}$$','interpreter','latex','fontsize',20);
    hold on;
    plot(xIter,fIter,'x-r','LineWidth',2.5);
    plot([a:0.05:b],[0:0.5:0],'*-k','LineWidth',2.5,'MarkerSize',6);
    hold off;
    legend('Funci�n','Iteraciones golden-search','Rango');
    set(legend,'Location','Best');
    grid on;
end


% % M�todo simplex
history = [];
options = optimset('Display','iter','OutputFcn',@myoutput);
[xOptim,feval,~,output] = fminsearch(f,initval,options);
xIter   = history;
fIter   = f(xIter);
fprintf(['El punto �ptimo del m�todo simplex es ',num2str(xOptim),'\ncon valor inicial ',num2str(initval),' alcanzado en ',...
          num2str(output.iterations),' iteraciones! \n']);     
if plotIter == 1 && Simplex == 1;
    if  xOptim>max(x)
        x = 0:0.005:(ceil(xOptim+1));
    elseif xOptim<min(x)
        x = (floor(xOptim-1)):0.005:3;
    end
    y = f(x);
    figure()
    plot(x,y,'b','LineWidth',2.5);
    title('$$f(x)=x\cos{x^2}$$','interpreter','latex','fontsize',20);
    hold on;
    plot(xIter,fIter,'+-r','LineWidth',1.8);
    plot(initval,f(initval),'dk','LineWidth',2.5,'MarkerSize',12);
    hold off;
    legend('Funci�n','Iteraciones simplex','Valor inicial','fontsize',15);
    set(legend,'Location','Best');
    grid on;
end

% % ------------------------------- % %
% % ---- M�todos con derivadas ---- % %
% % ------------------------------- % %

% % M�todo de Newton Raphson
history = [];
options = optimoptions('fminunc','GradObj','on','Display','iter','OutputFcn',@myoutput);
[xOptim,feval,~,output] = fminunc('fOptim',initval,options);
xIter   = history;
fIter   = fOptim(xIter);
fprintf(['El punto �ptimo del m�todo Newton-Raphson es ',num2str(xOptim),'\ncon valor inicial ',num2str(initval),' alcanzado en ',...
          num2str(output.iterations),' iteraciones! \n']);      
if plotIter == 1 && NewtonRaphson == 1;
    if  xOptim>max(x)
        x = 0:0.005:(ceil(xOptim+1));
    elseif xOptim<min(x)
        x = (floor(xOptim-1)):0.005:3;
    end
    y = fOptim(x);
    figure()
    plot(x,y,'b','LineWidth',2.5);
    title('$$f(x)=x\cos{x^2}$$','interpreter','latex','fontsize',20);
    hold on;
    plot(xIter,fIter,'+-r','LineWidth',1.8);
    plot(initval,fOptim(initval),'dk','LineWidth',2.5,'MarkerSize',12);
    hold off;
    legend('Funci�n','Iteraciones Newton-Raphson');
    set(legend,'Location','Best');
    grid on;
end

% % M�todo de BFGS
history = [];
options = optimoptions('fminunc','Algorithm','quasi-newton','Display','iter','OutputFcn',@myoutput);
[xOptim,feval,~,output] = fminunc(f,initval,options);
xIter   = history;
fIter   = f(xIter);
fprintf(['El punto �ptimo del m�todo BFGS es ',num2str(xOptim),'\ncon valor inicial ',num2str(initval),' alcanzado en ',...
          num2str(output.iterations),' iteraciones! \n']);     
if plotIter == 1 && BFGS == 1;
    if  xOptim>max(x)
        x = 0:0.005:(ceil(xOptim+1));
    elseif xOptim<min(x)
        x = (floor(xOptim-1)):0.005:3;
    end
    y = f(x);
    figure()
    plot(x,y,'b','LineWidth',2.5);
    title('$$f(x)=x\cos{x^2}$$','interpreter','latex','fontsize',20);
    hold on;
    plot(xIter,fIter,'+-r','LineWidth',1.8);
    plot(initval,f(initval),'dk','LineWidth',2.5,'MarkerSize',12);
    hold off;
    legend('Funci�n','Iteraciones BFGS');
    set(legend,'Location','Best');
    grid on;
end
