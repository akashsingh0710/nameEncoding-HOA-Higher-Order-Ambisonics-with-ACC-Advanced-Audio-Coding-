clear all 
clc
[D1,~]=audioread('.\Dformat\4\D1.wav');
[D2,~]=audioread('.\Dformat\4\D2.wav');
[D3,~]=audioread('.\Dformat\4\D3.wav');
[D4,fs]=audioread('.\Dformat\4\D4.wav');

% All wav files converted to aac format
main_aacencoderD(D1,fs,'D1')
main_aacencoderD(D2,fs,'D2')
main_aacencoderD(D3,fs,'D3')
main_aacencoderD(D4,fs,'D4')
