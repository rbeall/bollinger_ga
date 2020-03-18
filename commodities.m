clear, clc, format compact, close all

start_date = '01012007';
stop_date = '10072016';

stock_data = hist_stock_data(start_date,stop_date,'SPY','GLD');

SPY = flip(stock_data(1).AdjClose);
GLD = flip(stock_data(2).AdjClose);


plot(1:length(SPY),SPY,1:length(GLD),GLD)
legend('SPY','GLD')

lambda = 252/2;
for i=1:(length(GLD)-lambda)
    
    corr = corrcoef(GLD(i:i+lambda),SPY(i:i+lambda));
    Corr(i) = corr(2,1);
    
end

figure
plot(Corr)
title('Correlation SPY to GLD')
xlabel('trading day starting in Jan 07')
line([0,length(Corr)],[0,0],'Color','red','LineStyle','--')