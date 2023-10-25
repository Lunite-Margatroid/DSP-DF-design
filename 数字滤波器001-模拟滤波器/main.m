%% 设计模拟滤波器滤波器
fp1 = 5000;
fp2 = 7000;     % 通带下限截止频率和通带上限截止频率

fs1 = 3500;
fs2 = 8500;     % 下阻带截止频率和上阻带截止频率

% 带通/带阻要这么写
fp = [5000, 7000];  % 通带截止频率
fs = [3500, 8500];  % 阻带截止频率

Rp = 0.4;       % 通带衰减
Rs = 45;        % 阻带衰减(As)

% 转换为模拟角频率
Wp = 2 * pi * fp;
Ws = 2 * pi * fs;

w = linspace(0,10000,200);
w = w * 2 *pi;

%% 巴特沃斯
% 计算巴特沃思模拟滤波器参数
% N 阶数
% Wc 3dB衰减频率
[N, Wc] = buttord(Wp, Ws, Rp, Rs, 's');   % 's'表示，前面的参数是模拟角频率

% 计算滤波器系统函数
% b 系统函数分子
% a 系统函数分母
% bandpass 带通
% s 模拟滤波器
[b,a] = butter(N, Wc, 'bandpass', 's');

% H 模拟滤波器的复频域响应
% W 对应模拟角频率
% b a是滤波器系统函数分子分母多项式系数组成的向量
% 第三个参数指定频率 W和w是一样的
[H, W] = freqs(b, a, w);

% 幅度
amplitude = abs(H);

% 相位
phase = angle(H);

% 转换为dB
db = 20 * log10(amplitude / max(amplitude));

% 转换为Hz
f = W /2/pi;

% 绘制幅度响应图
subplot(3,2,1);
plot(f, db);
title('巴特沃斯-幅频特性');
axis([0 10000 -70 0]);

% 绘制相位响应图
subplot(3,2,2);
plot(f, phase);
title('巴特沃斯-相频特性');

%% 切比雪夫I型
[N , Wc] = cheb1ord(Wp, Ws, Rp, Rs, 's');
[b, a] = cheby1(N, Rp, Wp, 'bandpass', 's'); % 参数为通带最大衰减 通带截止频率

[H ,W]= freqs(b,a, w);
amplitude = abs(H);
phase = angle(H);
db = 20 * log10(amplitude / max(amplitude));

f = W / (2*pi);

% 绘制幅度响应图
subplot(3,2,3);
plot(f, db);
title('切比雪夫I型-幅频特性');
axis([0 10000 -70 0]);

% 绘制相位响应图
subplot(3,2,4);
plot(f, phase);
title('切比雪夫I型-相频特性');

%% 切比雪夫II型
[N , Wc] = cheb2ord(Wp, Ws, Rp, Rs, 's');
[b, a] = cheby2(N, Rs, Ws, 'bandpass', 's');
% 参数为阻带最小衰减 阻带截止频率 和I型的参数不一样

[H, W] = freqs(b,a,w);
amplitude = abs(H);
phase = angle(H);
db = 20 * log10((amplitude)/ max(amplitude));

f = W/(2*pi) ;

% 绘制幅度响应图
subplot(3,2,5);
plot(f, db);
title('切比雪夫II型-幅频特性');
axis([0 10000 -70 0]);

% 绘制相位响应图
subplot(3,2,6);
plot(f, phase);
title('切比雪夫II型-相频特性');