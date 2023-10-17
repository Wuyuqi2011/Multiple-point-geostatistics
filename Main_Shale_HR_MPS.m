clc; clear;
% import original HR images
M=1024; m=M^3;
%% 2D image augmentation
hd = NaN(M); % Simulation grid (1000x1000)
CT = [8 8];   % Co-Template size in 'i' and 'j' directions
OL = 40;   % Overlap size which should be even
T = 160;   % Template size which should be even
cand = 4;   % Number of candidate pattern which the final pattern is selected from
fc = 0;   % 0: no need for facies matching. Otherwise, the facies proportion should be provided (e.g. for a 2 facies TI, this matrix should be like [0.28 0.72])
mrp = 1; % Multiple random path flag (1:on, 0:off). It is strongly suggested to on it option for conditional simulation.
T_vibration = 1; % Multiple template size flag (1:on, 0:off)
ms_level = 3; % Number of MS level (1, 2, 3).
prop = 0.1;   % The proportion of TI which will be scanned to find the matched hard data (0 < prop <=1)). Larger cofficient helps the hard data to honred, but it may cause some discountinuties.
rad = 1;   % Neighbourhood radius for MS simulation (default or the best radius is [1 1])
real_numb = 15;  % Number of realizations

for i= 2:20
    k= i*50;
   ti = HR(i-1,:,:); ti = reshape(ti, M, M);  ti = double(ti);  Reali_total = ti;
   [Reali, location_2D] = CCSIM_2D(ti, hd, T, OL, CT, fc, prop, rad, cand, mrp, T_vibration, ms_level, real_numb, M);
   Reali_total = cat(3, Reali_total,Reali); 
%    imshow(Reali_total(:,:,4));
   floderName = [num2str(k),''];
   mkdir(floderName);
   Reali_total = uint8(Reali_total); 
   [S1 S2 S3]=size(Reali_total);
   for j=1:S3
       Name = [num2str(j), '.png']; 
       Name =strcat(floderName,'/',Name); %save the image in the specific file
       imwrite(Reali_total(:,:,j), Name);
   end
   clear Reali_total;
end