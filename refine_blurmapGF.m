function r = refine_blurmapGF(x, b, radio, N)
imo = x;
[H, W, ~] = size(x);

% Downsample the map

scale =1;
x=imresize(double(x), 1/scale,'Method', 'nearest');
b=imresize(double(b), 1/scale,'Method',  'nearest'); % Downsampled normalized blur map

    
    
windowSize = 4*round(radio/scale)+1;
avg3 = ones(windowSize) / windowSize^2;

b = imfilter(b, avg3, 'symmetric', 'same', 'conv');

% Smooth original image. 

windowSize = 2*round(radio/(scale*2))+1

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
eps = 10^-6;
w = 4*radio+1;

for n= 1:N
    %r= imfilter(r, avg3,'symmetric','same', 'conv');
    r = imguidedfilter(r, im, 'NeighborhoodSize', w, 'DegreeOfSmoothing',eps);
end


    
r = imresize(r, [H W], 'Method',  'lanczos2'); % Refined full size normalized blur map

r = imguidedfilter(r, imo, 'NeighborhoodSize', w, 'DegreeOfSmoothing',eps);




end