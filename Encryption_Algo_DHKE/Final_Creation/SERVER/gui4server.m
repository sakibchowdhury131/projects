function varargout = gui4server(varargin)
% GUI4SERVER MATLAB code for gui4server.fig
%      GUI4SERVER, by itself, creates a new GUI4SERVER or raises the existing
%      singleton*.
%
%      H = GUI4SERVER returns the handle to a new GUI4SERVER or the handle to
%      the existing singleton*.
%
%      GUI4SERVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI4SERVER.M with the given input arguments.
%
%      GUI4SERVER('Property','Value',...) creates a new GUI4SERVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui4server_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui4server_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui4server

% Last Modified by GUIDE v2.5 22-Jul-2018 07:17:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui4server_OpeningFcn, ...
                   'gui_OutputFcn',  @gui4server_OutputFcn, ...
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


% --- Executes just before gui4server is made visible.
function gui4server_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui4server (see VARARGIN)

% Choose default command line output for gui4server
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui4server wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui4server_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton.
function pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');%connection to terminal1

t1 = tcpip('0.0.0.0', 300, 'NetworkRole', 'server');%connection to terminal2
tts ('waiting for client response')
fopen(t);
set(handles.text1,'String','Terminal 1 is connected to server');
drawnow
fopen (t1);
set(handles.text2,'String','Terminal 2 is connected to server');
drawnow
%%
while 1
if t.bytesAvailable > 0 
data= fscanf(t);
%a = convertCharsToStrings(data);

set(handles.text3,'String',data);
drawnow
fprintf(t1,data);
end
if t1.bytesAvailable > 0 
data= fscanf(t1);
%b = convertCharsToStrings(data);

set(handles.text4,'String',data);
drawnow
fprintf(t,data);
end
end
