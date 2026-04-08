% Soluzione 4 - RegEx
codici = {'P001','PX12','P123','Q999','P07A'};
pat = '^P\d{3}$';

for i = 1:numel(codici)
    c = codici{i};
    ok = ~isempty(regexp(c, pat, 'once'));
    if ok
        fprintf('%s -> valido\n', c);
    else
        fprintf('%s -> NON valido\n', c);
    end
end
