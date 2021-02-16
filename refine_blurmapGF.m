function [r, t] = refine_blurmapGF(x, b, radio, N)
imo = x;
[H, W, ~] = size(x);

% Downsample the map

scale =3;
x=imresize(double(x), 1/scale,'Method', 'nearest');
b=imresize(double(b), 1/scale,'Method',  'nearest'); % Downsampled normalized blur map

    
    
windowSize = 4*round(radio/scale)+1;
avg3 = ones(windowSize) / windowSize^2;

b = imfilter(b, avg3, 'symmetric', 'same', 'conv');

% Smooth original image. 
%case 6
windowSize = 2*round(radio/(scale*2))+1
x = double(x)/255;
im = x;
for n= 1:N
    x = weightedGF(x,x,windowSize,.05, 6);
end
g = double(rgb2gray(x));

windowSize = 4*round(radio/(scale*2))+1;
avg3 = ones(windowSize) / windowSize^2;
windowSize = 2*round(radio/(scale*2))+1;
% Iterative WGF
r = b;
for n= 1:N
    r= imfilter(r, avg3,'symmetric','same', 'conv');
   % r = weightedGF(r,g , windowSize, 0.05, 6);
    eps = 10^-6;
    w = 4*radio+1;
    r = imguidedfilter(r, im, 'NeighborhoodSize', w, 'DegreeOfSmoothing',eps);
end


    
r = imresize(r, [H W], 'Method',  'lanczos2'); % Refined full size normalized blur map
t = imresize(x, [H W], 'Method',  'lanczos2'); % Refined full size normalized blur map
%r = weightedGF(r,double(rgb2gray(im) ), 5, 0.05, 6);
r = imguidedfilter(r, imo, 'NeighborhoodSize', w, 'DegreeOfSmoothing',eps);
%eps = 10^-6;

%w = 4*radio+1;

%r = imguidedfilter(r, im, 'NeighborhoodSize', w, 'DegreeOfSmoothing',eps);




end