function [media, mediana, maxi, mini] = getdata(mydata)
% function [outpust] = myfunc(inputs)

suma = sum(mydata);
nume = length(mydata);

media = suma/nume;

mediana = median(mydata);
maxi = max(mydata);
mini = min(mydata);