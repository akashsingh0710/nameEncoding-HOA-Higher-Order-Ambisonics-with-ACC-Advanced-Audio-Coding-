close all;
clc;
sorangle = 30;
w = pi()/180;
B_mat = [1/sqrt(2)   cos(w*sorangle)   sin(w*sorangle) 0];

phi1 = 45;
phi2 = 135;
phi3 = 225;
phi4 = 315;

D_mat = [ 1/sqrt(2)     1/sqrt(2)         1/sqrt(2)         1/sqrt(2);
         cos(w*phi1)    cos(w*phi2)      cos(w*phi3)       cos(w*phi4);
         sin(w*phi1)    sin(w*phi2)      sin(w*phi3)       sin(w*phi4);
              0            0                 0                   0];
frnum = [10 50 500];
for yy=1:3
    
FinalD = D_mat*B_mat';
f = frnum(yy);
c = 346;
alpha = 2*pi()*(1/c);
 [X,Y] = meshgrid(0:0.1:10,0:360);
    p = abs((exp(1i*f*alpha*X.*cosd(45-Y)).*FinalD(1)+exp(1i*f*alpha*X.*cosd(135-Y)).*FinalD(2)+exp(1i*f*alpha*X.*cosd(225-Y)).*FinalD(3)+exp(1i*f*alpha*X.*cosd(315-Y)).*FinalD(4)));
psurf(:,:,yy) = p;

filename = '.\Encoded_Dformat\4\encoded_D1.wav';
D1=audioread(filename);
filename = '.\Encoded_Dformat\4\encoded_D2.wav';
D2=audioread(filename);
filename = '.\Encoded_Dformat\4\encoded_D3.wav';
D3=audioread(filename);
filename = '.\Encoded_Dformat\4\encoded_D4.wav';
D4=audioread(filename);
Ds=[D1,D2,D3,D4]';
[yf,Fs]=audioread('original_input.wav');
y = yf(1:length(D1));
Z=Ds*pinv(y)';

f = frnum(yy);
c = 346;
x=1;
y=1;
%figure;
[X,Y] = meshgrid(0:0.1:10,0:360);
    pt = abs((exp(1i*f*alpha*X.*cosd(45-Y)).*Z(1)+exp(1i*f*alpha*X.*cosd(135-Y)).*Z(2)+exp(1i*f*2*pi()*(1/c)*X.*cosd(225-Y)).*Z(3)+exp(1i*f*2*pi()*(1/c)*X.*cosd(315-Y)).*Z(4)));
ptsurf(:,:,yy) = pt;
    
error = 10*log(sum((pt-p).^2)./sum(p));
plot(error)

hold on
end
legend('100 Hz','1000 Hz' ,'5000 Hz')
xlabel('Distance from center [cm]')
ylabel('Angle averaged error (dB)')
title('Angle-averaged quantization error as a function of distance and frequency')
figure;
surf(X.*cosd(Y),X.*sind(Y),ptsurf(:,:,2))
colormap(hot)
title('Snapshot of reproduced sound field')
view([-0.30 90.00])

figure;
surf(X.*cosd(Y),X.*sind(Y),psurf(:,:,2))
colormap(hot)
title('Snapshot of original sound field')
view([0.10 90.00])

sorangle = 30;
w = pi()/180;
% B format Coefficients
B_mat = [1/sqrt(2)   cos(w*sorangle)   sin(w*sorangle) 0]';
%D format Coefficient matrix for 2,4,6 and 8 channels
D2_mat = [ 1/sqrt(2)     1/sqrt(2);
         cos(w*0)    cos(w*180);
         sin(w*0)    sin(w*180);
              0            0      ];
D4_mat = [ 1/sqrt(2)     1/sqrt(2)         1/sqrt(2)         1/sqrt(2);
         cos(w*45)    cos(w*135)      cos(w*225)       cos(w*315);
         sin(w*45)    sin(w*135)      sin(w*225)       sin(w*315);
              0            0                 0                   0];
