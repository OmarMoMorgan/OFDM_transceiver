%this is the main file for assignment 2 for 5G diploma in siemens 
%we are trying to implement an OFDM system from scratch

%the paramters that will be needed
%feel free to change this paramters 
pn_order = 11;   %the available options are 11,15,23
init_state = ones(1,pn_order);
length_input = 1024;
SNR = 70;
moduation_type = "16QAM";
fft_size = 512;
symbol_size = 14;
size_colum = 14;
cp_size = 150;
%h = [2,2.5,3];
%h = [10,2,1.5];
h = ones(1,150);
%h = [1];
h = h/norm(h);
conv_coder_rate = 1/2;
trellis = poly2trellis(3,[6 7]);
st_int = 4831;   %state for interlaver 
pilot_value = 1;   %this number could be anything I just choose this 
                   %since it is in every modulation method, however i could
                   %still choose something absurd like 13 and would still
                   %work what matters is i know it both at the reciever and
                   %transmitter, of course such absurd value would cause
                   %problems in real world scenario since it destroys the
                   %PAPR and amplifiers
pilot_locations = 1:7:fft_size; %again i am making an assumption like 
                                  %IOT systems that one subcarrier would
                                  %contain all the pilots however this
                                  %could still change
                                  
pilot_locations(1) = 2;

%pn sequence genertor
%length_input-2*length(pilot_locations))*symbol_size
length_input = get_number_bits(fft_size,symbol_size,moduation_type,conv_coder_rate,length(pilot_locations));
input = pn_seq_gen(pn_order,init_state,length_input);

%channel coding
codedData = convenc(input,trellis);

%scrambler 
out_scrmabler = scrambler(codedData);

%interleaver using random interleaver just beacuse might investigate about
%other methods later 
out_inter = randintrlv(int8(out_scrmabler),st_int);


tbdepth = 32;

%modulator
modulated_sig = modulator(out_inter, moduation_type);
%scatterplot(modulated_sig)

%adding the pilots, get safe isa
%modulated_sig_with_pilots

%transforming it into a matrix 
matrix_data = reshape(modulated_sig,[],14);
size(matrix_data)
%adding the pilots
counter = 0;
matrix_data = insert_pilot(matrix_data,2,pilot_value,1);
for insertion_pos = 8:7:fft_size
    matrix_data = insert_pilot(matrix_data,insertion_pos,pilot_value,1);
    counter = counter + 1;
end
%matrix_data = 

%ifft
after_ifft = ifft(matrix_data,fft_size) * sqrt(fft_size);

%adding cp
after_cypre = [after_ifft(end-cp_size+1:end,:);after_ifft];

%s/p
out_signal_trans = after_cypre(:);


%apply channel
pfo = comm.PhaseFrequencyOffset(PhaseOffset=45);
phase_offset = pi/6;
after_multipath = conv(out_signal_trans, h);

after_channel_awgn = awgn(after_multipath,SNR,"measured");
noise_signal_only = fft(after_channel_awgn,fft_size) - fft(out_signal_trans,fft_size);

after_channel_awgn = after_channel_awgn;
check_signal = after_channel_awgn;
%after_channel_awgn = after_channel_awgn* exp(1j * phase_offset);
after_channel_awgn = pfo(after_channel_awgn);
%offset_freq_sig = frequencyOffset(after_channel_awgn,1000,10);
%without_offset = after_channel_awgn;
frequency_offset = 0.1;
fake_time = (0:length(after_channel_awgn)-1)';
%after_channel_awgn = after_channel_awgn.* exp(1j * 2 * pi * frequency_offset * fake_time / fft_size);



%reciever
%s/p
after_channel_awgn = after_channel_awgn(1:length(out_signal_trans));
parallel_wrong_freq = reshape(after_channel_awgn,fft_size+cp_size,[]);

%trying to estimate the phase offset using cp
%after_channel_awgn(1:cp_size,1).*after_channel_awgn(end-cp_size+1:end,1);
phase_diffs = angle(sum(parallel_wrong_freq(1:cp_size,:) .* conj(parallel_wrong_freq(end-cp_size+1:end,:))));
freq_offset_est = mean(phase_diffs) / (2 * pi);
inverse_freq = exp(1j * 2 * pi * freq_offset_est * fake_time / fft_size);
%after_channel_awgn = after_channel_awgn.* inverse_freq(1:length(after_channel_awgn));
after_channel_awgn = reshape(after_channel_awgn,fft_size+cp_size,[]);

%phase_est = after_channel_awgn()

%remove cp
without_cp = after_channel_awgn(cp_size+1:end,:);
% phase_est = angle(mean(without_cp(pilot_locations)./pilot_value,"all")); %- 0.065;
%the minus above makes no sense to me now but it provides better emprical
%results 
%without_cp = without_cp.*exp(-1j * phase_est);

%without_cp = deconv(without_cp,h);
% for test_eq = 1:3:fft_size-2
%     without_cp(test_eq:test_eq+2) = without_cp(test_eq:test_eq+2)./h';
% end

after_fft = fft(without_cp,fft_size) / sqrt(fft_size);
%phase estimation offset and correction
phase_est = angle(mean(after_fft(pilot_locations)./pilot_value,"all"));
after_fft = after_fft.*exp(-1j * phase_est);
%calculating the channel this is cheating for now but fine 
h_freq_response = fft(h', fft_size);
%ZF equalization
%after_fft = after_fft ./ h_freq_response;

%wiener filter equalizzation
linear_snr = 10^(SNR/10);
mmse_eq  = conj(h_freq_response) ./ ((abs(h_freq_response).^2) +1/linear_snr);
%second_wiener_part = ((noise_signal_only)./fft(after_ifft,fft_size)).^2;
%mmse_eq = conj(h_freq_response) ./ ((abs(h_freq_response).^2) +(second_wiener_part));
%test_sig = after_fft;
%after_fft = after_fft.*mmse_eq;
% avg_power_transmitted = mean(abs(modulated_sig).^2);
% avg_power_equalized = mean(abs(after_fft(:)).^2);
% after_fft = after_fft * sqrt(avg_power_transmitted / avg_power_equalized);

%lms filtering
% str_lms.step = 1;
% str_lms.filterOrderNo = 40;
% str_lms.initialCoefficients = zeros(41,1);
% [after_ifft,errorVector,coefficientVector] = LMS(after_ifft(:)',after_fft(:)',str_lms);

%removing the pilots
after_fft(pilot_locations,:) = [];

%after_fft = deconv(after_fft,h);
after_fft = after_fft(:);


% qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);

%pass by fft


%rec_signal = qpskDemodulator(after_fft)';
rec_signal = demodulator(after_fft,moduation_type)';
scatterplot(after_fft)

%rec_signal = rec_signal(:);

out_deinter = randdeintrlv(rec_signal,st_int);
final_sig = scrambler(out_deinter);
decodedData = vitdec(final_sig,trellis,tbdepth,'trunc','hard');


biterr(decodedData,input)/length(input)
%test_scram = input== final_sig

