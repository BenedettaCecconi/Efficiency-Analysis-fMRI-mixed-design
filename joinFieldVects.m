% This function joins all arrays in a struct with a second same-shape
% struct. It is used to combine trials into blocks and blocks into 
% experiments
%
% Usage:
%   joined = ODDBALL.joinFieldVects(previous, addon)
%
%
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