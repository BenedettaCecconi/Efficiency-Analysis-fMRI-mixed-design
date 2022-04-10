% Questa funzione genera una sequenza variabile di stimoli
% intervallati da silenzi da silenzi variabili tra .7 e 1 secondo.
% per un totale di 45 secondi.
%
% function [blk, len] = BlockRoving(isDeviant, blockPause, ntrial)
%
% minStim = numero minimo di stimoli 
% maxStim = numero massimo di stimoli
% vi sono dei calcoli impliciti:
% il tempo totale delle pause sarà determinato di conseguenza
% dopo aver generato i trial senza pause!!
% per i dettagli vedi blocco classico
% Legenda s --> standard
% Legenda w --> wait 100ms dur_ms (ISI)
% Legenda d --> deviant
% Legenda i --> iti
% Legenda p --> silence/pause

function [blk, len] = BlockRovingTrialConstr(isDeviant, blockPause, mintrial,maxtrial)
    block = struct;
    block.minpause = 700;
    block.maxpause = 1000;
    block.steppause = 50; 
    block.length_ms = 45000;

    block.freqs= 500:50:800; % Frequenza per lo stimolo standard

    rand_pick = @(V) V(randi(numel(V))); % estraggo elemento a caso 
    freq_standard = rand_pick(block.freqs);
    freq = freq_standard;

    while 1
        ntrial = mintrial-1 + randi(maxtrial-mintrial);
        trialSet = cell(1,ntrial);
        trialLen = zeros(1,ntrial);
        try
            for trial = 1:ntrial
            % scelgo la frequenza da utilizzare
                if isDeviant == 0
                    freq = freq_standard;
                else
                    % qui sono in un blocco deviant
                    % voglio garantire di cambiare sempre la frequenza tra tutti i
                    % trial
                    freq_old = freq;
                    while freq == freq_old
                        % mi garantisco di avere una frequenza diversa
                        freq = rand_pick(block.freqs);
                    end
                end
                [trialSet{trial}, trialLen(trial)] = ODDBALL.TrialRoving(isDeviant, 0, freq);
            end
        catch
            warning('retrying with new trials')
            continue
        end
        break
    end

    % Estimating total time for pauses
    block.pauses = ntrial -1;
    block.totalpauses = block.length_ms - sum(trialLen);    
    rp = ODDBALL.RandomPauses(...
            block.totalpauses/block.steppause,...
            block.pauses,...
            block.minpause/block.steppause,...
            block.maxpause/block.steppause)*block.steppause;
    block.ITIes = [rp, blockPause];


    blk.onset = [];
    blk.action = [];
    blk.freq = [];
    blk.dur_ms = [];

    starttime=0; 

    for trial = 1:ntrial
        trialSet{trial}.onset = trialSet{trial}.onset + starttime;
        trialSet{trial}.dur_ms(end) = block.ITIes(trial);
        blk = ODDBALL.joinFieldVects(blk, trialSet{trial});
%        trialSet{trial}.action
        starttime = starttime + trialLen(trial) + block.ITIes(trial);
    end


    blk.action(end) =  'p';
    len = starttime;
    % Se non assegno i valori allora mostro il risultato a schermo
    if nargout == 0
        blk
        len
    end
end


