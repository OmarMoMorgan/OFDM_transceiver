function [number_bits] = get_number_bits(fft_size,symbol_size,mod_scheme,conv_rate,pilots_count_per_symbol)

symbols_needded_for_mod = (fft_size-pilots_count_per_symbol)*symbol_size*conv_rate;

if (mod_scheme == "BPSK")
    %number_bits = ((fft_size*conv_rate)- pilots_count_per_symbol)*14;
    number_bits = symbols_needded_for_mod;
elseif (mod_scheme == "QPSK")
    %number_bits = ((fft_size*conv_rate)- pilots_count_per_symbol)*14*2;
    number_bits = symbols_needded_for_mod*2;
elseif (mod_scheme == "16QAM")
    number_bits = symbols_needded_for_mod*4;
elseif (mod_scheme == "64QAM")
    number_bits = symbols_needded_for_mod*4*6;
else
  number_bits = symbols_needded_for_mod*4;
end