clear all;
clc;

% A-format to B-format
% Assuming 4-speaker layout first at 45degree w.r.t. listener and other at 90 degree to the adjacent speakers in a circle  
% Assuming the source is at 30degree in clockwise direction w.r.t. listener

[y,Fs]=audioread('original_input.wav');

sorangle = 30;
w = pi()/180;

WXY_mat = [1/sqrt(2)   cos(w*sorangle)   sin(w*sorangle)];
B_mat = (WXY_mat')*(y)';

W = B_mat(1,:);
X = B_mat(2,:);
Y = B_mat(3,:);

filename = '.\Bformat\W.wav';
audiowrite(filename,W,Fs);
filename = '.\Bformat\X.wav';
audiowrite(filename,X,Fs);
filename = '.\Bformat\Y.wav';
audiowrite(filename,Y,Fs);
