%% FIR数字带通滤波器
% 习题7.3
% Wp1 = 0.4π 
% Wp2 = 0.5π
% Wst1 = 0.2π
% Wst2 = 0.7π
% As = 75dB

Wp = [0.4, 0.5] * pi;      % 通带截止角频率
Wst = [0.2, 0.7] * pi;     % 阻带截止角频率

tr_width = min(abs(Wp - Wst));           % 过渡带宽

% As = 75dB 采用凯泽Kaiser窗
% beta = 7.865 As = 80
% tr_width = 10pi/N => N = 10pi / tr_width

beta = 7.865;
N0 = ceil(10 * pi / tr_width);     % 计算加窗宽度 ceil向上取整

N = N0 + mod(N0+1, 2);              % 保证N为奇数

m = (N-1) / 2;                      % 群延时 τ = (N-1)/2

wc = (Wp + Wst) / 2;                % 截止频率

n = 0:1:N-1;

% As = 45dB 采用布莱克曼窗
window = (kaiser(N, beta));              % 获得窗函数

nm =n- m + eps;                     % nm = n - τ
hd = 1:N;                           % 理想数字滤波器的单位冲激响应

for index = 1:N
    if nm(index) == double(0)
        hd(index) = (wc(2)-wc(1))/pi;
    else
        hd(index) = (sin(wc(2) * nm(index))-sin(wc(1) * nm(index))) / (pi * nm(index));
    end
end

hn = hd' .* window;                 % 加窗
[H,W] = freqz(hn,1,300);            % 获得系统函数的单位冲激响应

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
