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

%% 先设计切比雪夫I型模拟滤波器
[N , Wc] = cheb1ord(Wp, Ws, Rp, Rs, 's');
% 参数为通带最大衰减 通带截止频率
% bandpass 带通
% s 模拟滤波器
[b, a] = cheby1(N, Rp, Wc, 'bandpass', 's'); 

[H ,W]= freqs(b,a, w);
amplitude = abs(H);
phase = angle(H);
db = 20 * log10(amplitude / max(amplitude));

f = W / (2*pi);

figure;
% 绘制幅度响应图
subplot(2,1,1);
plot(f/1000, db);
title('切比雪夫I型模拟滤波器-幅频特性');
xlabel('f/kHZ');
ylabel('-A(f)/dB');
axis([0 10 -100 5]);

% 绘制相位响应图
subplot(2,1,2);
plot(f, phase);
title('切比雪夫I型模拟滤波器-相频特性');

%% 数字滤波器 冲激响应不变法
Fs = 25000; % 采样频率
[B, A] = impinvar(b, a, Fs);
[H, W] = freqz(B, A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
%f= W * Fs / (2* pi);

% 计算单位冲激响应
x_n = 0:99;                % 绘图用x轴
x = [1 zeros(1,99)];       % 单位冲激序列
y = filter(B, A, x);       % 滤波

figure;
% 绘制幅度响应图
subplot(2,2,1);
plot(W/pi, db);
title('冲激响应不变法-切比雪夫I型数字滤波器-幅频特性');
xlabel('x/Π');
ylabel('-A(f)/dB');
axis([0,1,-100,5]);

% 绘制相位响应图
subplot(2,2,2);
plot(W/pi, phase);
title('冲激响应不变法-切比雪夫I型数字滤波器-相频特性');

% 绘制单位冲激响应
% 绘制单位冲击响应
subplot(2,2,3);
stem(x_n,y);
title('冲激响应不变法-切比雪夫I型数字滤波器-单位冲激响应')

fprintf("\n------冲激响应不变法--------\n系统函数:\n");
fprintf("阶数N = %d\n",N);
fprintf("分子:\n");
for i = 1:numel(B)
   if B(i) > 0
       fprintf("+");
   end
    if B(i) ~= 0
        fprintf("%g \\times ",B(i));
        
        fprintf("z^{-%d} ",i-1);
    end
end
fprintf("\n分母:\n")
for i = 1:numel(A)
   if A(i) > 0
       fprintf("+");
   end
    if A(i)~=0
        fprintf("%g \\times ",A(i));
        fprintf("z^{-%d}",i-1);
    end
end
fprintf("\n\n");

%% 双线性映射法
wp = 2 * pi * fp/Fs;
ws = 2 * pi * fs/Fs;
Wp = (2 * Fs) * tan(wp/2);
Ws = (2 * Fs) * tan(ws/2);

[N , Wc] = cheb1ord(Wp, Ws, Rp, Rs, 's');
[b, a] = cheby1(N, Rp, Wc, 'bandpass', 's');

[B,A] = bilinear(b,a,Fs);
[H,W] = freqz(B,A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
%f= W * Fs / (2* pi);

% 计算单位冲激响应
y = filter(B, A, x);        % 滤波

figure;
% 绘制幅度响应图
subplot(2,2,1);
plot(W/pi, db);
title('双线性映射法-切比雪夫I型数字滤波器-幅频特性');
xlabel('x/Π');
ylabel('-A(f)/dB');
axis([0,1,-100,5]);

% 绘制相位响应图
subplot(2,2,2);
plot(W/pi, phase);
title('双线性映射法-切比雪夫I型数字滤波器-相频特性');

% 绘制单位冲击响应
subplot(2,2,3);
stem(x_n,y);
title('双线性映射法-切比雪夫I型数字滤波器-单位冲激响应');

fprintf("双线性映射法");
fprintf("阶数N = %d\n",N);
fprintf("分子:\n");
for i = 1:numel(B)
   if B(i) > 0
       fprintf("+");
   end
    if B(i) ~= 0
        fprintf("%g \\times ",B(i));
   
        fprintf("z^{-%d} ",i-1);
    end
end
fprintf("\n分母:\n")
for i = 1:numel(A)
   if A(i) > 0
       fprintf("+");
   end
    if A(i)~=0
        fprintf("%g \\times ",A(i));
        fprintf("z^{-%d}",i-1);
    end
end

%% 直接法
Wp = fp/Fs*2;
Ws = fs/Fs*2;


[N , Wc] = cheb1ord(Wp, Ws, Rp, Rs);
[B, A] = cheby1(N, Rp, Wc, 'bandpass');

[H,W] = freqz(B,A);

amplitude = abs(H);
phase = angle(H);

db = 20 * log10( (amplitude + eps) / max(amplitude));
%f= W * Fs / (2* pi);

% 计算单位冲激响应
y = filter(B, A, x);        % 滤波

figure;
% 绘制幅度响应图
subplot(2,2,1);
plot(W/pi, db);
title('直接法-切比雪夫I型数字滤波器-幅频特性');
xlabel('x/Π');
ylabel('-A(f)/dB');
axis([0,1,-100,5]);

% 绘制相位响应图
subplot(2,2,2);
plot(W/pi, phase);
title('直接法-切比雪夫I型数字滤波器-相频特性');

% 绘制单位冲击响应
subplot(2,2,3);
stem(x_n,y);
title('直接法-切比雪夫I型数字滤波器-单位冲激响应')

% 系统函数可由向量B和A得到
fprintf("双线性映射法");
fprintf("阶数N = %d\n",N);
fprintf("分子:\n");
for i = 1:numel(B)
   if B(i) > 0
       fprintf("+");
   end
    if B(i) ~= 0
        fprintf("%g \\times ",B(i));
   
        fprintf("z^{-%d} ",i-1);
    end
end
fprintf("\n分母:\n")
for i = 1:numel(A)
   if A(i) > 0
       fprintf("+");
   end
    if A(i)~=0
        fprintf("%g \\times ",A(i));
        fprintf("z^{-%d}",i-1);
    end
end