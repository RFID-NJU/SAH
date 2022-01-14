% SAH for PC & PO calibration

% x y: Trajectory of the moving tag.
% phase: measured phase.
% freq: Frequency of the measurements.
global x;
global y;
global phase;
global freq;
centroid_x = 60;
centroid_y = 60;
% speed: 5cm/s
vel = 5;
% the number of channels: 1
% pc_x pc_y pc_z: PC of different channels.
% theta: PO of different channels.
channel_num = 1;
theta = zeros(1,channel_num);
pc_x = zeros(1,channel_num);
pc_y = zeros(1,channel_num);
pc_z = zeros(1,channel_num);
for filenum =1:channel_num
    % trajectory 1
    filename = "cali_channel"+int2str(filenum)+"_dist60.txt";
    data = load(filename);
    x1 = (data(:,1)-data(1,1))/1000*vel;
    phase1= 2*pi - data(:,3);
    freq1 = data(:,5);
    % Sampling averagely if the there are too many mearsurements
    if length(x1)>400
        [x1,phase1,feq1] = Sampling(x1,phase1,freq1,400);
    end
    y1 = zeros(length(x1),1);
    % trajectory 2
    filename = "cali_channel"+int2str(filenum)+"_dist70.txt";
    data = load(filename);
    x2 = (data(:,1)-data(1,1))/1000*vel;
    phase2= 2*pi - data(:,3);
    freq2 = data(:,5);
    % Sampling averagely if the there are too many mearsurements
    if length(x2)>400
        [x2,phase2,feq2] = Sampling(x2,phase2,freq2,400);
    end
    y2 = ones(length(x2),1)*10;
    x = [x1;x2];
    y = [y1;y2];
    phase = [phase1; phase2];
    freq = [freq1;freq2];
    maxPixel = 0;
    w = centroid_x;
    l = centroid_y;
    for m = -50:1:50
        for n = -50:1:50
            for h = -50:1:50
                pos = [w+m,l+n,h];
                value = CaliPixel(pos);
                if value > maxPixel
                    maxPixel = value;
                    FineW = w+m;
                    FineL = l+n;
                    FineZ = h;
                end
            end
        end
    end
    w = FineW;
    l = FineL;
    z = FineZ;
    % Hierarchical Search
    for m = -2:.1:2
        for n = -2:.1:2
            for h = -2:.1:2
                pos = [w+m,l+n,z+h];
                value = CaliPixel(pos);
                if value > maxPixel
                    maxPixel = value;
                    FineW = w+m;
                    FineL = l+n;
                    FineZ = z+h;
                end
            end
        end
    end
    [p,tau,r] = CaliPixel([FineW,FineL,FineZ]);
    ii = filenum;
    pc_x(ii) = centroid_x-FineW;
    pc_y(ii) = centroid_y-FineL;
    pc_z(ii) = FineZ;
    theta(ii) = tau;
    disp("Calibration results of trajectories with 60 and 70cm radial distance.");
    fprintf('Pixel Value: %.2f rad \n',p);
    fprintf('PO: %.4f \n',tau);
    fprintf('PC: %.2f %.2f %.2f cm \n \n',pc_x(ii),pc_y(ii),pc_z(ii));
end
% Save the calibration results for localization.
save("calibration_results.mat",'pc_x','pc_y','pc_z','theta');

