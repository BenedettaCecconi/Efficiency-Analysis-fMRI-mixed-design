% % Questa funzione genera un esperimenti Classic 
% prende un parametro per discriminare tra ABBA e Interleaved
% Utilizzo:
%
%    ExperimentClassic(mode, blockGenerator)
%
% mode == 'abba'
% mode == 'inter'
%
%
% blockGenerator is a lambda function that call backs the function
% generating individual blocks
% 
% Example of lambdas
%      classic = @(isDev, IBI) ODDBALL.BlockClassic(isi, IBI)
%      Mixed37 = @(isDev, IBI) ODDBALL.BlockMixed(isi, IBI, 30, 3, 7)
%      Mixed35 = @(isDev, IBI) ODDBALL.BlockMixed(isi, IBI, 30, 3, 5)
%
%         
% Legenda s --> standard
% Legenda w --> wait 100ms dur_ms (ISI)
% Legenda d --> deviant
% Legenda i --> iti
% Legenda p --> silence/pause

function [exp,len] = ExperimentClassic(mode, blockGenerator)
    experiment = struct;
    experiment.nblocks = 17;
    experiment.blength = 45;
    experiment.minpause = 7;
    experiment.maxpause = 10;
    experiment.length = 900;

    % Estimating total time for pauses
    experiment.npauses = experiment.nblocks -1;
    experiment.totalpauses = experiment.length - experiment.blength*experiment.nblocks;
    
    rp = ODDBALL.RandomPauses(experiment.totalpauses, experiment.npauses,...
                   experiment.minpause, experiment.maxpause)*1000;
    experiment.IBIes = [rp, 0];

    exp.onset = [];
    exp.action = [];
    exp.freq = [];
    exp.dur_ms = [];
    exp.deviantBlock = [];


%function [block, blocktime] = append_block_rnd(block, experiment, choice, sil)
%end 
    if strcmp(mode,'abba') == 1
            task_type= [0 1];
        for cycle = 1:2:(experiment.nblocks-3)
            if rand<0.5
                task_type = [ 0 1 task_type];
            else
                task_type = [ 1 0 task_type];
            end
        end
        % For odd length adding a negate start input
        if mod(experiment.nblocks,2)==1
            % Primo complementare al secondo
            startTT = 1 - task_type(1);
            % Alternativa
            % primo completamente a caso
            % startTT = randi(2)-1; 
            task_type = [ startTT task_type];
        end
    elseif strcmp(mode, 'inter')==1
        task_type=[];
        % modo interleaved ammette abab oppure bababa
%         if rand<0.5
%             model = [ 0 1 task_type];
%         else
%             model = [ 1 0 task_type];
%         end
%         for cycle = 1:2:(experiment.nblocks)
%             task_type = [ model task_type];
%         end    
%         % For odd length adding a negate start input
%         if mod(experiment.nblocks,2)==1
%             % Primo complementare al secondo
%             startTT = 1 - task_type(1);
%             task_type = [ startTT task_type];
%         end
         if mod(experiment.nblocks,2)==0
             task_type = repmat([0,1], 1, experiment.nblocks/2);
         else
             task_type = [1 repmat([0,1], 1, (experiment.nblocks-1)/2)];
         end
    else
        error('Unknown mode');
    end

    starttime = 0;
    if nargout == 0
        disp(task_type)
    end

    for cycle = 1:numel(task_type)
        [blk, blk_len] = blockGenerator(task_type(cycle), experiment.IBIes(cycle));
        blk.onset = blk.onset+starttime;
        starttime = starttime + blk_len;
        blk.deviantBlock = task_type(cycle)*ones(1, numel(blk.onset));
        exp = ODDBALL.joinFieldVects(exp, blk);
    end
    len = starttime;
    if nargout == 0
        exp
        len
    end    
end

