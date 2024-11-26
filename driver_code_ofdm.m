
pn_order = 11;
init_state = ones(1,pn_order);
length_input = 1024;
SNR = 45;


%pn sequence genertor
input = pn_seq_gen(pn_order,init_state,length_input);



%scrambler 
out_scrmabler=scrambler(input);

%modulator
%PlotConstellation=true
qpsk_obj = comm.QPSKModulator('BitInput',true);
modulated_sig = qpsk_obj(out_scrmabler');
qpsk_obj.constellation
scatterplot(modulated_sig,4)

%ifft
after_ifft = ifft(modulated_sig,512);

%apply noise
after_channel = awgn(after_ifft,SNR);



%reciever
after_fft = fft(after_channel,512);

qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);

%pass by fft


rec_signal = qpskDemodulator(after_fft)';
scatterplot(after_fft)




final_sig = scrambler(rec_signal);
biterr(final_sig,input)
%test_scram = input== final_sig