D6_mat = [ 1/sqrt(2)     1/sqrt(2)         1/sqrt(2)         1/sqrt(2)   1/sqrt(2)   1/sqrt(2);
         cos(w*0)    cos(w*60)      cos(w*120)       cos(w*180)      cos(w*240)     cos(w*300);
         sin(w*0)    sin(w*60)      sin(w*120)       sin(w*180)      sin(w*240)         sin(w*300);
              0            0                 0                   0               0           0];
 
D8_mat = [ 1/sqrt(2)     1/sqrt(2)         1/sqrt(2)         1/sqrt(2)   1/sqrt(2)   1/sqrt(2)      1/sqrt(2)       1/sqrt(2);
         cos(w*0)    cos(w*45)      cos(w*90)       cos(w*135)      cos(w*180)     cos(w*225)      cos(w*270)      cos(w*315);
         sin(w*0)    sin(w*45)      sin(w*90)       sin(w*135)      sin(w*180)         sin(w*225)      sin(w*270)      sin(w*315);
              0            0                 0                   0               0           0      0       0];          
        
FinalD2 = D2_mat'*B_mat;
FinalD4 = D4_mat'*B_mat;
FinalD6 = D6_mat'*B_mat;
FinalD8 = D8_mat'*B_mat;
[yf,Fs]=audioread('original_input.wav');  %Mono signal
f=Fs;
y = yf(1:840704);
c = 346;                                
alpha = 2*pi()*(1/c);
[X,Y] = meshgrid(0:0.1:10,0:0.1:360);
 
%Pressure calculated for 2,4,6 and 8 channels at particular r,theta
%Reference Sound Field
p2 = abs((exp(1i*f*alpha*X.*cosd(0-Y)).*FinalD2(1)+exp(1i*f*alpha*X.*cosd(180-Y)).*FinalD2(2)));
p4 = abs((exp(1i*f*alpha*X.*cosd(45-Y)).*FinalD4(1)+exp(1i*f*alpha*X.*cosd(135-Y)).*FinalD4(2)+exp(1i*f*alpha*X.*cosd(225-Y)).*FinalD4(3)+exp(1i*f*alpha*X.*cosd(315-Y)).*FinalD4(4)));
p6 = abs((exp(1i*f*alpha*X.*cosd(0-Y)).*FinalD6(1)+exp(1i*f*alpha*X.*cosd(60-Y)).*FinalD6(2)+exp(1i*f*alpha*X.*cosd(120-Y)).*FinalD6(3)+exp(1i*f*alpha*X.*cosd(180-Y)).*FinalD6(4)+exp(1i*f*alpha*X.*cosd(240-Y)).*FinalD6(5)+exp(1i*f*alpha*X.*cosd(300-Y)).*FinalD6(6)));
p8 = abs((exp(1i*f*alpha*X.*cosd(0-Y)).*FinalD8(1)+exp(1i*f*alpha*X.*cosd(45-Y)).*FinalD8(2)+exp(1i*f*alpha*X.*cosd(90-Y)).*FinalD8(3)+exp(1i*f*alpha*X.*cosd(135-Y)).*FinalD8(4)+exp(1i*f*alpha*X.*cosd(180-Y)).*FinalD8(5)+exp(1i*f*alpha*X.*cosd(225-Y)).*FinalD8(6)+exp(1i*f*alpha*X.*cosd(270-Y)).*FinalD8(7)+exp(1i*f*alpha*X.*cosd(315-Y)).*FinalD8(8)));


