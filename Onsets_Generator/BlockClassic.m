% Questa funzione genera una sequenza di 30 trial intervallati 
% da silenzi variabili tra .7 e 1 secondo.
% La durata complessiva media di trial + silenzo e' di 1.5s
% per un totale di 45 secondi.
%
%
% vi sono dei calcoli impliciti:
% La lunghezza complessiva degli esperimenti è 650ms*30 =19500ms
% Per cui il tempo totale di pausa sarà 45000-19500= 25500
% Siccome la granularità degli intervalli è 50ms ed ho una 
% funzione (random pauses) che funziona a numeri interi lavoro
% dividendo tali valori per 50
% significa che il vettore 700:50:1000 lo rappresento come
%  (14:1:20)*50 e 25500 diventa 510*50.
% per cui chiamo RandomPauses con (510,29,10,20)
% sum(ODDBALL.RandomPauses(510,29,10,20)*50)
%      ans = 25500
% Legenda s --> standard
% Legenda w --> wait 100ms dur_ms (ISI)
% Legenda d --> deviant
% Legenda i --> iti
% Legenda p --> silence/pause

function [blk, len] = BlockClassic(isDeviant, blockPause)
    block = struct;
    block.ntrial = 30;
    block.minpause = 700;
    block.maxpause = 1000;
    block.steppause = 50; 
    block.length_ms = 45000;

    % Estimating total time for pauses
    [~,basetime] = ODDBALL.TrialClassic(0,0);
    block.pauses = block.ntrial -1;
    block.totalpauses = block.length_ms - basetime*block.ntrial;
    
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
    for trial = 1:block.ntrial
        [tr, len] = ODDBALL.TrialClassic(isDeviant, block.ITIes(trial));
        tr.onset = tr.onset + starttime; % let's shift start time
        starttime = starttime + len; % this includes ITI
        blk = ODDBALL.joinFieldVects(blk, tr);
    end
    blk.action(end) =  'p';
    len = starttime;
    % Se non assegno i valori allora mostro il risultato a schermo
    if nargout == 0
        blk
        len
    end
end


