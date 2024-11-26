function [] =  ofdm_simulator
%this is the main file for assignment 2 for 5G diploma in siemens 
%we are trying to implement an OFDM system from scratch

%the paramters that will be needed
%feel free to change this paramters 
pn_order = 11;   %the available options are 11,15,23
init_state = ones(1,pn_order);
length_input = 1024;
SNR = 30;
moduation_type = "QPSK";
fft_size = 512;


%pn sequence genertor
input = pn_seq_gen(pn_order,init_state,length_input);

%scrambler 
out_scrmabler=scrambler(input);

%modulator
%look at the function 
%PlotConstellation=true
% qpsk_obj = comm.QPSKModulator('BitInput',true);
% modulated_sig = qpsk_obj(out_scrmabler');
% qpsk_obj.constellation
% scatterplot(modulated_sig,4)
modulated_sig = modulator(out_scrmabler, moduation_type);

%ifft
after_ifft = ifft(modulated_sig,fft_size);

%apply noise
after_channel = awgn(after_ifft,SNR);



%reciever
after_fft = fft(after_channel,fft_size);

% qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);

%pass by fft


%rec_signal = qpskDemodulator(after_fft)';
rec_signal = demodulator(after_fft,moduation_type)';
scatterplot(after_fft)




final_sig = scrambler(rec_signal);
biterr(final_sig,input)/length(input)
%test_scram = input== final_sig
end