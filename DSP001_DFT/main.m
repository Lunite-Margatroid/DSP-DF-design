N = 64;
x_n = 1:N;            
x_n = x_n-1;
x_cont = 0:2*pi/400:4*pi;   % "连续"频率
for i = 1:N
    x(i) = exp(-(i-1)/N);
end

% 抽样DTFT得到DTF
X_DFT1 = MyDTFT(x, x_n * 2 * pi / N);

% fft计算DTF
X_fft = fft(x);
angle_fft = angle(X_fft);

% 计算DTFT
X_DTFT = MyDTFT(x, x_cont);


% 计算DFT 由定义计算
X_DFT2 = MyDFT(x);

% 绘制DTFT
subplot(4,2,1);
plot(x_cont, abs(X_DTFT));
title('DTFT幅度');

subplot(4,2,2);
plot(x_cont, angle(X_DTFT));
title('DTFT相位');

% 绘制DFT DTFT抽样得到
subplot(4,2,3);
bar(x_n, abs(X_DFT1));
title('DTF幅度（DTFT抽样）');

subplot(4,2,4);
bar(x_n, angle(X_DFT1));
title('DTF相位（DTFT抽样）');

% 绘制DFT 由定义计算
subplot(4,2,5);
bar(x_n, abs(X_DFT2));
title('DTF幅度（用定义计算）');

subplot(4,2,6);
bar(x_n, angle(X_DFT2));
title('DTF相位（用定义计算）');

% 绘制DFT 由fft函数计算
subplot(4,2,7);
bar(x_n, abs(X_fft));
title('DTF幅度（用fft()计算）');

subplot(4,2,8);
bar(x_n, angle(X_fft));
title('DTF相位（用fft()计算）');
