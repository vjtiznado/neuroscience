function [corr,eje] = corr_cruz(x,y,max_lag,bin)
corr = [];
x = reshape(x,length(x),1);
y = reshape(y,length(y),1);
nbin = ceil(max_lag/bin);
eje = -nbin*bin:bin:nbin*bin;
for k = 1 : size(x), % x será la referencia para la correlacion cruzada
    ind = find((y < x(k) + max_lag) & y > (x(k) - max_lag));
    corr = [corr; y(ind) - x(k)];
end
corr = hist(corr,eje);

% datos normalizados
corr = corr/length(x);