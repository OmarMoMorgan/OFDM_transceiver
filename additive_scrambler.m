%use the n sequence here
%here we will define the inuts needed
pn_order = 23;
init_cond_23 = [1 1 0 1 0 1 0 1 0 1 0 1 1 0 1 1 0 0 0 0 0 0 1];
init_cond_15 = [1 1 0 1 0 0 0 0 0 1 0 0 0 0 1];
init_cond_11 = [1 1 0 1 0 1 0 1 0 0 1];
%'x^23 + x^18 + 1'
length_input = 1024;


%define the special sequence that will be needed 


the_seq = [];

%input = [];
xorpos = 5;

%output = xor(input(1:end),input(1:))
