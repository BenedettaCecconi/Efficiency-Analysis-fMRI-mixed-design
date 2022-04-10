% % Questa funzione genera un trial di tipo Classic
%   Una sequenza ssssd
%
%  Usage: TrialRoving(isDeviant, iti, n_std)
%  isDeviant set to 1 for deviant trial type
%  iti set final pause in ms
% 
% Legenda s --> standard
% Legenda w --> wait 100ms dur_ms (ISI)
% Legenda d --> deviant
% Legenda i --> iti
% Legenda p --> silence/pause

function [trial, length] = TrialRoving(isDeviant, iti, freq)
    n_elem = 1 + randi(10); % numero di stimoli
    [trial, length] = ODDBALL.TrialClassic(0, iti, n_elem, freq);
    if isDeviant == 1
        trial.action(1) = 'd';
    end
    if nargout == 0
        trial 
        length
    end
end

