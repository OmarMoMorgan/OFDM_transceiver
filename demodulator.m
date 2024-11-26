function [demodulated_sig] = demodulator(input_bits,type_modulation)
%this function is repsonsible for modulation on different types like qpsk
%bpsk qam
%the input_bits should be any sequence of 1s and 0s in the form [1,x]
%also it is expected to be in the format of logical ones and zeros 
%the availbe inputs for type modulation are QPSK, BPSK, 16QAM, 64QAM
%if the option is not availble it willl default to QPSK


if type_modulation == "QPSK"
    %qpsk_obj = comm.QPSKModulator('BitInput',true);
    demodulated_sig = pskdemod(input_bits,4,pi/4,OutputType="bit");
elseif type_modulation == "BPSK"
    demodulated_sig = pskdemod(input_bits,2,OutputType="bit");
elseif type_modulation == "16QAM"
    demodulated_sig = qamdemod(3*input_bits,16,OutputType="bit");
elseif type_modulation == "64QAM"
    demodulated_sig = qamdemod(7*input_bits,64,OutputType="bit");
else %the default case 
    disp('the type of modulation asked for is currently not supported defaulted to QPSK');
    demodulated_sig = pskdemod(input_bits,4,OutputType="bit");
end

%demodulated_sig = reshape(demodulated_sig,[],1);
%demodulated_sig = int2bit(demodulated_sig,2);

end