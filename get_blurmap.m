function m = get_blurmap(im, model, stepSize, s0)

% This function estimates the blur map of the image x using a NN (model)
% Make sure that the model has been loaded on the main file using: 
%modelfile = './my_model_gray.h5';
%classNames = {'0','1','2','3','4','5','6','7','8','9', '10'};
%net = importKerasNetwork(modelfile,'Classes',classNames);

    [H, W, ~] = size(im);
    % convert to grayscale
    g = rgb2gray(im);

    %define patch size
    patch_w = 32;
    patch_h = 32;

    J = zeros(H,W);

    C = J;
    for h = 1 : stepSize : H
        for w = 1 : stepSize : W
            h_idx = min((h+patch_h - 1),H);
            w_idx = min((w+patch_w - 1),W);
            p = g(h : h_idx, w : w_idx); %take out a patch
            [u,v] = size(p);
            if (u < patch_h)
                p = padarray(p,[patch_h - u 0], 'symmetric','post');
            end
            if(v < patch_w)
                p = padarray(p,[0 patch_w-v], 'symmetric','post');
            end
            Sigma = (classify(model,p)); %calculate the sigma for this patch
            J(h : h_idx, w : w_idx) = J(h : h_idx, w : w_idx) + max((double(Sigma)-s0), 0);
            C(h : h_idx, w : w_idx) = C(h : h_idx, w : w_idx) + 1;

        end
    end

    m = (J./C); 
    m = rescale(m);

end