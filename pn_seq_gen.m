function [input_ofdm] = pn_seq_gen(pn_order,init_state,length_input)
%this is the fnction that generate the pn sequence 

if pn_order == 23
    if length(init_state) < 23
        init_state = [init_state ones(1,23-length(init_state))];
    end
    pnSequence = comm.PNSequence('Polynomial',[23,5,0],'SamplesPerFrame',length_input,'InitialConditions',init_state);
elseif pn_order == 15
    if length(init_state) < 15
        init_state = [init_state ones(1,15-length(init_state))];
    end
    pnSequence = comm.PNSequence('Polynomial',[15 14 0],'SamplesPerFrame',length_input,'InitialConditions',init_state);
elseif pn_order == 11
    if length(init_state) < 1
        init_state = [init_state ones(1,1-length(init_state))];
    end
    pnSequence = comm.PNSequence('Polynomial',[11 2 0],'SamplesPerFrame',length_input,'InitialConditions',init_state);
end
input_ofdm = pnSequence()';

end

