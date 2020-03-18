clear, clc, format compact, close all
delete('stock_data.mat');
delete('filter_vars.mat');

start_date = '01012013';
stop_date =  '19052016';
transaction_cost = 8.00;
symbol = 'GOOG';
save('filter_vars.mat','start_date','stop_date','symbol','transaction_cost');

period = [10:5:200];
bollinger_sigma = [0.1:.1:1.0];
count = 1;
for i=1:length(period)
    for j=1:length(bollinger_sigma)
        x = [period(i),bollinger_sigma(j)*100];
        cost(i,j) = Bollinger_GA_objective(x);
        percent = count*100/(length(period)*length(bollinger_sigma))
        count = count+1;
        %clc
    end
end

mesh(period,bollinger_sigma,cost')


