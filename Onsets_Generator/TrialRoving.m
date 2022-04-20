%% Written by Benedetta Cecconi and Carlo Alberto Avizzano 


% This function generates a trial of type Classic:
% A ssssd sequence
%
%  Usage: TrialRoving(isDeviant, iti, n_std)
%  isDeviant set to 1 for deviant trial type
%  iti sets final pause in ms
% 
%  s --> standard events
%  w --> ISI
%  d --> deviant events
%  i --> ITI
%  p --> silence/pause blocks

function [trial, length] = TrialRoving(isDeviant, iti, freq)
    n_elem = 1 + randi(10); % number of stimuli
    [trial, length] = ODDBALL.TrialClassic(0, iti, n_elem, freq);
    if isDeviant == 1
        trial.action(1) = 'd';
    end
    if nargout == 0
        trial 
        length
    end
end

