clear,clc, format short, close all

delta = -0.1;
leverage = 3.0;
alpha = [0:.01:1];

position.now = 445000;
position.long = position.now * (1-alpha);
position.short = position.now * alpha;

position.long = position.long *(1+delta);
position.short = position.short * (1-(delta*leverage));

position.total = position.short + position.long;

figure
plot(alpha,position.total)
line([0,1],[position.now,position.now])





