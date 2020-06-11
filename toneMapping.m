
clc
close all
% a = 0.18; %default 
a = input('Input a value for brightness level: ' ) ;
I = getpfmraw('AtriumNight.pfm'); %image 1
toneMap(I,a, 'AtriumNight');
I = getpfmraw('rosette.pfm'); %image 2
toneMap(I,a, 'rosette');
I = getpfmraw('doll_doll.pfm'); %image 3
toneMap(I, a,'doll_doll');
I = getpfmraw('lips.pfm'); % image 4
toneMap(I, a,'lips');
I = getpfmraw('church.pfm'); %image 5
toneMap(I,a, 'church');

function toneMap( x ,a, name)
I = x ;
image = I ;
worldlum = 0.2125 * image(:,:,1) + 0.7154 * image(:,:,2) + 0.0721 * image(:,:,3);
N = size(image,1)*size(image,2); % total number of pixels
delta = .0001 ;
tem = sum ( sum ( log ( delta + worldlum ))) ; 
logAvgLum = exp( N^-1 *(tem)) ; % equation (1), L_bar_w

scaledlum = (a/logAvgLum) * worldlum ; % equation (2),  L(x,y)

% map all values to be between 0 and 1
Ld3 = scaledlum ./ ( 1+ scaledlum ); % equation 3
output3 = zeros(size(image));

Lmax = max(( worldlum(:) ));
Lwhite = Lmax;
Ld4 = (scaledlum.*( 1+( scaledlum / (Lwhite.^2)))) ./ (1 + scaledlum) ; % equation 4
output4 = zeros(size(image));
sat = 0.65;
for i=1:3   
    output3(:,:,i) = ((image(:,:,i) ./ worldlum) .^sat) .* Ld3;
    output4(:,:,i) = ((image(:,:,i) ./ worldlum) .^sat) .* Ld4;
end

indx = find(output3 > 1);
output3(indx) = 1;
indxm = find(output4 > 1);
output4(indxm) = 1;

% show images
figure;imshow((I)); title('original image');
figure; imshow(output3); title('tone mapped, Eq.3');
figure;imshow(output4); title('tone mapped, Eq.4');
imwrite(output3, [name, '_.bmp']);
end
