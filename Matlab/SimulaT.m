function [alfhaG]=SimulaT(m,n,alfa,Iter,Pobla)

% Ho= Las medias son iguales...     miu_x = miu_y
% Ha= Las medias son diferentes...  miu_x ? miu_y

% -----------------------------------------------------------%
% -------------- Verifica Condiciones de entrada ------------%
% -----------------------------------------------------------%


if (Pobla ~= [1,2,3,4,5] | isinteger(Pobla)==1)
    disp('<Pobla> debe ser entero entre 1 y 5')
    return
end

if (alfa <=0 || alfa>=1)
    disp('<alfa> debe estar en el intervalo (0,1)')
    return
end

if (m <=0 || n<=0 || isinteger(m)==1 || isinteger(n)==1)
    disp('<m> y <n> deben ser enteros positivos')
    return
end

if (Iter <=0 || isinteger(Iter)==1)
    disp('<Iter> debe ser entero positivo')
    return
end

% -----------------------------------------------------------%
% -------------- Simulación de Monte Carlo-------------------%
% -----------------------------------------------------------%

tic

R=0;        % Número de rechazos
NR=0;       % Número de no rechazos
cont=0;     % Contador

while cont<=Iter

    if Pobla==1
        % Poblaciones normalmente distribuidas 
        % con media 0 y varianzas iguales a 1
        x = normrnd(0,1,[1 m])';
        y = normrnd(0,1,[1 n])';
    end


    if Pobla==2
        % Poblaciones normalmente distribuidas 
        % con media 0 y varianzas distintas 
        x = normrnd(0,1,[1 m])';
        y = normrnd(0,10,[1 n])';
    end

    if Pobla==3
        % Poblaciones de distribución t con cuatro 
        % grados de libertad y la misma varianza.
        x = trnd(4,[1 m])';
        y = trnd(4,[1 n])';
    end

    if Pobla==4
        % Poblaciones de distribución exponencial con 
        % parámetros ?x = ?y = 1.
        x = exprnd(1,[1 m])';
        y = exprnd(1,[1 n])';
    end

    if Pobla==5
        % Una población normal (?x = 10, ?x = 2) y una población 
        % exponencial con parámetro ?y = 10.
        x = normrnd(10,2,[1 m])';
        y = exprnd(10,[1 n])';
    end

    % Crear el estadistico t
    [tEstat]=tEstadistico(x,y);

    % Tomar valor absoluto
    tEstat=abs(tEstat);

    % Estadistico de prueba
    tPrueba=tinv((1-(alfa/2)),(m+n-2));
    % tPrueba=tinv((1-(alfa/2)),min(m-1,n-1));

    % Si excede el valor critico ponga un 1 (rechazo que venga de esta distribución), dlc ponga 0
    if tEstat>tPrueba
        R=R+1;
    else
        NR=NR+1;
    end
       
    cont=cont+1;
end

% -----------------------------------------------------------%
% -------------- Condiciones de salida-----------------------%
% -----------------------------------------------------------%

disp(['Número de rechazos: ' num2str(R)])
disp(['Tiempo (seg): ' num2str(toc)])

% Alfha estimado es igual el numero de rechazos sobre el total de iteraciones
alfhaG=R/Iter;

disp(['Alfa Simulación:',num2str(alfhaG)]);

disp(['Tipo de Población: [',num2str(Pobla),']']);

    if Pobla==1
        disp('Poblaciones de distribución normal con media cero e igual varianza');
    end

    if Pobla==2
        disp('Poblaciones de distribución normal con media cero y diferente varianza')
    end

    if Pobla==3
        disp('Poblaciones de distribución t con cuatro grados de libertad y la misma varianza.')
    end

    if Pobla==4
        disp('Poblaciones de distribución exponencial con mismo parámetro')
    end

    if Pobla==5
        disp('Población normal y población exponencial')
    end





