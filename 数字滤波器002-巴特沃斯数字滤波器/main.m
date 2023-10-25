%% 设计带通巴特沃思滤波器
fp1 = 5000;
fp2 = 7000;     % 通带下限截止频率和通带上限截止频率

fs1 = 3500;
fs2 = 8500;     % 下阻带截止频率和上阻带截止频率

% 带通/带阻要这么写
fp = [5000, 7000];  % 通带截止频率
fs = [3500, 8500];  % 阻带截止频率

Rp = 0.5;       % 通带衰减
Rs = 45;        % 阻带衰减(As)

% 转换为模拟角频率
Wp = 2 * pi * fp;
Ws = 2 * pi * fs;

w = linspace(0,10000,200);
w = w * 2 *pi;

%% 先设计模拟滤波器
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
[H, W] = freqs(b, a, w);

% 幅度
amplitude = abs(H);

% 相位
phase = angle(H);

% 转换为dB
db = 20 * log10(amplitude / max(amplitude));

% 转换为Hz
f = W / (2 * pi);

figure;
% 绘制幅度响应图
subplot(2,1,1);
plot(f, db);
title('巴特沃斯模拟滤波器-幅频特性');

% 绘制相位响应图
subplot(2,1,2);
plot(f, phase);
title('巴特沃斯模拟滤波器-相频特性');

%% 转为数字滤波器 冲激响应不变法
Fs = 25000; % 采样频率
[B, A] = impinvar(b, a, Fs);
[H, W] = freqz(B, A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
f= W * Fs / (2* pi);

% 计算单位冲激响应
x_n = 0:99;                % 绘图x轴
x = [1 zeros(1,99)];       % 单位冲激序列
y = filter(B, A, x);        % 滤波

figure;
% 绘制幅度响应图
subplot(2,2,1);
plot(f, db);
title('冲激响应不变法-巴特沃斯数字滤波器-幅频特性');

% 绘制相位响应图
subplot(2,2,2);
plot(f, phase);
title('冲激响应不变法-巴特沃斯数字滤波器-相频特性');

% 绘制单位冲击响应
subplot(2,2,3);
stem(x_n,y);
title('冲激响应不变法-巴特沃斯数字滤波器-单位冲激响应')
%% 双线性映射法
wp = 2 * pi * fp/Fs;
ws = 2 * pi * fs/Fs;
Wp = (2 * Fs) * tan(wp/2);
Ws = (2 * Fs) * tan(ws/2);

[N, Wc] = buttord(Wp, Ws, Rp, Rs, 's');
[b,a] = butter(N, Wc, 'bandpass', 's');


[B,A] = bilinear(b,a,Fs);
[H,W] = freqz(B,A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
f= W * Fs / (2* pi);

% 计算单位冲激响应
y = filter(B, A, x);        % 滤波

figure;
% 绘制幅度响应图
subplot(2,2,1);
plot(f, db);
title('双线性映射法-巴特沃斯数字滤波器-幅频特性');

% 绘制相位响应图
subplot(2,2,2);
plot(f, phase);
title('双线性映射法-巴特沃斯数字滤波器-相频特性');

% 绘制单位冲击响应
subplot(2,2,3);
stem(x_n,y);
title('双线性映射法-巴特沃斯数字滤波器-单位冲激响应')

% 系统函数可由向量B和A得到