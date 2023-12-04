close all;
clear all
clc
global rpos;
rpos = rotatePosition(80);
addpath Function
addpath source image

chosen=10;
for ii=1:chosen
    img1 = imread(['.\source image\image A\',num2str(ii),'.png']);
    img2 = imread(['.\source image\image B\',num2str(ii),'.png']);
    img3 = imread(['.\source image\image C\',num2str(ii),'.jpg']);

    img1=im2double(img1);img2=im2double(img2);img3=im2double(img3);

    if size(img1,3)>1
        img1=rgb2gray(img1);
    end
    if size(img2,3)>1
        img2=rgb2gray(img2);
    end
    if size(img3,3)>1
        img3=rgb2gray(img3);
    end

    L1=SSF(img1,img1);
    L2=SSF(img2,img2);
    L3=SSF(img3,img3);

    D1=img1-L1;
    D2=img2-L2;
    D3=img3-L3;

    S1 = MUSML(D1);
    S2 = MUSML(D2);
    S3 = MUSML(D3);  

    S11= Gra(D1);S22= Gra(D2);S33= Gra(D3);
    S11=real(S11);S22=real(S22);S33=real(S33);

    SA=(S1).*S11;SB=(S2).*S22;SC=(S3).*S33;
    MAP = abs(SA>SB);
    MAP=MYZX(MAP);
    FD1 = MAP.*D1+(1-MAP).*D2;
    S4 = MUSML(FD1);S44= Gra(FD1);
    SD=(S4).*S44;
    FD = FD1.*(SD./(SC+SD))+D3.*(SC./(SC+SD));


    E1=entropy(L1);
    E2=entropy(L2);
    E3=entropy(L3);
    v1 = blkproc(L1,[3 3],[1,1],@dipin); v2 = blkproc(L2,[3 3],[1,1],@dipin); v3 = blkproc(L3,[3 3],[1,1],@dipin); 
    e1 = mean(v1(:));e2 = mean(v2(:));e3 = mean(v3(:));

    E1 = E1.*e1; E2 = E2.*e2;E3 = E3.*e3;
    FB2 = (E1./(E1+E2+E3)).*L1+(E2./(E1+E2+E3)).*L2+(E3./(E1+E2+E3)).*L3;

    F= FB2+FD;
    figure,imshow([img1,img2,img3,F]);
    imwrite(F,['.\result\', num2str(ii),'.jpg']);

end























