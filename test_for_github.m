close all
clear all

%% load keras model
disp('loading keras model');
%modelfile = './my_model_gray.h5';
tic
modelfile = '/media/fernando/DATA/PhD/Matlab_drive/01-Deep Defocus map/Defocus_estimation/training/bmap_model.h5';

classNames = {'00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15', '16', '17', '18', '19'};
net = importKerasNetwork(modelfile,'Classes',classNames);
toc
%% Set parameters
step_size =16;

% Read the image

x = imread('/home/fernando/Pictures/bird.png');
% x = imresize(x, 0.25);
sigma = 1;
x1 = imgaussfilt(x,sigma);


% Get blur map
disp('Getting Blur map');
tic
b_map = get_blurmap(double(x1)/255, net, step_size, sigma);
%b_map = get_entropy_map(x);
toc

%%
% Refine Blur map
disp('Refining Blur map');
tic

[b_map_refined, t] = refine_blurmapGF(x,b_map, round(step_size),1);

toc

% Non Linear transformation

%close all
M0 =1
M1 =1.75;

bn = rescale(b_map_refined);

W = NLT(b_map_refined, M0, M1);

r = 60;
eps = 10^-6;


W = imguidedfilter(W, x, 'NeighborhoodSize', step_size*2, 'DegreeOfSmoothing',eps);

% Shallow depth of field effect



% Show Results
close all


[I, B, S] = SDoF_test(x, W);
figure('name', 'Shallow depth of field')
imshow([x, repmat(b_map, 1,1,3)*255, repmat(b_map_refined, 1,1,3)*255, repmat(W, 1,1,3)*255,I])

imwrite(x, 'github/x.png');
imwrite(b_map, 'github/b_map.png');
imwrite(b_map_refined, 'github/b_map_refined.png');
imwrite(W, 'github/W.png');
imwrite(I, 'github/I.png');


