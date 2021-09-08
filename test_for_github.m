close all
clear all

%% load keras model
disp('loading keras model');
modelfile = 'model/bmap_vb1.h5';
classNames = {'00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15', '16', '17', '18', '19'};
net = importKerasNetwork(modelfile,'Classes',classNames);

%% Set parameters
step_size =8;

% Read the image
x = imread('images/bird.png');

% Remove noise in the image. 
sigma = 1;
kernel_size = 2*sigma+1;
kernel = fspecial('gaussian', [kernel_size kernel_size], sigma);
x1 = imfilter(x, kernel, 'symmetric');

%% Get blur map
disp('Getting Blur map');
prediction = get_blurmap(double(x1)/255, net, step_size, sigma);

%% Refine Blur map
disp('Refining Blur map');
b_map = rescale(prediction); % Rescale the predicted map to a range [0,1]
b_map_refined = refine_blurmapGF(x,b_map, 11,1);

% Non Linear transformation
close all
M0 =0.5
M1 =1.75;

bn = rescale(b_map_refined);

W = NLT(b_map_refined, M0, M1);

%% Shallow depth of field effect
close all
I = SDoF_test(x, W);

% Display results
figure('name', 'Shallow depth of field')
imshow([x, repmat(b_map, 1,1,3)*255, repmat(b_map_refined, 1,1,3)*255, repmat(W, 1,1,3)*255,I])

%% Save images
imwrite(x, 'images/x.png');
imwrite(b_map, 'images/b_map.png');
imwrite(b_map_refined, 'images/b_map_refined.png');
imwrite(W, 'images/W.png');
imwrite(uint8(I), 'images/I.png');
