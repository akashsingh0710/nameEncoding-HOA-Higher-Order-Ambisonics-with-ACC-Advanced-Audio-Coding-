function [data_code, data_length] = huffmancode_specdata(max_sfb_encoded, mdct_coeff_quant, codebook_used_sfb);
% ------- AAC Encoder ------------------------------------------
% Ravi Lakkundi
% ----------------------------------------------------------

load huffman_tables.mat
load sfb_offset.mat

counter = 1;
     data_code = [];
     data_length = [];
     
     for sfb_offind=1:max_sfb_encoded
         arr = mdct_coeff_quant([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)]);
         len = length([sfb_offset(sfb_offind)+1 : sfb_offset(sfb_offind + 1)]);
         codebook_number = codebook_used_sfb(sfb_offind);
         
         switch codebook_number
             case 0,
                 data_code(counter) = 0;
                 data_length(counter) = 0; 
                 counter = counter + 1;
             case 1, % Signed codebook
                 for k = 1:4:len
                     index = 27*(arr(k)) + 9*(arr(k+1)) + 3*(arr(k+2)) + (arr(k+3)) + 40;
                     data_code(counter) = huff1(index+1,2);
                     data_length(counter) = huff1(index+1,1);      
                     counter = counter + 1;
                 end
             case 2, % Signed codebook
                 for k = 1:4:len
                     index = 27*(arr(k)) + 9*(arr(k+1)) + 3*(arr(k+2)) + (arr(k+3)) + 40;
                     data_code(counter) = huff2(index+1,2);
                     data_length(counter) = huff2(index+1,1);      
                     counter = counter + 1;
                 end
             case 3, % Unsigned Codebook
                 for k = 1:4:len
                     index = 27*abs(arr(k)) + 9*abs(arr(k+1)) + 3*abs(arr(k+2)) + abs(arr(k+3));
                     data_code(counter) = huff3(index+1,2);
                     data_length(counter) = huff3(index+1,1);
                     counter = counter + 1;
                     % Since codebook is unsigned, append signs in
                     % data_code
                     for j=1:4
                         if(arr(k+j-1) >0)
                             data_code(counter) = 0;
                             data_length(counter) = 1;
                         elseif(arr(k+j-1) < 0)
                             data_code(counter) = 1;
                             data_length(counter) = 1;
                         end
                         counter = counter + 1;
                     end
                 end
             case 4, % Unsigned Codebook
                 for k = 1:4:len
                     index = 27*abs(arr(k)) + 9*abs(arr(k+1)) + 3*abs(arr(k+2)) + abs(arr(k+3));
                     data_code(counter) = huff4(index+1,2);
                     data_length(counter) = huff4(index+1,1);
                     counter = counter + 1;
                     % Since codebook is unsigned, append signs in
                     % data_code
                     for j=1:4
                         if(arr(k+j-1) >0)
                             data_code(counter) = 0;
                             data_length(counter) = 1;
                         elseif(arr(k+j-1) < 0)
                             data_code(counter) = 1;
                             data_length(counter) = 1;
                         end
                         counter = counter + 1;
                     end
                 end
             case 5, % Signed codebook
                 for k = 1:2:len
                     index = 9*arr(k) + arr(k+1) + 40;
                     data_code(counter) = huff5(index+1,2);
                     data_length(counter) = huff5(index+1,1);      
                     counter = counter + 1;
                 end
             case 6, % Signed codebook
                 for k = 1:2:len
                     index = 9*arr(k) + arr(k+1) + 40;
                     data_code(counter) = huff6(index+1,2);
                     data_length(counter) = huff6(index+1,1);      
                     counter = counter + 1;
                 end
             case 7, % Unsigned Codebook
                 for k = 1:2:len
                     index = 8*abs(arr(k)) + abs(arr(k+1));
                     data_code(counter) = huff7(index+1,2);
                     data_length(counter) = huff7(index+1,1);
                     counter = counter + 1;
                     % Since codebook is unsigned, append signs in
                     % data_code
                     for j=1:2
                         if(arr(k+j-1) >0)
                             data_code(counter) = 0;
                             data_length(counter) = 1;
                         elseif(arr(k+j-1) < 0)
                             data_code(counter) = 1;
                             data_length(counter) = 1;
                         end
                         counter = counter + 1;
                     end
                 end
             case 8, % Unsigned Codebook
                 for k = 1:2:len
                     index = 8*abs(arr(k)) + abs(arr(k+1));
                     data_code(counter) = huff8(index+1,2);
                     data_length(counter) = huff8(index+1,1);
                     counter = counter + 1;
                     % Since codebook is unsigned, append signs in
                     % data_code
                     for j=1:2
                         if(arr(k+j-1) >0)
                             data_code(counter) = 0;
                             data_length(counter) = 1;
                         elseif(arr(k+j-1) < 0)
                             data_code(counter) = 1;
                             data_length(counter) = 1;
                         end
                         counter = counter + 1;
                     end
                 end
             case 9, % Unsigned Codebook
                 for k = 1:2:len
                     index = 13*abs(arr(k)) + abs(arr(k+1));
                     data_code(counter) = huff9(index+1,2);
                     data_length(counter) = huff9(index+1,1);
                     counter = counter + 1;
                     % Since codebook is unsigned, append signs in
                     % data_code
                     for j=1:2
                         if(arr(k+j-1) >0)
                             data_code(counter) = 0;
                             data_length(counter) = 1;
                         elseif(arr(k+j-1) < 0)
                             data_code(counter) = 1;
                             data_length(counter) = 1;
                         end
                         counter = counter + 1;
                     end
                 end
             case 10, % Unsigned Codebook
                 for k = 1:2:len
                     index = 13*abs(arr(k)) + abs(arr(k+1));
                     data_code(counter) = huff10(index+1,2);
                     data_length(counter) = huff10(index+1,1);
                     counter = counter + 1;
                     % Since codebook is unsigned, append signs in
                     % data_code
                     for j=1:2
                         if(arr(k+j-1) >0)
                             data_code(counter) = 0;
                             data_length(counter) = 1;
                         elseif(arr(k+j-1) < 0)
                             data_code(counter) = 1;
                             data_length(counter) = 1;
                         end
                         counter = counter + 1;
                     end
                 end
             case 11,
                 disp('Unfortunately iam here for this stream');% Write code now
             otherwise,
                 disp('I cannot come, check quantization and codebook assignment');% Write code now
         end % Switch end
     end  % Noiseless Coding End