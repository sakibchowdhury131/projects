function varargout = servergui(varargin)
% SERVERGUI MATLAB code for servergui.fig
%      SERVERGUI, by itself, creates a new SERVERGUI or raises the existing
%      singleton*.
%
%      H = SERVERGUI returns the handle to a new SERVERGUI or the handle to
%      the existing singleton*.
%
%      SERVERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERVERGUI.M with the given input arguments.
%
%      SERVERGUI('Property','Value',...) creates a new SERVERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before servergui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to servergui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help servergui

% Last Modified by GUIDE v2.5 22-Jul-2018 12:54:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @servergui_OpeningFcn, ...
                   'gui_OutputFcn',  @servergui_OutputFcn, ...
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


% --- Executes just before servergui is made visible.
function servergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to servergui (see VARARGIN)

% Choose default command line output for servergui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes servergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = servergui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_connect.
function pushbutton_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');%connection to terminal1

t1 = tcpip('0.0.0.0', 300, 'NetworkRole', 'server');%connection to terminal2
set(handles.term1static,'string', 'Waiting ajaira client response');

set(handles.term2static,'string', 'Waiting for client response');
tts ('waiting for client response');
set(handles.term1static,'string', 'Connected to Terminal 1');
fopen(t);
fopen (t1);
set(handles.term2static,'string', 'Connected to Terminal 2');
while 1
if t.bytesAvailable > 0 
data= fscanf(t);
set(handles.term1something,'string', 'hello');
fprintf(t1,data);

end
if t1.bytesAvailable > 0 
data= fscanf(t1);
set(handles.term2data,'string', 'hi');
fprintf(t,data);

end
end



