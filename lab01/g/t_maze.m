function varargout = t_maze(varargin)
% T_MAZE MATLAB code for t_maze.fig
%      T_MAZE, by itsresultados_t_mazeelf, creates a new T_MAZE or raises the existing
%      singleton*.
%
%      H = T_MAZE returns the handle to a new T_MAZE or the handle to
%      the existing singleton*.
%
%      T_MAZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in T_MAZE.M with the given input arguments.
%
%      T_MAZE('Property','Value',...) creates a new T_MAZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before t_maze_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to t_maze_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help t_maze

% Last Modified by GUIDE v2.5 27-Sep-2018 15:46:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @t_maze_OpeningFcn, ...
    'gui_OutputFcn',  @t_maze_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before t_maze is made visible.
function t_maze_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = t_maze_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in LoadAVI.
function LoadAVI_Callback(hObject, eventdata, handles)
[dataFileName, dataPathName] = uigetfile('*.avi');
mov = VideoReader([dataPathName dataFileName]);
frate = mov.FrameRate;
k = 1;
grooming = [];
active = logical(get(handles.Stop,'Value'));

laser = [];
left = [];
right = [];
success = [];
failure = [];
save('resultados_t_maze','left','right','success','failure','laser')
step = str2double(get(handles.step_frame,'String'));
while k <= mov.NumberOfFrames - step & k > 0 & ~active
    step = str2double(get(handles.step_frame,'String'));
    time_value = round(10*k/frate);
    time_value = time_value/10;
    set(handles.timevalue,'String',time_value);
    rw = logical(get(handles.reverse,'Value'));
    fw = logical(get(handles.Forward,'Value'));
    if fw & ~rw
        k = k + step;
    elseif rw & ~fw
        k = k - step;
    end
    if ~active
        set(handles.LoadAVI,'Value',k)
        pausa = get(handles.Pause,'Value');
        while pausa
            pausa = get(handles.Pause,'Value');
            pause(0.1)
        end
        active = logical(get(handles.Stop,'Value'));
        handles.g1 = imshow(read(mov,k));
        pause_val = str2double(get(handles.speed,'String'));
        pause(pause_val)
        groom_on = get(handles.groom_On_Off,'Value');
        if groom_on & fw
            grooming = [grooming; k];
        end
        if rw
            load('resultados_t_maze')
            grooming(grooming >= k) = [];
            laser(laser >= k) = [];
            left (left >= k) = [];
            right (right >= k) = [];
            success (success >= k) = [];
            failure (failure >= k) = [];
            save('resultados_t_maze','left','right','success','failure','laser')
        end
    end
end
load('resultados_t_maze')
save ([dataPathName 'resultados_t_maze'],'grooming','left','right','success','failure','laser')
% delete('resultados_t_maze.mat')
close
clear


% --- Executes on button press in groom_On_Off.
function groom_On_Off_Callback(hObject, eventdata, handles)
button_on = get(hObject,'Value');
if button_on
    set(hObject,'String','ON');
    set(hObject,'BackgroundColor','k');
else
    set(hObject,'String','OFF');
    set(hObject,'BackgroundColor',[0.75 0.75 0.75]);
end

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)

% --- Executes on button press in Pause.
function Pause_Callback(hObject, eventdata, handles)
button_pause = get(hObject,'Value');
if button_pause
    set(hObject,'String','Continue');
else
    set(hObject,'String','Pause');
end

% --- Executes on button press in reverse.
function reverse_Callback(hObject, eventdata, handles)
button_on = get(hObject,'Value');
if button_on
    set(handles.reverse,'Value',1);
    set(handles.Forward,'Value',0);
end

% --- Executes on button press in Forward.
function Forward_Callback(hObject, eventdata, handles)
button_on = get(hObject,'Value');
if button_on
    set(handles.reverse,'Value',0);
    set(handles.Forward,'Value',1);
end

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
k = get(handles.LoadAVI,'Value');
load('resultados_t_maze');
left = [left; k];
save('resultados_t_maze','left','right','success','failure','laser')

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
k = get(handles.LoadAVI,'Value');
load('resultados_t_maze');
right = [right; k];
save('resultados_t_maze','left','right','success','failure','laser')

% --- Executes on button press in good_pf.
function good_pf_Callback(hObject, eventdata, handles)
k = get(handles.LoadAVI,'Value');
load('resultados_t_maze');
success = [success; k];
set(handles.good_pf,'Backgroundcolor','k')
save('resultados_t_maze','left','right','success','failure','laser')

% --- Executes on button press in bad_pf.
function bad_pf_Callback(hObject, eventdata, handles)
k = get(handles.LoadAVI,'Value');
load('resultados_t_maze');
failure = [failure; k];
set(handles.bad_pf,'Backgroundcolor','k')
save('resultados_t_maze','left','right','success','failure','laser')

% --- Executes on button press in light.
function light_Callback(hObject, eventdata, handles)
k = get(handles.LoadAVI,'Value');
load('resultados_t_maze');
laser = [laser; k];
save('resultados_t_maze','left','right','success','failure','laser')

function speed_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function step_frame_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function step_frame_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function timevalue_CreateFcn(hObject, eventdata, handles)
set(handles, 'BackgroundColor', []);
% --- Executes during object creation, after setting all properties.
function t_text_CreateFcn(hObject, eventdata, handles)
