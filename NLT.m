function W = NLT(b, M0, M1)
% This function makes a non linar transformation of the normalized blur map
% using a gausian function. b should be rescaled to the interval [0, 1]. 
% calculate Sigma and Beta

a = log(-log(0.001))/log(-log(0.999));
Sigma = exp((log(10-M0) - a*log(10-M1))/(1-a));
Beta = log(-log(0.001))/log((10-M0)/Sigma);

%nonlinear transformation using 
q = 10*b;
W =  1-exp(-((10-q)/Sigma).^Beta);

end