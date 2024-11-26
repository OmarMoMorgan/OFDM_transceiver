function [modulated_sig] = modulator(input_bits,type_modulation)
%this function is repsonsible for modulation on different types like qpsk
%bpsk qam
%the input_bits should be any sequence of 1s and 0s in the form [1,x]
%also it is expected to be in the format of logical ones and zeros 
%the availbe inputs for type modulation are QPSK, BPSK, 16QAM, 64QAM
%if the option is not availble it willl default to QPSK

input_bits = int8(input_bits);

if type_modulation == "QPSK"
    %qpsk_obj = comm.QPSKModulator('BitInput',true);
    modulated_sig = pskmod(input_bits',4,pi/4,InputType="bit");
elseif type_modulation == "BPSK"
    modulated_sig = pskmod(input_bits',2,InputType='bit');
elseif type_modulation == "16QAM"
    %divsion is to unify the power being sent
    modulated_sig = qammod(input_bits',16,InputType='bit')/3;
elseif type_modulation == "64QAM"
    %divsion is to unify the power being sent
    modulated_sig = qammod(input_bits',64,InputType="bit")/7;
else %the default case 
    disp('the type of modulation asked for is currently not supported defaulted to QPSK');
    modulated_sig = pskmod(input_bits',4,InputType="bit");
end

%avg_power = mean(abs(modulated_sig).^2);

%modulated_sig = modulated_sig / sqrt(avg_power);


end