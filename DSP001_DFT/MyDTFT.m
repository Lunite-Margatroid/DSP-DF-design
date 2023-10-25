function outputArg1 = MyDTFT(x,w)
% x为信号序列 w为频率 返回w对应的频域值
for n = 1:numel(w)
    sum = complex(0,0);
    for m = 1:numel(x)
        temp = m-1;
        sum = sum + x(m)*exp(-i * w(n) *temp);
    end
    outputArg1(n) = sum;
end

end