clear all;
clc;
% Converting B-format signal to D-format (4 channels)
[W,~]=audioread('.\Bformat\W.wav');
[X,~]=audioread('.\Bformat\X.wav');
[Y,Fs]=audioread('.\Bformat\Y.wav');
w = pi()/180;
B_mat = [W,X,Y]';
D8_mat = [ 1/sqrt(2)     1/sqrt(2)         1/sqrt(2)         1/sqrt(2)  ;
         cos(w*0)    cos(w*45)      cos(w*90)       cos(w*135)      ;
         sin(w*0)    sin(w*45)      sin(w*90)       sin(w*135)     ];   
 
     
D_format = (D8_mat')* B_mat;
 
filename = '.\Dformat\8\D1.wav';
audiowrite(filename,D_format(1,:),Fs);
filename = '.\Dformat\8\D2.wav';
audiowrite(filename,D_format(2,:),Fs);
filename = '.\Dformat\8\D3.wav';
audiowrite(filename,D_format(3,:),Fs);
filename = '.\Dformat\8\D4.wav';
audiowrite(filename,D_format(4,:),Fs);
