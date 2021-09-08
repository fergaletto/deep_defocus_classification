function I = SDoF_test(im, W)
% this function produces the shallow depth of field effect by fusioning a
% blurred and sharpen version uf the input image using W as weight map.
% set parameters maxIter to generate a blurrer image. 
% Set gamma to change the sharpness of S. 

J = double(im);

%% Blur image generation. 

%iterative guided filter
maxIter = 3;
r = 15; %radius of the filter, bigger -> bigger features smooth out
% a = 3;
% EPS = 256/a; %smoothness, bigger -> more wash out effect
%  
% windowSize = 33;
% avg3 = ones(windowSize) / windowSize^2;


[h,w,C] =size(J);

B = J;
 
B(:,:,1) = regionfill(J(:,:,1),W>0.01);
B(:,:,2) = regionfill(J(:,:,2),W>0.01);
B(:,:,3) = regionfill(J(:,:,3),W>0.01);

for n = 1 : maxIter
   %B = imfilter(B, avg3, 'symmetric', 'same', 'conv'); % Option 1
   B = imresize(double(imguidedfilter(imresize(B, 0.25), imresize(W,0.25), 'NeighborhoodSize', r, 'DegreeOfSmoothing',256/2)), [h, w]); %option 2
end


%% Sharp image generation. 
gamma = 0.2; %sharpness parameter, bigger->sharper

S = J + gamma*(J - B);

%% Fusion. 
I = W.*S + (1-W).*B;

end