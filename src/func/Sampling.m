function [x,phase,freq] = Sampling(x,phase,freq,sample_num)
%SAMPLING Sampling the data averagely.
%   Input: x phase freq sample_num
%   Output: Sampled x phase freq.
idx_w = floor(length(x)/sample_num);
idx = 1:idx_w:length(x);
x = x(idx);
phase = phase(idx);
freq = freq(idx);
end

