% SAH for localization

% x y: Trajectory of the moving tag.
% phase: Measured phase.
% freq: Frequency of the measurements.
% PC_x PC_y PC_z : calibrated PC.
% PO : Calibrated PO.
% channels: List of all channels
global x;
global y;
global phase;
global freq;
global PC_x;
global PC_y;
global PC_z;
global PO;
global channels;
load("calibration_results.mat");
PC_x = pc_x;
PC_y = pc_y;
PC_z = pc_z;
PO = theta;
channels = zeros(1,1);
for ii =1:1
    channels(ii) = 920.625+0.25*(ii-1);
end

% Speed: 5cm/s.
% Ground truth of the start position: (100,100)cm
vel = 5;
real_y = 100;
real_x = 100;

filename = "loc_100_100.txt";
data = load(filename);
t = (data(:,1)-data(1,1))/1000;
[x,y] = Cal_trj(t);
phase= 2*pi - data(:,3);
freq = data(:,5);

% Sampling averagely if the there are too many mearsurements
if length(x)>400
    [x,phase,freq] = Sampling(x,phase,freq,400);
end

tic
matrix = zeros(200,200);
maxPixel = 0;
for m = 1:200
    for n = 1:200
        pos = [m,n];
        matrix(m,n) = LocPixel(pos);
    end
end
[w,l]=find(matrix==max(matrix(:)));

% Hierarchical Search
fine_matrix = zeros(201,201);
for m = 1:201
    for n = 1:201
        pos = [w+(m-101)/100,l+(n-101)/100];
        fine_matrix(m,n) = LocPixel(pos);
    end
end
[m,n]=find(fine_matrix==max(fine_matrix(:)));
w = (m-101)/100+w;
l = (n-101)/100+l;

toc

% Show results
fprintf('Position:\n x:%.2fcm y: %.3fcm \n\n',w,l);
xerr = w-real_x;
yerr = l-real_y;
err = sqrt(xerr^2+yerr^2);
fprintf('Localization error:\n x: %.2fcm y: %.2fcm combined: %.2fcm \n',xerr,yerr,err);
