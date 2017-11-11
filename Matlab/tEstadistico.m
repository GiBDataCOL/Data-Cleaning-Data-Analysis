function [tEstat]=tEstadistico(x,y)

m=length(x);
n=length(y);

mediax=mean(x);
mediay=mean(y);

sdx=std(x);
sdy=std(y);

sp=sqrt((((m-1))*(sdx^2)+((n-1))*(sdy^2))/(m+n-2));

tEstat=((mediax-mediay)/(sp*sqrt((1/m)+(1/n))));


end