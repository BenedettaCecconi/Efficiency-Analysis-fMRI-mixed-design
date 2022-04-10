% Genera un vettore di pause casuali che sommano al totale
% assegnato e sono comprese tra un minimo ed un massimo.
% La distribuzione è uniforma
function p = RandomPauses(total, len, min, max)
if len*min > total
    error('minimo troppo alto: len*min > total')
end
if len*max < total
    error('massimo troppo basso: len*max < total')
end
% Creo inizialmente il vettore con il numero minimo
p = ones(1, len) * min;
rest = total - min * len;
% quindi distribuisco i tempi rimanenti in maniera casuale
for choice = 1:rest
    while 1        
        pos = randi(len);
        if p(1,pos) < max
            break
        end
    end
    p(1, pos) = p(1, pos) + 1;
end