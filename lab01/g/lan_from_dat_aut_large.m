function LAN = lan_from_dat_aut_large(decrease_factor)
file_dat = dir('*.dat');
memm = memmapfile(file_dat.name, 'format', 'int16');
memmdatasize = size(memm.data,1);
def_length = round(memmdatasize/decrease_factor);
if strcmp(file_dat.name(1:2), 'SB'),
    answer{1} = '33';
else
    answer{1} = '32';
end

LAN.nbchan = eval(answer{1});
def_length = round(def_length/LAN.nbchan)*LAN.nbchan;

answer{2} = [];
W = eval(['[' answer{2} ']']);
if isempty(W)
    W = 1:LAN.nbchan;
end

for w = W
    LAN.data{1}(w,:) = memm.data(w:LAN.nbchan:def_length);
end

LAN.importrec.files = file_dat;
LAN.importrec.Path = pwd;