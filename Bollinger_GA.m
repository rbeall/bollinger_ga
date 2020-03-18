clear, clc, format compact, close all
delete('stock_data.mat');
delete('filter_vars.mat');


start_date = '01012020';
stop_date =  '11032020';
transaction_cost = 8.00;
symbol = 'FXAIX';
save('filter_vars.mat','start_date','stop_date','symbol','transaction_cost');

nvars = 2;
LB = [5, 0.01*100];
UB = [255*1.2, 2.5*100];

intcon = [1]; %period has to be int

opts = gaoptimset;
%opts = gaoptimset(opts,'PopulationType','doubleVector'); %required for int constraints
%opts = gaoptimset(opts,'TimeLimit',15);
%opts = gaoptimset(opts,'Generations',50);
%opts = gaoptimset(opts,'StallGenLimit',10);
%opts = gaoptimset(opts,'StallTimeLimit',5);
%opts = gaoptimset(opts,'TolFun',1e-6);
%opts = gaoptimset(opts,'TolCon',5);
%opts = gaoptimset('MutationFcn', {@mutationuniform, 0.4});
opts = gaoptimset(opts,'Display','diagnose');
%opts = gaoptimset(opts,'EliteCount',1);
opts = gaoptimset(opts,'PopulationSize',min(max(10*nvars,40),100));

opts = gaoptimset(opts,'PlotFcns', { @gaplotbestf @gaplotbestindiv});
opts = gaoptimset(opts,'PlotInterval',1);

%opts = gaoptimset(opts,'OutputFcns',@print_ga_results);

[x,Fval,exitFlag,Output] = ga(@Bollinger_GA_objective,nvars,[],[],[],[],LB,UB,[],intcon,opts);

stock_data = Bollinger_backtest(symbol,x(1),x(2)/100,start_date,stop_date,true);