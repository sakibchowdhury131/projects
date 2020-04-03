function varargout = SecuredMessaging(varargin)
% SECUREDMESSAGING MATLAB code for SecuredMessaging.fig
%      SECUREDMESSAGING, by itself, creates a new SECUREDMESSAGING or raises the existing
%      singleton*.
%
%      H = SECUREDMESSAGING returns the handle to a new SECUREDMESSAGING or the handle to
%      the existing singleton*.
%
%      SECUREDMESSAGING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SECUREDMESSAGING.M with the given input arguments.
%
%      SECUREDMESSAGING('Property','Value',...) creates a new SECUREDMESSAGING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SecuredMessaging_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SecuredMessaging_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SecuredMessaging

% Last Modified by GUIDE v2.5 22-Jul-2018 22:58:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SecuredMessaging_OpeningFcn, ...
                   'gui_OutputFcn',  @SecuredMessaging_OutputFcn, ...
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


% --- Executes just before SecuredMessaging is made visible.
function SecuredMessaging_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SecuredMessaging (see VARARGIN)

% Choose default command line output for SecuredMessaging
handles.output = hObject;

data1 = struct('val',0,'diffMax',1);
set(handles.pushbutton_connect,'UserData',data1);

data2 = struct('val',0,'diffMax',1);
set(handles.pushbutton_key,'UserData',data2);

data3 = struct('val',0,'diffMax',1);
set(handles.editbox_text,'UserData',data3);

data4 = struct('val',0,'diffMax',1);
set(handles.edittext_image,'UserData',data4);

data5 = struct('val',0,'diffMax',1);
set(handles.text_audio,'UserData',data5);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SecuredMessaging wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SecuredMessaging_OutputFcn(hObject, eventdata, handles) 
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
t1 = tcpip('0.0.0.0', 300, 'NetworkRole', 'client');

fopen(t1);
set(handles.static_connection,'string','Terminal 2 is connected to server');
drawnow
set(hObject,'UserData',t1);
guidata(hObject, handles);
tts('terminal 2 is connected to server');



% --- Executes on button press in pushbutton_key.
function pushbutton_key_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.keytext, 'string', 'Establishing...');
drawnow
t1=get(handles.pushbutton_connect, 'UserData');
while 1
if t1.bytesAvailable > 0 
qq= str2num(fscanf(t1));
if max(size(qq))~= 0 
   q=qq;
   fprintf (t1,'1');
   disp('q received')
   break;
end
end
end

while 1
if t1.bytesAvailable > 0 
pp= str2num(fscanf(t1));
if max(size(pp))~= 0 
   p=pp;
   fprintf (t1,'1');
   disp('p received')
   break;
end
end
end
%%
while 1
if t1.bytesAvailable > 0 
AAA= str2num(fscanf(t1));
if max(size(AAA))~= 0 
   Aa=AAA;
   fprintf (t1,'1');
   disp('Aa received')
   break;
end
end
end
%%
b=randi ([1,q-1],1,1);% primary secret key 
Bb=Mod(p,b,q);  %modulated key with public keys
BBB=num2str(Bb);
fprintf (t1, BBB);
while 1
if t1.bytesAvailable > 0 
state= str2num(fscanf(t1));
if max(size(state))~= 0 && state == 1
   disp('Bb sent')
   break;
end
end
end
%%
Sec_key=Mod(Aa,b,q);
set(hObject,'UserData',Sec_key);
guidata(hObject, handles);
set(handles.keytext, 'string', 'key exchange successful');
drawnow
x=num2str(Sec_key);
a=strcat('The key is : ', x);
set(handles.keytext, 'string', a);
drawnow





function editbox_text_Callback(hObject, eventdata, handles)
% hObject    handle to editbox_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=get(hObject, 'String');
set(hObject,'UserData',s);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of editbox_text as text
%        str2double(get(hObject,'String')) returns contents of editbox_text as a double


% --- Executes during object creation, after setting all properties.
function editbox_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbox_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_send.
function pushbutton_send_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t=get(handles.pushbutton_connect, 'UserData');
Sec_key=get(handles.pushbutton_key, 'UserData');

message=get(handles.editbox_text, 'UserData');
%Sec_key=pushbutton_connect_Callback.handles.key;
%t=pushbutton_connect_Callback.handles.t;
enc_msg=num2str(encrypt (message,Sec_key));
    fprintf (t,enc_msg);

