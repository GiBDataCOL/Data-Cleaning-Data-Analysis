function [F,Marshall]=EqWalrasiano(p,alfha,dot)

m=size(dot,1); % Número de bienes
n=size(dot,2); % Número de individuos

Marshall=nan(m,n);

% Demandas Marsharlianas
for i=1:n
   for j=1:m
       Marshall(j,i)=((p'*dot(:,i))*(alfha(j,i)))/(p(j)*sum(alfha(:,i)));
   end
end

% Exceso de demanda
for j=1:m-1
    F(j,:)=sum(Marshall(j,:))-sum(dot(j,:));
end

precio=sum(p)-1;

F=[F;precio];





