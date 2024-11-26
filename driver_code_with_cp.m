
pn_order = 11;
init_state = ones(1,pn_order);
length_input = 1024*12;
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

%the serial to parralle block
the_block = reshape(modulated_sig,[512,12]);


%ifft
after_ifft = ifft(the_block,512,1);

%add cp
after_ifft = [after_ifft(1:height(the_block),10:12), after_ifft] ;
serr_sig = reshape(after_ifft,[],1);

%apply noise
rayleighchan = comm.RayleighChannel( ...
    'SampleRate',10e3, ...
    'PathDelays',[0 1.5e-4], ...
    'AveragePathGains',[105 0]);


after_channel = awgn(after_ifft,SNR);
after_channel = rayleighchan(serr_sig);

after_channel = filter([2,2],1,serr_sig);
after_channel(1:length(15*512));
after_channel = reshape(after_channel,[512,15]);

%reciever
after_fft = fft(after_channel,512,1);

qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);

%pass by fft

%p/s
%after_fft(1:height(after_fft),3:14);
after_fft = after_fft(1:height(after_fft),3:15);
rec_after_fft = after_fft(:);

rec_signal = qpskDemodulator(rec_after_fft)';
scatterplot(rec_after_fft)




final_sig = scrambler(rec_signal);
biterr(final_sig,input)
%test_scram = input== final_sig

