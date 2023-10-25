%% 设计模拟滤波器滤波器
fp1 = 5000;
fp2 = 7000;     % 通带下限截止频率和通带上限截止频率

fs1 = 3500;
fs2 = 8500;     % 下阻带截止频率和上阻带截止频率

% 带通/带阻要这么写
fp = [fp1, fp2];  % 通带截止频率
fs = [fs1, fs2];  % 阻带截止频率

Rp = 0.5;       % 通带衰减
Rs = 45;        % 阻带衰减(As)

% 转换为模拟角频率
Wp = 2 * pi * fp;
Ws = 2 * pi * fs;

w = linspace(0,10000,200);
w = w * 2 *pi;

% 切比雪夫II型
[N , Wc] = cheb2ord(Wp, Ws, Rp, Rs, 's');
[b, a] = cheby2(N, Rs, Ws, 'bandpass', 's');
% 参数为阻带最小衰减 阻带截止频率 和I型的参数不一样[b, a] = cheby1(N, Rp, Wp, 'bandpass', 's'); % 参数为通带最大衰减 通带截止频率

[H ,W]= freqs(b,a, w);
amplitude = abs(H);
phase = angle(H);
db = 20 * log10(amplitude / max(amplitude));

f = W / (2*pi);

% 绘制幅度响应图
subplot(3,2,1);
plot(f, db);
title('切比雪夫II型模拟滤波器-幅频特性');
axis([0 10000 -70 0]);

% 绘制相位响应图
subplot(3,2,2);
plot(f, phase);
title('切比雪夫II型模拟滤波器-相频特性');

%% 数字滤波器 冲激响应不变法
Fs = 25000; % 采样频率
[B, A] = impinvar(b, a, Fs);
[H, W] = freqz(B, A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
f= W * Fs / (2* pi);

% 绘制幅度响应图
subplot(3,2,3);
plot(f, db);
title('冲激响应不变法-切比雪夫II型数字滤波器-幅频特性');
axis([0 10000 -70 0]);

% 绘制相位响应图
subplot(3,2,4);
plot(f, phase);
title('冲激响应不变法-切比雪夫II型数字滤波器-相频特性');

%% 双线性映射法
wp = 2 * pi * fp/Fs;
ws = 2 * pi * fs/Fs;
Wp = (2 * Fs) * tan(wp/2);
Ws = (2 * Fs) * tan(ws/2);

[N , Wc] = cheb2ord(Wp, Ws, Rp, Rs, 's');
[b, a] = cheby2(N, Rs, Ws, 'bandpass', 's');

[B,A] = bilinear(b,a,Fs);
[H,W] = freqz(B,A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
f= W * Fs / (2* pi);

% 绘制幅度响应图
subplot(3,2,5);
plot(f, db);
title('双线性映射法-切比雪夫II型数字滤波器-幅频特性');
axis([0 10000 -70 0]);

% 绘制相位响应图
subplot(3,2,6);
plot(f, phase);
title('双线性映射法-切比雪夫II型数字滤波器-相频特性');