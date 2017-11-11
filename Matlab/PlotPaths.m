
function  PlotPaths(Simulations,SteadyStates,PlotOptions)

global T

List    = {PlotOptions.VarList};
if  ~isfield(PlotOptions,'TitleList')
    Titles = List;
else
    Titles  = {PlotOptions.TitleList};
end

if length(List) ~= length(Titles)
    error('Las dimensiones de las variables y los títulos no concuerdan');
end

FlagEndog  = [];
FlagFiscal = [];
Flag       = [];

for j=1:length(List)
    TempLabel  = List(j);
    if      any(strcmp(TempLabel,fieldnames(Simulations.EndogVariables)))
        Flag = 1;
        FlagEndog = [FlagEndog, j];
    elseif  any(strcmp(TempLabel,fieldnames(Simulations.FiscalVariables)))
        Flag = 2;
        FlagFiscal = [FlagFiscal, j];
    elseif isempty(Flag)
        error('Una de las variables no existe');
    end
    Flag = [];
end

% Plotting the figures
T_graphs = 100; %Maximal time period for graphs. T_graphs <= T
if T_graphs > T
    T_graphs = T;
end
t = 0:T_graphs; %Time index



% % --------------------------------------- % %
% % --------- Gráficas del modelo --------- % %
% % --------------------------------------- % %

lengvar = length(List);
figNumb = ceil(lengvar/9);

plotlist = List;
namelist = Titles;

for jj=1:figNumb
    figure(jj);
    if jj==figNumb
        indAux = lengvar-(figNumb-1)*9;
    else
        indAux = 9;
    end
    for i=1:indAux
        if indAux>=1 && indAux<=2;
            rows = 1;
            if indAux==1;
                cols = 1;
            else
                cols = 2;
            end
        end
        if indAux>2 && indAux<=4;
            rows = 2; cols =2;
        end
        if indAux>4 && indAux<=9; 
            rows = 3;
            if indAux>4 && indAux<=6;
                cols = 2;
            else
                cols = 3;
            end
        end

        indPlot = (jj-1)*9+i;
        subplot(rows,cols,i);
        if any(indPlot==FlagEndog)
            eval(['Plot = plot(Simulations.EndogVariables.',plotlist{indPlot},');']);
            hold on; eval(['Plot2 = plot(ones(T+1,1)*SteadyStates.EndogVariables_ss.',plotlist{indPlot},');']);
        else
            eval(['Plot = plot(Simulations.FiscalVariables.',plotlist{indPlot},');']);
            hold on; eval(['Plot2 = plot(ones(T+1,1)*SteadyStates.FiscalVariables_ss.',plotlist{indPlot},');']);
        end
        eval(['Title=title(''',namelist{indPlot},''');']);
        set(Title,'FontSize',14,'FontWeight','bold');
        set(Plot,'LineWidth',2.3); hold on;
        set(Plot2,'LineWidth',2.0,'Color','r','LineStyle','--');
        xlabel('Períodos','FontSize',10)
        xlim([0,T+1]);
        grid on;

    end
end


end