% --- Executes on button press in Receive.
function Receive_Callback(hObject, eventdata, handles)
% hObject    handle to Receive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 t=get(handles.pushbutton_connect, 'UserData');
 Sec_key=get(handles.pushbutton_key, 'UserData');
     if t.bytesAvailable > 0 
         raw_data= fscanf(t);
         if max(size(raw_data))>5 
         enc_msg=raw_data;
         %fprintf (t,'1');
         disp('message received')
         dim=length (enc_msg);
     col = 9;
      row = (dim-1)/col;
      n=1;
     data= zeros (row,col);
      for j=1:col 
         for i = 1:row 
         data (i,j)= str2num(enc_msg (1,n));
          n=n+1;
         end
      end
%%
    Pro_data=zeros (row ,1);
       for i = 1:row
           for j= 1:9
             Pro_data(i ,1)= Pro_data (i ,1)+ data (i,j)*10^(9-j);
           end
       end
       %disp ('done')
     a=decrypt (Pro_data,row,Sec_key);
         set(handles.ouput,'string', a);
         drawnow
         end
     else 
         set(handles.ouput,'string', 'No new message');
         drawnow
     end



function edittext_image_Callback(hObject, eventdata, handles)
% hObject    handle to edittext_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s1=get(hObject, 'String');
set(hObject,'UserData',s1);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edittext_image as text
%        str2double(get(hObject,'String')) returns contents of edittext_image as a double


