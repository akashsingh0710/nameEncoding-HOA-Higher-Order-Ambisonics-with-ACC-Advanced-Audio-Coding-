
function  main_aacencoder(signal,fs,string)
format long
% Hamming Window
load longwindow.
% scale factor offset for scaling
load sfb_offset.mat


MAX_SFB = 43;
y = signal;
nbits = 16;
if(fs ~= 44100 || nbits ~= 16)
    disp('Not supported - Only 44100 Mono files');
    return;
end

fp = fopen(strcat('.\Encoded_Dformat\encoded_',string,'.aac'),'w');
y = y*2^15;
y=[zeros(1,1024) y']';
len = fix(length(y)/1024);
y = reshape(y(1:len*1024),1024,len)';
long = long_window;
for frame_index = 1:len - 1
    % Windowing the signal
    wf = [y(frame_index,:) y(frame_index+1,:)];
    wf = wf.*[long flipud(long')'];
    % Calculating MDCT coefficient
    wf = mdct4(wf)'.*sqrt(512);   
    wf = wf.*4;
    wf(744:end) = 0;
    mdct_coeff = wf;
    % No MS Encode, since we are working on Mono stream    
    % Quantizing the MDCT_Coefficients    
    xr_pow = abs(mdct_coeff).^(3/4);    
    % Compute the ScaleFactor and Quantized MDCT-Coefficients
    % Minimal logic    
    mdct_coeff_quant = [];
    max_sfb_encoded = MAX_SFB;
    scale_factors = zeros(1,max_sfb_encoded);
    % You can call below as stupid Inner loop !! or Even Pathetic Rate
    % control, even though there is no rate to control :)
    
    for sfb_offind=1:max_sfb_encoded
        
        max_coeff = max(xr_pow([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)]));% 0.0001 to avoid 1/0 -> Inf
        avg_coeff = sum(xr_pow([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)]))/4;
        maxsf_start = fix((log10(1/max_coeff)/log10(2^(3/16))) - 0.5);
        
        % SF_OFFSET = 100;
        % MAGIC_NUMBER = 0.4054
        % x_quant = int (( abs( mdct_line ) * (2^((- 1/4) * (sf_decoder - 100))) )^(3/4) + 0.405)
        arr = xr_pow([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)]);
        x_unquant = abs(mdct_coeff([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)]));
        x_quant = zeros(1,length(arr));
        while maxsf_start < -39
            
            x_quant = fix(arr.*((2^(maxsf_start/4))^(3/4)));
            % Inverse quantize and check average
            x_iquant = (x_quant.^(4/3))./(2^(maxsf_start/4));
            if( mean(x_iquant) > (mean(x_unquant)/1.3))
                maxsf_start = maxsf_start + 1;                
                break;
            end
            maxsf_start = maxsf_start + 1;
        end
        scale_factors(sfb_offind) = maxsf_start;
        if(max_coeff <=0)
            scale_factors(sfb_offind) = 0;
        end
        mdct_coeff_quant = [mdct_coeff_quant x_quant];            
    end
    
    global_gain = 0; % No Inner and Outer loops, so no gg :)
    % Add sign's
    mdct_coeff_quant(find(mdct_coeff <0)) = mdct_coeff_quant(find(mdct_coeff <0)).*-1;
    
    % What we have at this point
    % 1. We have mdct_coeff_quant, which will be used for Noiseless coding
    % 2. We also have scale_factors, which will be differentially coded
    
    % Lets assign codebooks directly, with out calculating the number of
    % bits, later we will do that too, explained below. (Because we do not
    % have any kind of rate control, so why to calculate bits, assume (May
    % not be best, but what the F$%^)
    % Read Read_Me.m, given with this folder
    
    codebook_used_sfb = zeros(1,43);
    
    for temp_len = 1: length(mdct_coeff_quant)
        if((mdct_coeff_quant(temp_len)) > 12)
            mdct_coeff_quant(temp_len) = 12;
        elseif ((mdct_coeff_quant(temp_len)) < -12)
            mdct_coeff_quant(temp_len) = -12;
        end           
    end
    
     for sfb_offind=1:max_sfb_encoded
         max_abs_quant_coeff = max(abs(mdct_coeff_quant([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)])));
      
         if(max_abs_quant_coeff == 0)
             codebook_used_sfb(sfb_offind) = 0;
         elseif(max_abs_quant_coeff < 2)
             codebook_used_sfb(sfb_offind) = 2; % Signed
         elseif(max_abs_quant_coeff < 3)
             codebook_used_sfb(sfb_offind) = 4; % Not signed
         elseif(max_abs_quant_coeff < 5)
             codebook_used_sfb(sfb_offind) = 6; % Signed
         elseif(max_abs_quant_coeff < 8)
             codebook_used_sfb(sfb_offind) = 8; % or use 7 Not Signed
         elseif(max_abs_quant_coeff < 13)
             codebook_used_sfb(sfb_offind) = 9; % Not Signed
         else
             codebook_used_sfb(sfb_offind) = 11;% Not Signed         
         end         
     end
     
     
     % offset the difference of common_scalefac and scalefactors by
     % SF_OFFSET (100)
     
     scale_factors = global_gain - scale_factors + 100; % 100 is SF_OFFSET     
     global_gain = scale_factors(1);
     
     % Noiseless Coding -> Huffman Coding
     % Noiseless Coding of spectral data
     data_code = [];
     data_length = [];
     [data_code, data_length] = huffmancode_specdata(max_sfb_encoded, mdct_coeff_quant, codebook_used_sfb);  
     
     bitstream = [];
     bitstream = bitstream_pack_data(global_gain, max_sfb_encoded, codebook_used_sfb, scale_factors, data_code, data_length);
     
     temp = bin2dec(reshape(bitstream,8,fix(length(bitstream)/8))')';     
     fwrite(fp,temp,'uint8');     
     
     disp([ '...' int2str(frame_index) '...']);

 end  % Main Encoder Frame loop 
 disp('....End....');
 fclose(fp);
end