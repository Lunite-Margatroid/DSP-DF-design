%% FIR数字低通滤波器
% 习题7.1
% Wp = 0.2pi Wst = 0.4pi
% As = 45dB

Wp = 0.2 * pi;      % 通带截止角频率
Wst = 0.4 * pi;     % 阻带截止角频率

Fs = 10000;          % 采样频率

tr_width = abs(Wp - Wst);           % 过渡带宽 Δω

% As = 45dB 采用海明窗
% tr_width = 6.6pi/N => N = 6.6pi / tr_width

N0 = ceil(6.6 * pi / tr_width);     % 计算加窗宽度 ceil向上取整

N = N0 + mod(N0+1, 2);              % 保证N为奇数

m = (N-1) / 2;                      % 群延时 τ = (N-1)/2

wc = (Wp + Wst) / 2;                % 截止频率

n = 0:1:N-1;

window = (hamming(N));              % 获得窗函数

nm =n- m + eps;                     % nm = n - τ
hd = 1:N;                           % 理想数字滤波器的单位冲激响应

% 理想数字滤波器的单位冲激响应
% 公式来自课本7.3.2 低通
for index = 1:N
    if nm(index) == double(0)
        hd(index) = wc / pi;
    else
        hd(index) = sin(wc * nm(index)) / pi / nm(index);
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
xlabel('w/Π');
ylabel('-A(f)/dB');
title("窗函数法-FIR低通数字滤波器-幅频响应");

subplot(1,2,2)
plot(f, phase);
xlabel('w/Π');
ylabel('φ/rad');
title("窗函数法-FIR低通数字滤波器-相频响应");

for i = 1:numel(hn)
    fprintf("%g,",hn(i));
end