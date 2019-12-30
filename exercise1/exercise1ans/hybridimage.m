%% Uncomment the commented code lines and implement missing functions 
%% (and anything else that is asked or needed)

%% Load test images.
man=double(imread('man.jpg'));
wolf=double(imread('wolf.jpg'));

% the pixel coordinates of eyes and chin have been manually found 
% from both images in order to enable affine alignment 
man_eyes_chin=[502 465; 714 485; 594 875];
wolf_eyes_chin=[851 919; 1159 947; 975 1451];

[A,b]=affinefit(man_eyes_chin', wolf_eyes_chin');

[X,Y]=meshgrid(1:size(man,2), 1:size(man,1));
pt=A*([X(:) Y(:)]')+b*ones(1,size(man,1)*size(man,2));
wolft=interp2(wolf,reshape(pt(1,:),size(man)),reshape(pt(2,:),size(man)));

%% Below we simply blend the aligned images using additive superimposition
additive_superimposition=man+wolft;

%% Next we create two different Gaussian kernels for low-pass filtering
%% the two images
sigmaA = 16;%7; 
sigmaB = 8;%2; 
filterA = fspecial('Gaussian', ceil(sigmaA*4+1), sigmaA);
filterB = fspecial('Gaussian', ceil(sigmaB*4+1), sigmaB);

man_lowpass = imfilter(man, filterA, 'replicate');
wolft_lowpass= imfilter(wolft, filterB, 'replicate');

%% Your task is to create a hybrid image by combining a low-pass filtered 
%% image of the human face with a high-pass filtered wolf face

%% You get a high-pass version by subtracting the low-pass filtered version
%% from the original image.

%% Thus, your task is to replace the low-pass image on the following line
%% with a high-pass filtered version of 'wolft'
%wolft_highpass=wolft;


%%--your-code-starts-here--%%
wolft_highpass=wolft-wolft_lowpass;
%%--your-code-ends-here--%%

% Replace also the image below with the correct hybrid image
%hybrid_image = man;


%%--your-code-starts-here--%%
hybrid_image=man_lowpass+wolft_highpass;
%%--your-code-ends-here--%%

%% Notice how strongly the interpretation of the hybrid image is affected 
%% by the viewing distance
fighybrid=figure;
imshow(hybrid_image,[]);
%colormap('gray');imagesc((hybrid_image));axis image;

%% Display input images and both output images.
figure; clf;
set(gcf,'Name','Results of superimposition');

subplot(2,2,1); imagesc(man);
axis image; colormap gray;
title('Input Image A');

subplot(2,2,2); imagesc(wolf);
axis image; colormap gray;
title('Input Image B');

subplot(2,2,3); imagesc(additive_superimposition);
axis image; colormap gray;
title('Additive Superimposition');

subplot(2,2,4); imagesc(hybrid_image);
axis image; colormap gray;
title('Hybrid Image');

%% Finally, visualize the log magnitudes of the Fourier
%  transforms of the original images. 
%  Your task is to calculate 2D fourier transform 
%  for wolf/man and their filtered results using fft2 and fftshift

%%--your-code-starts-here--%%
F_man=fftshift(fft2(man));
F_man_lowpass=fftshift(fft2(man_lowpass));

F_wolft=fftshift(fft2(wolft));
F_wolft_highpass=fftshift(fft2(wolft_highpass));
%%--your-code-ends-here--%%

figure; clf;
set(gcf,'Name','Magnitudes of the Fourier transforms');

subplot(2,2,1);
imshow(log(abs(F_man)),[]);
title('log(abs(F-man))');

subplot(2,2,2); 
imshow(log(abs(F_man_lowpass)),[]);
title('log(abs(F-man-lowpass))');


subplot(2,2,3); 
imshow(log(abs(F_wolft)),[]);
title('log(abs(F-wolft))');

subplot(2,2,4); 
imshow(log(abs(F_wolft_highpass)),[]);
title('log(abs(F-wolft-highpass))');

figure(fighybrid);