%2 channel
filename = '.\Encoded_Dformat\2\encoded_D1.wav';
D1=audioread(filename);
filename = '.\Encoded_Dformat\2\encoded_D2.wav';
D2=audioread(filename);
Ds2 = [D1,D2]';
clear D1;
clear D2;
%4 channel
filename = '.\Encoded_Dformat\4\encoded_D1.wav';
D1=audioread(filename);
filename = '.\Encoded_Dformat\4\encoded_D2.wav';
D2=audioread(filename);
filename = '.\Encoded_Dformat\4\encoded_D3.wav';
D3=audioread(filename);
filename = '.\Encoded_Dformat\4\encoded_D4.wav';
D4=audioread(filename);
Ds4=[D1,D2,D3,D4]';
clear D1;
clear D2;
clear D3;
clear D4;
%6 channel
filename = '.\Encoded_Dformat\6\encoded_D1.wav';
D1=audioread(filename);
filename = '.\Encoded_Dformat\6\encoded_D2.wav';
D2=audioread(filename);
filename = '.\Encoded_Dformat\6\encoded_D3.wav';
D3=audioread(filename);
filename = '.\Encoded_Dformat\6\encoded_D4.wav';
D4=audioread(filename);
filename = '.\Encoded_Dformat\6\encoded_D5.wav';
D5=audioread(filename);
filename = '.\Encoded_Dformat\6\encoded_D6.wav';
D6=audioread(filename);
Ds6=[D1,D2,D3,D4,D5,D6]';
clear D1;
clear D2;
clear D3;
clear D4;
clear D5;
clear D6;
%8 channel
filename = '.\Encoded_Dformat\8\encoded_D1.wav';
D1=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D2.wav';
D2=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D3.wav';
D3=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D4.wav';
D4=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D5.wav';
D5=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D6.wav';
D6=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D7.wav';
D7=audioread(filename);
filename = '.\Encoded_Dformat\8\encoded_D8.wav';
D8=audioread(filename);
Ds8=[D1,D2,D3,D4,D5,D6,D7,D8]';

Z2=Ds2*pinv(y)';
Z4=Ds4*pinv(y)';
Z6=Ds6*pinv(y)';
Z8=Ds8*pinv(y)';
f = Fs;
c = 346;
[X,Y] = meshgrid(0:0.1:10,0:0.1:360);
%Sound Field resulting from the encoded signal
pt2 = abs((exp(1i*f*alpha*X.*cosd(0-Y)).*Z2(1)+exp(1i*f*alpha*X.*cosd(180-Y)).*Z2(2)));
pt4 = abs((exp(1i*f*alpha*X.*cosd(45-Y)).*Z4(1)+exp(1i*f*alpha*X.*cosd(135-Y)).*Z4(2)+exp(1i*f*alpha*X.*cosd(225-Y)).*Z4(3)+exp(1i*f*alpha*X.*cosd(315-Y)).*Z4(4)));
pt6 = abs((exp(1i*f*alpha*X.*cosd(0-Y)).*Z6(1)+exp(1i*f*alpha*X.*cosd(60-Y)).*Z6(2)+exp(1i*f*alpha*X.*cosd(120-Y)).*Z6(3)+exp(1i*f*alpha*X.*cosd(180-Y)).*Z6(4)+exp(1i*f*alpha*X.*cosd(240-Y)).*Z6(5)+exp(1i*f*alpha*X.*cosd(300-Y)).*Z6(6)));
pt8 = abs((exp(1i*f*alpha*X.*cosd(0-Y)).*Z8(1)+exp(1i*f*alpha*X.*cosd(45-Y)).*Z8(2)+exp(1i*f*alpha*X.*cosd(90-Y)).*Z8(3)+exp(1i*f*alpha*X.*cosd(135-Y)).*Z8(4)+exp(1i*f*alpha*X.*cosd(180-Y)).*Z8(5)+exp(1i*f*alpha*X.*cosd(225-Y)).*Z8(6)+exp(1i*f*alpha*X.*cosd(270-Y)).*Z8(7)+exp(1i*f*alpha*X.*cosd(315-Y)).*Z8(8)));

%Angle Averaged Error for different number of channels
error2 = 10*log(sum((pt2-p2).^2)./sum(p2));
error4 = 10*log(sum((pt4-p4).^2)./sum(p4));
error6 = 10*log(sum((pt6-p6).^2)./sum(p6));
error8 = 10*log(sum((pt8-p8).^2)./sum(p8));
figure;
plot(error2)
hold on
plot(error4)
hold on
plot(error6)
hold on
plot(error8)
legend('2 channel','4 channel' ,'6 channel','8 channel')
xlabel('Distance from center [cm]')
ylabel('Angle averaged error (dB)')
title('Angle-averaged error as a function of distance from the centre for a clip containing mono source with different number of channels')

