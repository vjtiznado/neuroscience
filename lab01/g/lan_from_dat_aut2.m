function LAN = lan_from_dat_aut2(file_dat)
% file_dat = dir('*.dat');
% memm = memmapfile(file_dat.name, 'format', 'int16');
memm = memmapfile(file_dat, 'format', 'int16');
if strcmp(file_dat(1:2), 'SB'),
    answer{1} = '33';
else
    answer{1} = '32';
end

LAN.nbchan = eval(answer{1});
answer{2} = [];
W = eval(['[' answer{2} ']']);
if isempty(W)
    W = 1:LAN.nbchan;
end

for w = W
    LAN.data{1}(w,:) = memm.data(w:LAN.nbchan:end);
end

LAN.importrec.files = file_dat;
LAN.importrec.Path = pwd;