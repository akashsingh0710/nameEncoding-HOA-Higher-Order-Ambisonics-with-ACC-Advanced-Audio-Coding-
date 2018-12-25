clear all
clc
[W,~]=audioread('.\Bformat\W.wav');
[X,~]=audioread('.\Bformat\X.wav');
[Y,fs]=audioread('.\Bformat\Y.wav');

main_aacencoder(W,fs,'W')
main_aacencoder(X,fs,'X')
main_aacencoder(Y,fs,'Y')