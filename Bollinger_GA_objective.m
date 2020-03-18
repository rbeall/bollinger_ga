function [ profit ] = Bollinger_GA_objective( x )
%BOLLINGER_GA_OBJECTIVE Summary of this function goes here
%   Detailed explanation goes here

filter_vars = load('filter_vars.mat');


period = x(1);
bollinger_scale = x(2)/100;

stock_data = Bollinger_backtest(filter_vars.symbol,period,bollinger_scale,filter_vars.start_date,filter_vars.stop_date,false);


profit = stock_data.profit-(filter_vars.transaction_cost.*stock_data.number_of_transactions);
if profit ~=0 %negative zero error catch
    profit = -1*profit;
end

end

