% Written by Benedetta Cecconi and Carlo Alberto Avizzano

% This function generates a sequence of 30 trials interspersed with silences  
% varying between .7 and 1 second.
%The total average duration of trial + silence is 1.5s
%for a total of 45 seconds.
%
%
% There are implicit calculations:
% The total length of the experiments is 650ms*30 =19500ms
% So the total pause time will be 45000-19500= 25500
% Since the granularity of the intervals is 50ms and I have a 
% function ("RandomPauses") that works with integers I work dividing these values by 50
% that is, I represent the vector 700:50:1000 as
% (14:1:20)*50 and 25500 becomes 510*50.
% So I call RandomPauses with (510,29,10,20)
% sum(ODDBALL.RandomPauses(510,29,10,20)*50)
%      ans = 25500

%  s --> standard events
%  w --> ISI
%  d --> deviant events
%  i --> ITI
%  p --> silence/pause blocks

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


