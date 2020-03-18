function [ mean_out ] = mu( stock_data, period )
%MU Summary of this function goes here
%   Detailed explanation goes here

stop = (length(stock_data)-period);
    
    for k=1:stop

        for i=1:period
            temp_data(i) = stock_data(i+k-1);
        end
        mean_out(k) = mean(temp_data);
    end

end

