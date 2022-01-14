function [tr_x, tr_y] = Cal_trj(t)
%CAL_TRJ  Calculate the trajectory with the timestamp.
%   Input: Timestamp
%   Output: x-trajectory & y-trajectory

%  From right to left: -1
%  From left to right:  1
direction = -1;
% Speed: 5cm/s
vel = 5;

% % linearly moving

tr_x = direction*t*vel;
tr_y = zeros(length(t),1);

% % 45бу
% tr_x = -5*t/sqrt(2);
% tr_y = -5*t/sqrt(2);

end

