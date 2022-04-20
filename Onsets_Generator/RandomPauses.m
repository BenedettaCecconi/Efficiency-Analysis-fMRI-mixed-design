% Written by Benedetta Cecconi and Carlo Alberto Avizzano 

% Generates a vector of random breaks that add up to the assigned total
% and are between a minimum and a maximum.
% The distribution is uniform

function p = RandomPauses(total, len, min, max)
if len*min > total
    error(['too high minimum: len*min > total' num2str(len) '*' num2str(min) '>' num2str(total)] )
end
if len*max < total
    error(['too high minimum: len*max < total' num2str(len) '*' num2str(max) '<' num2str(total)] )
end
% I initially create the vector with the minimum number
p = ones(1, len) * min;
rest = total - min * len;
% then I distribute the remaining times randomly
for choice = 1:rest
    while 1        
        pos = randi(len);
        if p(1,pos) < max
            break
        end
    end
    p(1, pos) = p(1, pos) + 1;
end
