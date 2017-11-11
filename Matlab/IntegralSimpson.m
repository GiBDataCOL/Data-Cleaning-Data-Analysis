% Integración Numérica de una sola variable haciendo uso de la regla de
% Simpson.
%
% Función: [Integral]=IntegralSimpson(f,a,b,n)
%
% Integral  = Salida como un solo número
% f*        = función univariada
% a*        = limite inferior
% b*        = limite superior
% n         = amplitud del paso, entre más grande mayor precisión.
%
% (*) simboliza que la entrada es obligatoria, caso contrario es opcional.

function [Integral]=IntegralSimpson(f,a,b,n)

Integral=NaN;

if nargin<3
   disp('Faltan condiciones de entrada.') 
   beep;
   return;
end

if nargin==3
   n=10000;
end

% Verificar condicones de entrada
Ok=VerificaEntradas(f,a,b,n);

if Ok==0
    beep;
    return;
end

% Construir el rango del intervalo.
dx=(b-a)/n;

x=[];
y=[];

% Construir x y evaluar ese x en la función.
for i=0:n
    x=vertcat(x,a+i*dx);
    y=vertcat(y,feval(f,x(i+1)));
end

Integral=(dx/3);
suma=0;

yo=y(1);
yn=y(n+1);

for j=2:n

    if mod(j-1,2)==1 % Si es impar multiplique por 4
        suma=suma+4*y(j);
    end
    
    if mod(j-1,2)==0 % si es par multiplique por 2
        suma=suma+2*y(j);
    end
    
end

suma=suma+yo+yn;

Integral=Integral*suma;
end

function [ok]=VerificaEntradas(f,a,b,n)
ok=1;
    if isa(f,'function_handle')==0
       disp('La entrada f debe ser tipo función.')
       ok=0;
    end
    
    if nargin(f)>1
       disp('La función f deber contener una sola variable.')
       ok=0;
    end
    
    if isa(a,'double')==0
        disp('La entrada a debe ser tipo double.')
        ok=0;
    end
    
    if isa(b,'double')==0
        disp('La entrada b debe ser tipo double.')
        ok=0;
    end
    
    if isa(n,'double')==0
        disp('La entrada n debe ser tipo double.')
        ok=0;
    end
        
    if n<=0
        disp('La entrada n debe ser mayor que cero.')
        ok=0;
    end
    
end









