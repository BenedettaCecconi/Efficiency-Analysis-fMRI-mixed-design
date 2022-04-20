% Written by Benedetta Cecconi and Carlo Alberto Avizzano 


%This function generates a trial of type Classic or, if 
%called with several parameters, a trial of different type (e.g. roving)
%
% 

%     Usage: TrialClassic(isDeviant, iti)
%     isDeviant set to 1 for deviant trial type
%     Sequence ssssdi (deviant == 1) or sssssi (deviant == 0)
%     iti sets the final pause in ms that is calculated at higher level
%
%  Roving use: 
%     Usage: TrialClassic(0, iti, n_std, override_freq)
%     s..#n_std..s with frequency "override_freq"
      %isDeviant here is meaningless and should be left at 0
%
%  s --> standard events
%  w --> ISI
%  d --> deviant events
%  i --> ITI
%  p --> silence/pause blocks

function [trial, length] = TrialClassic(isDeviant, iti, n_std, override_freq)
    if nargin <2 || nargin >4
        help ODDBALL.TrialClassic
        error('Two or four parameters were expected')
    end
    if nargin == 2
        n_std = 4;
    end
    stimuli = struct;
    stimuli.std.freq=100; % Frequency standard stimuli
    stimuli.std.dur_ms = 50; % duration (ms) of standard stimulus
    stimuli.dev.freq=400; % Frequency deviant stimuli
    stimuli.dev.dur_ms = 50; % duration (ms) of deviant stimulus
    stimuli.isi.dur_ms = 100;% isi
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
    % If I don't assign values then I show the result on screen
    if nargout == 0
        trial 
        length
    end
end

