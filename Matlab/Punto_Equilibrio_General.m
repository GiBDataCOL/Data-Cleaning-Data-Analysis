
clear all

%% Punto b
a=0;

while a==0

alfha=[];
for i=1:99
   alfha=vertcat(alfha,unifrnd(0,0.023));
end

alfha(100)=1-sum(alfha);

if sum(alfha)==1 && alfha(100)>=0
   a=1; 
end

end

%% Punto c

xbar1=[5,5,5]';
xbar2=[6,2,7]';
xbar3=[10,4,1]';

alfha1=[0.2,0.3,0.5]';
alfha2=[0.7,0.1,0.2]';
alfha3=[0.2,0.6,0.2]';

xbar=horzcat(xbar1,xbar2,xbar3);

alpha=horzcat(alfha1,alfha2,alfha3);

p=[1/3,1/3,1/3]';

[F,Marshall]=EqWalrasiano(p,alpha,xbar);


%% Punto d

p0=[0.5,0.5,0.5]';

f=@(x) EqWalrasiano(x,alpha,xbar);

options=optimset('Display','off','LargeScale','off');
tic;
[precios,max,convergencia]=fsolve(f,p0,options);

toc;

