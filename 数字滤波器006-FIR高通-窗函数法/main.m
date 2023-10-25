%% FIR数字高通滤波器
% 习题7.2
% Wp = 0.7pi Wst = 0.5pi
% As = 55dB

Wp = 0.7 * pi;      % 通带截止角频率
Wst = 0.5 * pi;     % 阻带截止角频率

Fs = 10000;          % 采样频率

tr_width = abs(Wp - Wst);           % 过渡带宽 Δω

% As = 45dB 采用布莱克窗
% tr_width = 11pi/N => N = 11pi / tr_width

N0 = ceil(11 * pi / tr_width);     % 计算加窗宽度 ceil向上取整

N = N0 + mod(N0+1, 2);              % 保证N为奇数

m = (N-1) / 2;                      % 群延时 τ = (N-1)/2

wc = (Wp + Wst) / 2;                % 截止频率

n = 0:1:N-1;

% As = 45dB 采用布莱克曼窗
window = (blackman(N));              % 获得窗函数

nm =n- m + eps;                     % nm = n - τ
hd = 1:N;                           % 理想数字滤波器的单位冲激响应

% 理想数字滤波器的单位冲激响应
% 公式来自课本7.3.2 高通
% 课本上的公式貌似有问题？
for index = 1:N
    if nm(index) == double(0)
        hd(index) = 1 - wc / pi;
    else
        hd(index) = (sin(pi * nm(index))-sin(wc * nm(index))) / (pi * nm(index));
    end
end

hn = hd' .* window;                 % 加窗
[H,W] = freqz(hn,1,300);            % 获得系统的频率响应

amplitude = abs(H);                 % 取幅度
phase = angle(H);                   % 取相位

db = 20 * log10((amplitude + eps)/max(amplitude));  % 转成分贝

f = W/pi;

subplot(1,2,1);
plot(f, db);
title("窗函数法-FIR低通数字滤波器-幅频响应");

subplot(1,2,2)
plot(f, phase);
title("窗函数法-FIR低通数字滤波器-相频响应");
