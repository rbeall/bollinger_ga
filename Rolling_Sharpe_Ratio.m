clear, clc, format compact, close all

start_date = '01012013';
stop_date =  '01012016';

period = 96; %period for rolling Sharpe Ratio
symbol = 'TSLA'; 

stock_data = Bollinger_backtest(symbol,period,1.5643,start_date,stop_date,true);

profit = stock_data.profit










