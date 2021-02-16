function [I, B, S] = SDoF_test(im, W)
% this function produces the shallow depth of field effect by fusioning a
% blurred and sharpen version uf the input image using W as weight map.
% set parameters maxIter to generate a blurrer image. 
% Set gamma to change the sharpness of S. 

J = double(im);

%% Blur image generation. 
%iterative guided filter
maxIter = 3;
r = 15; %radius of the filter, bigger -> bigger features smooth out
a = 3;

EPS = 256/a; %smoothness, bigger -> more wash out effect

    
windowSize = 33;
avg3 = ones(windowSize) / windowSize^2;


[h,w,C] =size(J);

B = J;
 
B(:,:,1) = roifill(J(:,:,1),W);
B(:,:,2) = roifill(J(:,:,2),W);
B(:,:,3) = roifill(J(:,:,3),W);

for n = 1 : maxIter
  % B = imfilter(B, avg3, 'symmetric', 'same', 'conv');
    B = imresize(double(imguidedfilter(imresize(B, 0.25), imresize(W,0.25), 'NeighborhoodSize', r, 'DegreeOfSmoothing',256/2)), [h, w]);
end



% 
% % some data - focused image, grey levels in range 0 to 1
% focused_image = J
% defocused_image = [];
% % approximate psf as a disk
% for c=1 :3
%     r = 30; % defocusing parameter - radius of psf
%     [x, y] = meshgrid(-r:r);
%     disk = double(x.^2 + y.^2 <= r.^2);
%     disk = disk./sum(disk(:));
%     defocused_image(:,:,c) = conv2(focused_image(:,:,c), disk, 'same');
% end
% B = defocused_image;
% size(B)


%% Sharp image generation. 
gamma = 0.2; %sharpness parameter, bigger->sharper

S = J + gamma*(J - B);

%% Fusion. 
I = W.*S + (1-W).*B;

end