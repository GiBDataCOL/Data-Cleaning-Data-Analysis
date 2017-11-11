function [Output]=Cuantilica(y,X,Options)

BethaOLS=((X'*X)^(-1))*(X'*y);

if nargin<2
    Disp('Faltan condiciones de entrada.')
    return
end

if nargin<3
   Options=[];
end

Options=opciones(Options,BethaOLS);

til    =Options.til;
betha0 =Options.betha0;
graph  =Options.graph;
p      =Options.p;
Method =Options.Method;
tau    =Options.tau;

VerificaInputs(y,X,til,p)

% Si ambos son vacios por defecto se tomaran cuartiles
if isempty(p)==1 && isempty(til)==1
    disp('Valor por defecto: Cuartiles')
    til=4;
end

% Si ambos no son vacios por defecto se tomara el vector de cuantiles
if isempty(p)==0 && isempty(til)==0
    disp('Solo se tendrá en cuenta el vector de cuantiles (p). \n')
    disp('Si desea utilizar la opción (til) borre primero la opción (p).')
    Options.til=[];
    til=Options.til;
end

if isempty(til)==0
    a=1/til;
    p=0:a:1; %ej: a=0.25 --> p= 0,0.25,0.5,0.75,1
end

if isempty(p)==0
   p=VerificaP(p);
end

BethaOptim=[];
feval=[];
ExitFlag=[];

BethaOLS=((X'*X)^(-1))*(X'*y);

tic

h = waitbar(0,'Iniciando...');

pause(0.3);
 
d=length(p); %til+1

for j=1:d
    
    options = optimset('Display','off');
    
    if (strcmp(Method,'Tradicional') || strcmp(Method,'tradicional') || strcmp(Method,'T'))
        f = @(b) funcion(y,X,p(j),b);
        [bOptim,FO,Flag,salida] = fminsearch(f,betha0,options);
    elseif (strcmp(Method,'Laplace') || strcmp(Method,'laplace') || strcmp(Method,'L'))
        f = @(b) FunCuantLaplace(y,X,p(j),b,tau);
        [bOptim,FO,Flag,salida] = fminsearch(f,betha0,options);
    end
    
    BethaOptim =horzcat(BethaOptim,bOptim); % Cada columna es un cuantil 
    feval      =horzcat(feval,FO);          % Cada columna es cada una de las funciones objetivo evaluada en cada cuantil
    ExitFlag   =horzcat(ExitFlag,Flag);     % Condicion de salida de cada cuantil
    
    perc=(j/d)*100;
    perc1=round(perc);
    
    waitbar(perc/100,h,strcat(num2str(perc1),'% ...'));

end

fin=toc;

waitbar(1,h,'Proceso Completado');
pause(0.3);
close(h)

Output.BethaOptim = BethaOptim;
Output.F          = feval;
Output.ExitFlag   = ExitFlag;
Output.Tiempo     = fin;

if strcmp(graph,'on')
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    bOLS1=ones(1,d);
    bOLS2=ones(1,d);
    
    bOLS1=bOLS1*BethaOLS(1,1);
    bOLS2=bOLS2*BethaOLS(2,1);
    
    
    subplot(2,2,2)
    plot(p(2:(end-1)),BethaOptim(1,2:(end-1)));
    title('Intercepto vs. Cuantiles');
    xlabel('Cuantil');
    ylabel('Intercepto')
    hold on
    plot(p,bOLS1,'--k')
    grid on
    
    subplot(2,2,4)
    plot(p(2:(end-1)),BethaOptim(2,2:(end-1)));
    title('Coeficiente vs. Cuantiles'); 
    xlabel('Cuantil');
    ylabel('Coeficiente')
    hold on
    plot(p,bOLS2,'--k')
    grid on
    
    subplot(2,2,[1,3])
    a=scatter(X(:,2),y,15,'k');
    title('Income vs. Food Expenditure')
    xlabel('Income');
    ylabel('Food Expenditure');
    grid on
    
    [Lines,cuantiles] = regresion(X,BethaOptim);
    [LinesOLS] = regresionOLS(X,BethaOLS);
    
    doit=0;
    
    for j=1:cuantiles
        
        hold on
        b=plot(X(:,2),Lines(:,j),'--r','LineWidth',0.07);
        
        if p(j+1)==0.5
            hold on
            b2=plot(X(:,2),Lines(:,j),'--k','LineWidth',0.15);
            doit=1;
        end
        
    end
    
    hold on
    c=plot(X(:,2),LinesOLS(:,1),'--b','LineWidth',0.07);
    
    legend([a,b,c],'Observado','Cuantiles','OLS')
    
    if doit==1
        legend([a,b,c,b2],'Observado','Cuantiles','OLS','p=0.5')
    end
    hold off
    
end


end


function [FO]=funcion(y,X,p,betha)
    T=length(y);
    FO=0;
    
    for i=1:T
        
        u=(y(i)-(X(i,:)*betha));
        
        if (u>=0)
            FO=FO+(p*abs(u));
        elseif (u<0)
            FO=FO+((1-p)*abs(u));
        end
        
    end
    
end

function [Y,cuantiles]=regresion(X,bethas)
    a=size(bethas,2);
    N=size(X,1);
    Y=ones(N,a-2);
    for j=2:(a-1)
        for i=1:N
            Y(i,j-1)=bethas(1,j)+bethas(2,j)*X(i,2);
        end
    end

    cuantiles=a-2;

end

function [Y]=regresionOLS(X,bethas)
    N=size(X,1);
    Y=ones(N,1);
        for i=1:N
            Y(i,1)=bethas(1,1)+bethas(2,1)*X(i,2);
        end

end

function VerificaInputs(y,X,til,p)

    if til<=1
        error('El número de cuantiles debe ser mayor que 1.')    
    end

    if size(X,1)~=size(y,1) 
        error('El número de observaciones no es la misma en el vector y que en la matriz X')
    end
    
    if any(p>1)==1 || any(p<0)==1 
        error('El vector de cuantiles (p) debe tener elementos unicamente entre 0 y 1.')
    end
    
end

function f=opciones(Options,BethaOLS)

def = struct('til',[],'betha0',BethaOLS,'graph','on','p',[],'Method','tradicional','tau',1);

if (isempty(Options) || nargin<1)
    Options=def;
else
    opt={'til','betha0','graph','p','Method','tau'};
    for i=1:length(opt)
        if isfield(Options,opt{i})==1
            def.(opt{i})= Options.(opt{i});
        end
    end
    Options=def;
end

f.til     = Options.til;
f.betha0  = Options.betha0;
f.graph   = Options.graph;
f.p       = Options.p;
f.Method  = Options.Method;
f.tau     = Options.tau;

end

function pout=VerificaP(p)

a=length(p);
pout=NaN(a,1);
if p(1)==0 && p(a)==1
    pout=p;
end

if p(1)==0 && p(a)~=1
    pout=vertcat(p,1);
end

if p(1)~=0 && p(a)==1
    pout=NaN(a+1,1);
    pout(1)=0;
    pout(2:end)=p;
end

if p(1)~=0 && p(a)~=1
    pout=NaN(a+1,1);
    pout(1)=0;
    pout(2:end)=p;
    pout=vertcat(pout,1);
end

end















