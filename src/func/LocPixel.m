function [p] = LocPixel(pos)
% Caliculate the Likelihood that the position is the ground truth with SAH.
%   Input: Coordinates of a possible position.
%   Output: Likelihood that the position is the ground truth.
global x;
global y;
global phase;
global freq;
global PC_x;
global PC_y;
global PC_z;
global channels;
global PO;

% w_num: The number of the window,20 or higher is suggested.
w_num = 20;
c = 30000;

x_length = length(x);
w_width = floor(x_length/w_num);
w = zeros(x_length,1);
l = zeros(x_length,1);
z = zeros(x_length,1);
theta = zeros(x_length,1);
for ii = 1: length(channels)
    w(freq==channels(ii)) = PC_x(ii);
    l(freq==channels(ii)) = PC_y(ii);
    z(freq==channels(ii)) = PC_z(ii);
    theta(freq==channels(ii)) = PO(ii);
end

r_arr = zeros(1,w_num);
for n = 1:w_num
    index = (n-1)*w_width+1:n*w_width-1;
    x_w = x(index);
    y_w = y(index);
    phase_w = phase(index);
    freq_w = freq(index);
    w_w = w(index);
    l_w = l(index);
    z_w = z(index);
    theta_w = theta(index);
    % phase alignment
    d = sqrt((pos(1)+x_w-w_w).^2+(pos(2)+y_w-l_w).^2+z_w.^2);
    delta_d = d-d(1);
    delta_f = freq_w-freq_w(1);
    phase_aligned = phase_w-(theta_w+4*pi/c*(d.*delta_f+freq_w(1)*delta_d));
    signal_aligned = sum(exp(phase_aligned*1i));
    aligned_angle = angle(signal_aligned);
    % Map the phase difference to [-pi, pi] to avoid the affect of phase
    % hoping, which is slightly different from the paper.
    r = angle(exp((aligned_angle-mod(4*pi*freq_w(1)/c*d(1),2*pi))*1i));
    r_arr(n) = r;
end
p = 1/sum(r_arr.^2);
end

