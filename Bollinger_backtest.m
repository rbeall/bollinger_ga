function [ stock_data ] = Bollinger_backtest( symbol, period, bollinger_sigma, start_date, stop_date, plot_flag)
%BOLLINGER_BACKTEST Summary of this function goes here
%   Detailed explanation goes here

filter_vars = load('filter_vars.mat');

% Get stock data
if exist('stock_data.mat') == 0
    stock_data = hist_stock_data(filter_vars.start_date,filter_vars.stop_date,filter_vars.symbol);
    save('stock_data.mat','stock_data');
    disp('**** - Updated Stock Data')
end

load('stock_data.mat');

close = flip(stock_data.AdjClose);
trading_day = [1:length(stock_data.AdjClose)];

stock_data.sigma = sigma(close,period);
stock_data.mu = mu(close,period);

for i=1:length(stock_data.mu)-1;
    stock_data.d_mu(i) = stock_data.mu(i+1) - stock_data.mu(i);
end
stock_data.d_mu = [0,stock_data.d_mu];


stock_data.bollinger_upper = stock_data.mu+(bollinger_sigma*stock_data.sigma);
stock_data.bollinger_lower = stock_data.mu-(bollinger_sigma*stock_data.sigma);

%% Find Crossings 
bollinger_state = 1;
j=1;
k=1;
while  bollinger_state <3;
   for i=1:length(stock_data.sigma);
       
        switch bollinger_state

            case 1 %find first buy           
                if i+period >= length(close)
                    bollinger_state = 3;
                    break
                end
                if close(i+period-1) < stock_data.bollinger_lower(i)
                    if close(i+period) > stock_data.bollinger_lower(i+1)
                        stock_data.market_buy(j) = close(i+period);
                        stock_data.market_buy_date(j) = trading_day(i+period);
                        j = j+1;
                        bollinger_state = 2;
                    end
                end
                if i+period >= length(close)
                    bollinger_state = 3;
                end
                
            case 2 %find first sell
                if i+period >= length(close)
                    bollinger_state = 3;
                    break
                end
                if close(i+period-1) > stock_data.bollinger_upper(i)
                    if close(i+period) < stock_data.bollinger_upper(i+1)
                        stock_data.market_sell(k) = close(i+period);
                        stock_data.market_sell_date(k) = trading_day(i+period);
                        k = k+1;
                        bollinger_state = 1;
                    end
                end
                if i+period >= length(close)-1
                    bollinger_state = 3;
                end
            case 3
                break;
                
        end
end
stock_data.number_of_transactions = 0;    
profit = 0;
    if isfield(stock_data,'market_sell') && isfield(stock_data,'market_buy')
        for i=1:length(stock_data.market_sell)
            profit(i) = stock_data.market_sell(i)-stock_data.market_buy(i);
        end
        stock_data.number_of_transactions = length(stock_data.market_sell)*2;
        profit = sum(profit); %negative so GA can minimize
    end
 stock_data.profit = profit;   
%% Plot
if (plot_flag ==1)
    figure
    hold on
    plot(trading_day,close,'b');
    plot(trading_day(period+1:end),stock_data.mu,'r');
    plot(trading_day(period+1:end),stock_data.bollinger_upper,'g');
    plot(trading_day(period+1:end),stock_data.bollinger_lower,'g');

    if isfield(stock_data,'market_buy') && isfield(stock_data,'market_sell')
        for i=1:length(stock_data.market_buy)
            line([stock_data.market_buy_date(i),stock_data.market_buy_date(i)],[0,stock_data.market_buy(i)],'Color','red');
        end
        for i=1:length(stock_data.market_sell)
            line([stock_data.market_sell_date(i),stock_data.market_sell_date(i)],[0,stock_data.market_sell(i)],'Color','green');
        end
    end
    title(strcat(symbol,' Bollinger Plot'));
    ylabel('Price $')
    hold off
end
end

