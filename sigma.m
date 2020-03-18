function [ stdev_out ] = sigma( stock_data, period )
%SIGMA Summary of this function goes here
%   Detailed explanation goes here

stop = (length(stock_data)-period);
    
    for k=1:stop

        for i=1:period
            temp_data(i) = stock_data(i+k-1);
        end
        stdev_out(k) = std(temp_data);
    end


end

