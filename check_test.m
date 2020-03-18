
clear, clc, format compact, close all

start_date = '29042015';
stop_date =  '29042016';

stock_data = hist_stock_data(start_date,stop_date,'tickers.txt','C');
number_of_investments = 4;

trading_day = [1:length(stock_data(1).Close)];

%Plot Close
hold on
for i=1:number_of_investments 
    trading_day = [1:length(stock_data(i).Close)];
    plot(trading_day,flip(stock_data(i).Close))
end
legend('F-S&P500','FCNTX','FSCHX','TSLA')
hold off

for i=1:number_of_investments
    YTD_ret(1,i) = (stock_data(i).AdjClose(1)-stock_data(i).AdjClose(length(stock_data(i).AdjClose)))/(stock_data(i).AdjClose(1));
end

figure
hold on
for i=1:number_of_investments
    port_mean(i) = mean(stock_data(i).AdjClose);
    for j=1:length(stock_data(1).AdjClose)-1
        percent_daily_ret(i,j) = (stock_data(i).AdjClose(j)-stock_data(i).AdjClose(j+1))/port_mean(i);
    end
    port_sigma(1,i) = std(percent_daily_ret(i,:));
    port_percent_mean(1,i) = mean(percent_daily_ret(i,:));
    plot(trading_day(1:length(trading_day)-1),flip(percent_daily_ret(i,:)))
end
legend('F-S&P500','FCNTX','FSCHX','TSLA')
hold off




