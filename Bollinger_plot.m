function [ stock_data ] = Bollinger_plot( symbol, period, bollinger_sigma, start_date, stop_date )
%BOLLINGER_PLOT Summary of this function goes here
%   Detailed explanation goes here

% Get stock data
stock_data = hist_stock_data(start_date,stop_date,symbol);
close = flip(stock_data.AdjClose);
trading_day = [1:length(stock_data.AdjClose)];

stock_data.sigma = sigma(close,period);
stock_data.mu = mu(close,period);

stock_data.bollinger_upper = stock_data.mu+(bollinger_sigma*stock_data.sigma);
stock_data.bollinger_lower = stock_data.mu-(bollinger_sigma*stock_data.sigma);


hold on
plot(trading_day,close,'b');
plot(trading_day(period+1:end),stock_data.mu,'r');
plot(trading_day(period+1:end),stock_data.bollinger_upper,'g');
plot(trading_day(period+1:end),stock_data.bollinger_lower,'g');
title(strcat(symbol,' Bollinger Plot'));
ylabel('Price $')
hold off



end

