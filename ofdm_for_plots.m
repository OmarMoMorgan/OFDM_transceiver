function [error] = ofdm_for_plots(pn_order, init_state, length_input, moduation_type, fft_size, SNR)
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
after_ifft = ifft(modulated_sig,fft_size);% * sqrt(fft_size);

%apply noise
after_channel = awgn(after_ifft,SNR,"measured");
%after_channel = after_channel + 30;


%reciever
after_fft = fft(after_channel,fft_size);% / sqrt(fft_size);

% qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);

%pass by fft


%rec_signal = qpskDemodulator(after_fft)';
rec_signal = demodulator(after_fft,moduation_type)';
%scatterplot(after_fft)




final_sig = scrambler(rec_signal);
error = biterr(final_sig,input)/length(input);
%test_scram = input== final_sig
end