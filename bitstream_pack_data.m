function bitstream = bitstream_pack_data(global_gain, max_sfb_encoded, codebook_used_sfb, scale_factors, data_code, data_length);
% ------- AAC Encoder ------------------------------------------
% Ravi Lakkundi
% ----------------------------------------------------------

load huff12.mat
% Writing the bitstream data
     % writing ADTS Header - Fixed + Variable - Check Read_me.m
     % 0xFF 0xF1 0x50 0x40 0x16 0xDF 0xFC - For the assumption what we have
     % already made
     bitstream = [];
     
     % fwrite(fp,[256 241 80 64 22 223 252],'uint8'); % - For the assumption what we have, 44100, Mono
     bitstream = [bitstream dec2bin(255,8) dec2bin(241,8) dec2bin(80,8) dec2bin(64,8) dec2bin(22,8) dec2bin(223,8) dec2bin(252,8)];
     % WriteSCE, LEN_SE_ID - 3, LEN_TAG - 4
     % Write ID_SCE and Element Instance Tag, in our case both are zero, so
     % write 7 bits (3+4)
     % Later write Global_gain (8 bits) xxxxxxxx
     % 000 0000 x xxxxxxx
     bitstream = [bitstream dec2bin(0,3) dec2bin(0,4) dec2bin(global_gain,8)];
     % 0000000x xxxxxxxi    -> i - ics_reserve bit, which is zero, so
     % essentially write global_gain shifted by left once in 2 byte
     bitstream = [bitstream dec2bin(0,1)];
     
%      if(mod(length(bitstream),8) == 0)
%          temp = bin2dec(reshape(bitstream,8,fix(length(bitstream)/8))')';
%          fwrite(fp,temp,'uint8');
%          bitstream = [];
%      end
     
     % After ics_reserved, put window type and window_shape
     % In our case its All long, currently
     bitstream = [bitstream dec2bin(0,2) dec2bin(0,1)];
     bitstream = [bitstream dec2bin(max_sfb_encoded,6)];
     % pred_global_flag, currently zero
     bitstream = [bitstream dec2bin(0,1)];
     % Write the codebooks used for all subbands, here max_sfb_encoded
     % codebook is sorted
     % Since all long blocks are assumed the escape data is coded as 31
     % and in 5 bits
     % [10 8 6 6 6 6 5 5 7 8 8 8 8] is represented as
     % [10 1 8 1 6 4 5 2 7 1 8 4]
     
     % Below to be improved
     counter_cb = 1;
     sort_cb = [];
     for sortindex = 1:max_sfb_encoded-1
         if(codebook_used_sfb(sortindex) ~= codebook_used_sfb(sortindex+1))
             if(counter_cb <= 31) 
                 sort_cb = [sort_cb codebook_used_sfb(sortindex) counter_cb];
             elseif (counter_cb > 31)
                 sort_cb = [sort_cb codebook_used_sfb(sortindex) 31 sort_cb codebook_used_sfb(sortindex) counter_cb-31];
             end
             counter_cb = 0;
         end
         counter_cb = counter_cb + 1;
     end
     if(counter_cb > 1)
         sort_cb = [sort_cb codebook_used_sfb(sortindex) counter_cb];
     else
         sort_cb = [sort_cb codebook_used_sfb(sortindex+1) counter_cb];
     end
     
     for sortindex = 1:2:length(sort_cb)
         bitstream = [bitstream dec2bin(sort_cb(sortindex),4) dec2bin(sort_cb(sortindex+1),5)];
     end
     
     diff_scalefactors=filter([1 -1],1,scale_factors);
     diff_scalefactors(1) = 0; % Gloal_Gain - Scalefactor
     
     for sortindex = 1:length(diff_scalefactors)
         if(diff_scalefactors(sortindex) < 60 & diff_scalefactors(sortindex) >= -60)
             if(codebook_used_sfb(sortindex) ~= 0)
                 bitstream = [bitstream dec2bin(huff12(diff_scalefactors(sortindex)+60+1,2),huff12(diff_scalefactors(sortindex)+60+1,1))] ;
             end
         else
             disp('I should be dead now !! diff scale factors <60 & >= -60');
         end
     end
     
     % Pulse data not present
     bitstream = [bitstream dec2bin(0,1)];
     % TNS data not present
     bitstream = [bitstream dec2bin(0,1)];
     % Gain Control data not present
     bitstream = [bitstream dec2bin(0,1)];
     
     % Write spectral data
     for k=1:length(data_code)
         if(data_length(k) > 0)
             bitstream = [bitstream dec2bin(data_code(k), data_length(k))];
         end
     end
     
     % Write ID_END
     bitstream = [bitstream dec2bin(7,3)];
     
     byte_align = 8 - mod(length(bitstream),8);
     
     if(byte_align > 0)
         bitstream = [bitstream dec2bin(0,byte_align)];
     end  