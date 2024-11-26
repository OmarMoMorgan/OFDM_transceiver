%this is the main file for assignment 2 for 5G diploma in siemens 
%we are trying to implement an OFDM system from scratch

%the paramters that will be needed
%feel free to change this paramters 
close all

pn_order = 11;   %the available options are 11,15,23
init_state = ones(1,pn_order);
length_input = 1024;
SNR = 30;
moduation_type = "QPSK";
fft_size = 1024;


modulation_methods = ["BPSK","QPSK","16QAM","64QAM"];
mod_order = [1,2,4,6];
fft_size_arr = [512,512,512,512]*8;
length_ofinput = [512,1024,2048,3072]*8;
err_matrix = zeros(4,41);
num_avg = 2;

err_arr_bpsk = zeros(1,41);
for mod_num = 1:4
    counter = 0;
    for snr_loop = -10:30
        the_avg = 0;
        for take_avg = 0:num_avg
            the_avg = the_avg + ofdm_for_plots(pn_order, init_state, length_ofinput(mod_num), modulation_methods(mod_num), fft_size_arr(mod_num), snr_loop);
        end
        err_matrix(mod_num,counter+1) = the_avg/(num_avg+1);
        counter = counter + 1;
    end
end

%plot(0:40,err_matrix);
custom_colors =['r','b','g','y'];
hold on;
for i = 1:length(modulation_methods)
    plot(-10:30, err_matrix(i, :), 'Color', custom_colors(i), 'LineWidth', 1.5);
end
legend(modulation_methods);
hold off;
% chleg = get(hleg,'children')
% set(chleg(1),'color','r')
% set(chleg(2),'color','g')
% set(chleg(3),'color','y')
% set(chleg(4),'color','b')

%plot(0:40,err_arr_bpsk);