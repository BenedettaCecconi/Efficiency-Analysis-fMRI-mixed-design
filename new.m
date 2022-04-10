% Written by Benedetta Cecconi and Carlo Alberto Avizzano

% Requires two input parameters of type string
%  Blocktype defines which generator of blocks to use
%      'Classic': sequences ssssd
%      'Rowing' : sequences 2-11 with variable frequency + d
%      'Mixed'  : sequences 4-7/etc with fixed frequency for dev/std + d ...
%
%  BlockOrder
%      abba (pseudorandomized)
%      inter (interleaved)

function run = new(Blocktype, Blockorder)
    if nargin ~= 2
        help ODDBALL.new
        return
    end
    run.onset = [];
    run.action = [];
    run.freq = [];
    run.dur_ms = [];

    bt = strcmp(Blocktype, {'Classic', 'Roving', 'Mixed37', 'Mixed35'});
    if sum(bt) == 0
        error('Tipo di esperimento indefinito')
    end

    switch find(bt)
        case 1
            expgen=@ODDBALL.ExperimentClassic;
            blockgen = @(isDev, IBI) ODDBALL.BlockClassic(isDev, IBI);
        case 2
            expgen=@ODDBALL.ExperimentClassic;
            blockgen = @(isDev, IBI) ODDBALL.BlockRovingTrialConstr(isDev, IBI, 22, 31);
        case 3
            expgen=@ODDBALL.ExperimentClassic;
            blockgen= @(isDev, IBI) ODDBALL.BlockMixed(isDev, IBI, 30, 3, 7);
        case 4
            expgen=@ODDBALL.ExperimentClassic;
            blockgen= @(isDev, IBI) ODDBALL.BlockMixed(isDev, IBI, 30, 3, 5);
    end
    run = expgen(Blockorder, blockgen);
end
