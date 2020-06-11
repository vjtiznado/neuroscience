function data = rec2ft_1(filename, triggers, window, repeat)
if nargin < 4
	repeat = true;
end

cfg = [];
cfg.dataset = filename;
cfg.trialdef.eventtype  = 'STATUS';
cfg.trialdef.eventvalue = num2cell(triggers);
cfg.trialdef.prestim    = abs(window(1));
cfg.trialdef.poststim   = abs(window(2));

cfg = ft_definetrial(cfg);
data = ft_preprocessing(cfg);

if repeat
	data2 = rec2ft(filename, 3, [0 .25], false);

	data.face_one = data.sampleinfo(:,1)+abs(window(1))*data.fsample;
	data.face_two_ini = data2.sampleinfo(:,1);
	data.face_two_end = data2.sampleinfo(:,2);
end
