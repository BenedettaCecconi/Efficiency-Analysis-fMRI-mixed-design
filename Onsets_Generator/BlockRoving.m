% Written by Benedetta Cecconi and Carlo Alberto Avizzano 

% This function generates a variable sequence of stimuli
% interspersed with variable silences between .7 and 1 second.
% For a total of 45 seconds.
%
% function [blk, len] = BlockRoving(isDeviant, blockPause, ntrial)
%
%  minStim = minimum number of stimuli 
%  maxStim = maximum number of stimuli

% There are implicit calculations:
% the total time of the breaks will be determined after generating the trials without pauses!
% For more details see classic block

function [blk, len] = BlockRovingTrialConstr(isDeviant, blockPause, mintrial,maxtrial)
    block = struct;
    block.minpause = 700;
    block.maxpause = 1000;
    block.steppause = 50; 
    block.length_ms = 45000;

    block.freqs= 500:50:800; % Frequency of standard stimulus

    rand_pick = @(V) V(randi(numel(V))); % I extract element randomly 
    freq_standard = rand_pick(block.freqs);
    freq = freq_standard;

    while 1
        ntrial = mintrial-1 + randi(maxtrial-mintrial);
        trialSet = cell(1,ntrial);
        trialLen = zeros(1,ntrial);
        try
            for trial = 1:ntrial
            % I choose the frequency 
                if isDeviant == 0
                    freq = freq_standard;
                else
                    % % this is a deviant block
                    % I want to ensure that I always change the frequency between all the
                    % trials
                    freq_old = freq;
                    while freq == freq_old
                        % I ensure to have a different frequency
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
    % If I don't assign values then I show the result on screen
    if nargout == 0
        blk
        len
    end
end


