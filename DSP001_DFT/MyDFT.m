function X = MyDFT(x)
N = numel(x)
for l = 1:N
    X(l) = complex(0,0);
    for m = 1:N
        X(l) = X(l) + x(m)*exp(-j * (m-1) * 2*pi * (l-1) /N);
    end
end


end