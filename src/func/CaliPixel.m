function [p,avg,r_arr] = CaliPixel(pos)
%   Caliculate the Likelihood that the position is the PC with SAH.
%   Input: Coordinates of a possible position.
%   Output: 
%          p: Likelihood that the position is the PC.
%          avg: mean PO.
%          r_arr: PO of each window.

global y;
global x;
global phase;
global freq;

w = pos(1);
l = pos(2);
h = pos(3);

% w_num: The number of the window,20 or higher is suggested.
w_num = 20;
x_length = length(x);
w_width = floor(x_length/w_num);
f = freq(1);
r_arr = zeros(1,w_num);
for n = 1:w_num
    index = (n-1)*w_width+1:n*w_width-1;
    x_w = x(index);
    y_w = y(index);
    phase_w = phase(index);
    c = 30000;
    d = sqrt((x_w-w).^2+(l+y_w).^2+h^2);
    delta_d = d-d(1);
    % phase alignment
    phase_aligned = phase_w-(4*pi*f/c*delta_d);
    signal_aligned = exp(phase_aligned*1i);
    aligned_angle = angle(sum(signal_aligned));
    % Map the phase difference to [-pi, pi] to avoid the affect of phase
    % hoping, which is slightly different from the paper.
    r = angle(exp(((aligned_angle-4*pi*f/c*d(1)))*1i));
    r_arr(n) = r;
end
avg = sum(r_arr)/length(r_arr);
p = 1/sum((r_arr-avg).^2);
end

