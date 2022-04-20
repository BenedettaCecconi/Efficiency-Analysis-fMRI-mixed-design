% Written by Benedetta Cecconi and Carlo Alberto Avizzano 

% This function joins all arrays of a struct with a second struct of the same form
% It is used to combine trials into blocks and blocks into experiments

% iti sets the final pause in ms which is calculated at higher level
%
% Usage:
%   joined = ODDBALL.joinFieldVects(previous, addon)

function joined = joinFieldVects(prev, add)
try
    fn = fieldnames(prev);
    for f = 1:numel(fn)
        prev.(fn{f}) = [prev.(fn{f}) add.(fn{f})];
    end
    joined = prev;
catch
    error('Something went wrong while joining vectors')
end
