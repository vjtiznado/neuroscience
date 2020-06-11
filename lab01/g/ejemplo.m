function varargout = ejemplo(varargin)
% EJEMPLO MATLAB code for ejemplo.fig
%      EJEMPLO, by itself, creates a new EJEMPLO or raises the existing
%      singleton*.
%
%      H = EJEMPLO returns the handle to a new EJEMPLO or the handle to
%      the existing singleton*.
%
%      EJEMPLO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EJEMPLO.M with the given input arguments.
%
%      EJEMPLO('Property','Value',...) creates a new EJEMPLO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ejemplo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ejemplo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ejemplo

% Last Modified by GUIDE v2.5 18-Oct-2017 10:08:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ejemplo_OpeningFcn, ...
                   'gui_OutputFcn',  @ejemplo_OutputFcn, ...
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


% --- Executes just before ejemplo is made visible.
function ejemplo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ejemplo (see VARARGIN)

% Choose default command line output for ejemplo
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ejemplo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ejemplo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadAVI.
function LoadAVI_Callback(hObject, eventdata, handles)
[dataFileName, dataPathName] = uigetfile('*.avi');
mov = VideoReader([dataPathName dataFileName]);
frame_ini = get(handles.figure1,'UserData');
frame_fin = get(handles.Pantalla,'UserData');
trajectories2 = get(handles.Pantalla,'UserData');
sample1 = nan(size(trajectories2,1),1); count1 = 0;
sample2 = nan(size(trajectories2,1),1); count2 = 0;
active = logical(get(handles.togglebutton3,'Value'));
for k = frame_ini:mov.NumberOfFrames
    if ~active
        pausa = get(handles.togglebutton5,'Value');
        while pausa
            pausa = get(handles.togglebutton5,'Value');
            pause(0.1)
        end
        
        active = logical(get(handles.togglebutton3,'Value'));
        handles.g1 = imshow(read(mov,k));
%         hold on
%         plot(trajectories2(k-(frame_ini - 1),1),trajectories2(k-(frame_ini - 1),2),'ro','markersize',10)
        pause(0.01)
        bool_obj_1 = get(handles.togglebutton1,'Value');
        bool_obj_2 = get(handles.togglebutton2,'Value');
        if bool_obj_1
            count1 = count1 + 1;
            sample1(count1) = k;
        end
        if bool_obj_2
            count2 = count2 + 1;
            sample2(count2) = k;
        end
    end
end
sample1 = sample1(~isnan(sample1));
sample2 = sample2(~isnan(sample2));
save ([dataPathName,'resultados'],'sample1','sample2')
close

% hObject    handle to LoadAVI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadTrajectories.
function LoadTrajectories_Callback(hObject, eventdata, handles)
[dataFileName, dataPathName] = uigetfile('*.mat');
load([dataPathName dataFileName])
set(handles.Pantalla,'UserData',trajectories2)
set(handles.figure1,'UserData',frame_ini)
set(handles.LoadTrajectories,'UserData',frame_fin)
% hObject    handle to LoadTrajectories (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
button_on = get(hObject,'Value');
if button_on
    set(hObject,'String','ON');
else
    set(hObject,'String','OFF');
end
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
button_on = get(hObject,'Value');
if button_on
    set(hObject,'String','ON');
else
    set(hObject,'String','OFF');
end
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)

% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3

% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5
