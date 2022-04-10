% % Questa funzione genera un trial di tipo Classic
%   Una sequenza ssssd
%
%  Usage: TrialClassic(isDeviant, iti, n_std)
%  isDeviant set to 1 for deviant trial type
%  iti set final pause in ms
% 
% Legenda s --> standard
% Legenda w --> wait 100ms dur_ms (ISI)
% Legenda d --> deviant
% Legenda i --> iti
% Legenda p --> silence/pause

function [trial, length] = TrialClassic(isDeviant, iti, n_std, override_freq)
    if nargin <2 or nargin >4
        help ODDBALL.TrialClassic
        error('Two or three parameters were expected')
    end
    if nargin == 2
        n_std = 4;
    end
    stimuli = struct;
    stimuli.std.freq=100; % Frequenza per lo stimolo standard
    stimuli.std.dur_ms = 50; % durata in ms dello stimolo standard
    stimuli.dev.freq=400; % Frequenza per lo stimolo deviant
    stimuli.dev.dur_ms = 50; % durata in ms dello stimolo deviant
    stimuli.isi.dur_ms = 100;% pausa di attesa tra due stimoli
    stimuli.seq_nodev= [repmat(['s','w'],1, n_std), 's','i']; 
    stimuli.seq_dev= [repmat(['s','w'],1, n_std),'d','i']; 

    if nargin == 4
        stimuli.std.freq = override_freq;
    end
    trial.onset = [];
    trial.action = [];
    trial.freq = [];
    trial.dur_ms = [];


    if isDeviant == 1
        seq = stimuli.seq_dev;
    else
        seq = stimuli.seq_nodev;
    end

    startime = 0;

    for i = 1:numel(seq)
        trial.onset = [trial.onset, startime];
        action = seq(i);
        trial.action = [trial.action, action];
        
        switch action
            case 's'
                trial.freq = [trial.freq, stimuli.std.freq];
                trial.dur_ms = [trial.dur_ms, stimuli.std.dur_ms];
            case 'w'
                trial.freq = [trial.freq, 0];
                trial.dur_ms = [trial.dur_ms, stimuli.isi.dur_ms];
            case 'd'
                trial.freq = [trial.freq, stimuli.dev.freq];
                trial.dur_ms = [trial.dur_ms, stimuli.dev.dur_ms];
            case 'i'
                trial.freq = [trial.freq, 0];
                trial.dur_ms = [trial.dur_ms, iti];
        end
        startime = startime + trial.dur_ms(end);
    end
    length = startime;
    % Se non assegno i valori allora mostro il risultato a schermo
    if nargout == 0
        trial 
        length
    end
end

