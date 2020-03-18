clc,clear,format compact

%ticker = {'FCNTX' 'FSCHX' 'FSCSX' 'FUSVX'};

current_portfolio_weights = [0.434;0.15;0.041;0.375];
    
start_date = '21072014';
stop_date = '21072015';

stock_data = hist_stock_data(start_date,stop_date,'tickers.txt','C');
number_of_investments = 4;

for i=1:number_of_investments
    port_mean(1,i) = mean(stock_data(i).AdjClose);
end
for i=1:number_of_investments
    for j=1:length(stock_data(1).AdjClose)-1
        percent_daily_ret(i,j) = (stock_data(i).AdjClose(j)-stock_data(i).AdjClose(j+1))/port_mean(i);
    end
    port_sigma(1,i) = std(percent_daily_ret(i,:));
    port_percent_mean(1,i) = mean(percent_daily_ret(i,:));
end

port_covariance = cov(percent_daily_ret');

%Current Portfolio Stats
portfolio_variance = sqrt(current_portfolio_weights' * port_covariance * current_portfolio_weights)
portfolio_daily_ret = current_portfolio_weights' * port_percent_mean'
portfolio_sharpe = portfolio_daily_ret/portfolio_variance


[PortRisk, PortReturn, PortWts] = portopt(port_percent_mean*252*100,port_covariance);
figure
scatter(port_sigma,port_percent_mean*252*100)
hold on
plot(PortRisk,PortReturn,'DisplayName','PortReturn vs. PortRisk','XDataSource','PortRisk','YDataSource','PortRetu rn');figure(gcf)
xlabel('Risk (Standard Deviation)') 
ylabel('Expected Return') 
title('Mean-Variance-Efficient Frontier') 
grid on
hold off

p=Portfolio('AssetMean',port_percent_mean*252*100,'AssetCovar',port_covariance);

p = setDefaultConstraints(p);
plotFrontier(p, 20);
weights = estimateMaxSharpeRatio(p);
[risk, ret] = estimatePortMoments(p, weights);
hold on
plot(risk,ret,'*r');
plot(portfolio_variance,portfolio_daily_ret*252*100,'o')