% --- Executes during object creation, after setting all properties.
function edittext_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edittext_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_imgrec.
function pushbutton_imgrec_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_imgrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t=get(handles.pushbutton_connect, 'UserData');
Sec_key=get(handles.pushbutton_key, 'UserData');
a=get(handles.edittext_image, 'UserData');
im=imread (a);
dim = size (im);
count= 0 ;
fprintf (t,num2str(dim(1,1)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,1) sent ')
        break;
        end
    end
end
fprintf (t,num2str(dim(1,2)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,2) sent ')
        break;
        end
    end
end
fprintf (t,num2str(dim(1,3)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,3) sent ')
        break;
        end
    end
end
%%
for k =1:dim(1,3)
    for j=1:dim(1,2)
        for i=1:dim(1,1)
            fprintf (t, num2str(encrypt (num2str(im(i,j,k)),Sec_key)));
            while 1
               if t.bytesAvailable > 0 
                   state= str2num(fscanf(t));
                   if max(size(state))~= 0 && state == 1
                       count=count+1;
                       percent = count *100/(dim(1,1)*dim (1,2)*dim(1,3));
                       temp_text=sprintf ('%f percent sent',percent);
                       set(handles.text_progress, 'String', temp_text);
                       drawnow
                       break;
                   end
               end
            end
        end
    end
end
 disp ('transmission complete');


% --- Executes on button press in pushbutton_image.
function pushbutton_image_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t=get(handles.pushbutton_connect, 'UserData');
Sec_key=get(handles.pushbutton_key, 'UserData');
while 1
if t.bytesAvailable > 0 
temp= str2num(fscanf(t));
if max(size(temp))~= 0 
   dim_img(1,1)=temp;
   fprintf (t,'1');
   disp('dim(1,1) received')
   break;
end
end
end
while 1
if t.bytesAvailable > 0 
temp= str2num(fscanf(t));
if max(size(temp))~= 0 
   dim_img(1,2)=temp;
   fprintf (t,'1');
   disp('dim(1,2) received')
   break;
end
end
end
while 1
if t.bytesAvailable > 0 
temp= str2num(fscanf(t));
if max(size(temp))~= 0 
   dim_img(1,3)=temp;
   fprintf (t,'1');
   disp('dim(1,3) received')
   break;
end
end
end

%% 
count=0;
for w =1:dim_img(1,3)
    for y=1:dim_img(1,2)
        for z=1:dim_img(1,1)
         while 1
           if t.bytesAvailable > 0 
              raw_data= fscanf(t);
              if max(size(raw_data))>5 
                enc_msg=raw_data;
                %fprintf (t1,'1');
                %disp('message received')
                break;
              end
           end
         end


         dim=length (enc_msg);
         col = 9;
         row = (dim-1)/col;
         n=1;
         data= zeros (row,col);
          for j=1:col 
            for i = 1:row 
         data (i,j)= str2num(enc_msg (1,n));
          n=n+1;
         end
      end
    Pro_data=zeros (row ,1);
       for i = 1:row
           for j= 1:9
             Pro_data(i ,1)= Pro_data (i ,1)+ data (i,j)*10^(9-j);
           end
       end
       %disp ('done')
     im(z,y,w)=uint8(str2num(decrypt (Pro_data,row,Sec_key)));
     count=count+1;
     percent = count *100/(dim_img(1,1)*dim_img (1,2)*dim_img(1,3));
     fprintf ('%f percent received \n',percent);
     fprintf (t,'1');
     temp_text=sprintf ('%f percent received',percent);
     set(handles.text_progress, 'String', temp_text);
     drawnow
     %disp(im(z,y,w))
        end
    end
end
disp('receive complete');
figure
imshow (im);
imwrite (im,'test2copy.jpg');



function text_audio_Callback(hObject, eventdata, handles)
% hObject    handle to text_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s1=get(hObject, 'String');
set(hObject,'UserData',s1);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of text_audio as text
%        str2double(get(hObject,'String')) returns contents of text_audio as a double


% --- Executes during object creation, after setting all properties.
function text_audio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_audsend.
function pushbutton_audsend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_audsend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t=get(handles.pushbutton_connect, 'UserData');
Sec_key=get(handles.pushbutton_key, 'UserData');
a=get(handles.text_audio, 'UserData');
[Fs,y] = audioread(a);
dim = size (Fs);
count= 0;
fprintf (t,num2str(dim(1,1)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,1) sent ')
        break;
        end
    end
end
fprintf (t,num2str(dim(1,2)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,2) sent ')
        break;
        end
    end
end

%%

    for j=1:dim(1,2)
        for i=1:dim(1,1)
            fprintf (t, num2str(encrypt (num2str(Fs(i,j)),Sec_key)));
            while 1
               if t.bytesAvailable > 0 
                   state= str2num(fscanf(t));
                   if max(size(state))~= 0 && state == 1
                       count=count+1;
                       percent = count *100/(dim(1,1)*dim (1,2));
                       temp_text=sprintf ('%f percent sent',percent);
                       set(handles.audio_progress, 'String', temp_text);
                       drawnow
                       break;
                   end
               end
            end
        end
    end
fprintf (t,num2str(y));
while 1
if t.bytesAvailable > 0 
state= str2num(fscanf(t));
if max(size(state))~= 0 && state == 1
   disp('q sent')
   break;
end
end
end
 disp ('transmission complete');


% --- Executes on button press in pushbutton_audrec.
function pushbutton_audrec_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_audrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t=get(handles.pushbutton_connect, 'UserData');
Sec_key=get(handles.pushbutton_key, 'UserData');
while 1
if t.bytesAvailable > 0 
temp= str2num(fscanf(t));
if max(size(temp))~= 0 
   dim_aud(1,1)=temp;
   fprintf (t,'1');
   disp('dim(1,1) received')
   break;
end
end
end
while 1
if t.bytesAvailable > 0 
temp= str2num(fscanf(t));
if max(size(temp))~= 0 
   dim_aud(1,2)=temp;
   fprintf (t,'1');
   disp('dim(1,2) received')
   break;
end
end
end


%% 
count=0;
    for y=1:dim_aud(1,2)
        for z=1:dim_aud(1,1)
         while 1
           if t.bytesAvailable > 0 
              raw_data= fscanf(t);
              if max(size(raw_data))>5 
                enc_msg=raw_data;
                %fprintf (t1,'1');
                %disp('message received')
                break;
              end
           end
         end


         dim=length (enc_msg);
         col = 9;
         row = (dim-1)/col;
         n=1;
         data= zeros (row,col);
          for j=1:col 
            for i = 1:row 
         data (i,j)= str2num(enc_msg (1,n));
          n=n+1;
         end
      end
    Pro_data=zeros (row ,1);
       for i = 1:row
           for j= 1:9
             Pro_data(i ,1)= Pro_data (i ,1)+ data (i,j)*10^(9-j);
           end
       end
       %disp ('done')
     Fs(z,y)=(str2num(decrypt (Pro_data,row,Sec_key)));
     count=count+1;
     percent = count *100/(dim_aud(1,1)*dim_aud (1,2));
     temp_text=sprintf ('%f percent received',percent);
     set(handles.audio_progress, 'String', temp_text);
     drawnow
     fprintf (t,'1');
     %disp(im(z,y,w))
        end
    end
while 1
if t.bytesAvailable > 0 
temp= str2num(fscanf(t));
if max(size(pp))~= 0 
   y_aud=temp;
   fprintf (t,'1');
   disp('y_aud received')
   break;
end
end
end
disp('receive complete')

filename = 'test_aud.wav';
audiowrite(filename, Fs, y_aud);
