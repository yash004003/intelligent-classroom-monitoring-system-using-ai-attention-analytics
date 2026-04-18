function varargout = E_Learning(varargin)
% E_LEARNING MATLAB code for E_Learning.fig
%      E_LEARNING, by itself, creates a new E_LEARNING or raises the existing
%      singleton*.
%

%      H = E_LEARNING returns the handle to a new E_LEARNING or the handle to
%      the existing singleton*.
%
%      E_LEARNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in E_LEARNING.M with the given input arguments.
%
%      E_LEARNING('Property','Value',...) creates a new E_LEARNING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before E_Learning_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to E_Learning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help E_Learning

 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @E_Learning_OpeningFcn, ...
                   'gui_OutputFcn',  @E_Learning_OutputFcn, ...
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


% --- Executes just before E_Learning is made visible.
function E_Learning_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to E_Learning (see VARARGIN)

% Choose default command line output for E_Learning
handles.output = hObject;
global flag;global count; 
   flag=0;count=0;
   set(handles.edit1,'String','--');
   set(handles.edit2,'String',''); 
   set(handles.edit3,'String','--');

   
%    % create an axes that spans the whole gui
% ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% % import the background image and show it on the axes
% bg = imread('1.jpg'); imagesc(bg);
% % prevent plotting over the background and turn the axis off
% set(ah,'handlevisibility','off','visible','off')
% % making sure the background is behind all the other uicontrols
% uistack(ah, 'bottom');   
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes E_Learning wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = E_Learning_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;global count;
s1=get(handles.edit2,'string');
tts('Your request is Received');
s2 = 'blogging';
tf1 = strcmp(s1,s2);

s2 = 'secular world';
tf2 = strcmp(s1,s2);

s2 = 'population explosion';
tf3 = strcmp(s1,s2);

s2 = 'acid rain';
tf4 = strcmp(s1,s2);

s2 = 'alcohol abuse';
tf5 = strcmp(s1,s2);

% s2 = 'attitude';
% tf6 = strcmp(s1,s2);
% 
% s2 = 'biodiversity';
% tf7 = strcmp(s1,s2);
% 
% s2 = 'child labour ';
% tf8 = strcmp(s1,s2);
% 
% s2 = 'corruption';
% tf9 = strcmp(s1,s2);
% 
% s2 = 'deforestation';
% tf10 = strcmp(s1,s2);
% 
% s2 = 'diabetes';
% tf11 = strcmp(s1,s2);
% 
% s2 = 'democracy';
% tf12 = strcmp(s1,s2);
% 
% s2 = 'discrimination';
% tf13 = strcmp(s1,s2);
% 
% s2 = 'drug abuse';
% tf14 = strcmp(s1,s2);
% 
% s2 = 'endangered species';
% tf15 = strcmp(s1,s2);
% 
% s2 = 'entreprenurship';
% tf16 = strcmp(s1,s2);
% 
% s2 = 'ethical values';
% tf17 = strcmp(s1,s2);
% 
% s2 = 'gender equality';
% tf18 = strcmp(s1,s2);
% 
% s2 = 'generation gap';
% tf19 = strcmp(s1,s2);
% 
% s2 = 'global warming';
% tf20 = strcmp(s1,s2);
% 
% s2 = 'human rights';
% tf21 = strcmp(s1,s2);
% 
% s2 = 'natural disasters';
% tf22 = strcmp(s1,s2);
% 
% s2 = 'natural resources';
% tf23 = strcmp(s1,s2);
% 
% s2 = 'organ traqnsplantation';
% tf24 = strcmp(s1,s2);
% 
% s2 = 'pollution';
% tf25 = strcmp(s1,s2);
% 
% s2 = 'poverty';
% tf26 = strcmp(s1,s2);
% 
% s2 = 'power of media';
% tf27 = strcmp(s1,s2);
% 
% s2 = 'road safety';
% tf28 = strcmp(s1,s2);
% 
% s2 = 'waste water treatment';
% tf29 = strcmp(s1,s2);
% 
% s2 = 'women empwerment';
% tf30 = strcmp(s1,s2);



if(tf1==1)
        handles.activex1.URL = 'blogging\blogging.mp4';
        handles.activex1.controls.play();
        pause(100);
        handles.activex1.controls.stop();pause(3);
        tts('We are verifying your emotions');
	run('MAIN_CODE.m');
        run('Emotion_Identification.m');
        
        if(count ==1)
        handles.activex1.URL = 'blogging\blogintamil.mp4';
        handles.activex1.controls.play();
        else
        end

elseif(tf2==1)
        handles.activex1.URL = 'secular world\secularworld.mp4';
        handles.activex1.controls.play();
        pause(100);
        handles.activex1.controls.stop();pause(3);run('MAIN_CODE.m');
        run('Emotion_Identification.m');
        if(count ==1)
        handles.activex1.URL = 'secular world\1.mp4';
        handles.activex1.controls.play();
        else
        end
        
elseif(tf3==1)
        handles.activex1.URL = 'populationexplosion\populationexplosion.mp4';
        handles.activex1.controls.play();
        pause(100);run('MAIN_CODE.m');
        run('Emotion_Identification.m');
        if(count ==1)
        handles.activex1.URL = 'populationexplosion\populationexplosion1.mp4';
        handles.activex1.controls.play();
        else
        end
        
elseif(tf4==1)
        handles.activex1.URL = 'acidrain\acidrain.mp4';
        handles.activex1.controls.play();
        pause(100);run('MAIN_CODE.m');
        run('Emotion_Identification.m');
        if(count ==1)
        handles.activex1.URL = 'acidrain\acidrain1.mp4';
        handles.activex1.controls.play();
        else
        end
        
elseif(tf5==1)
        handles.activex1.URL = 'alcohol abuse\alcoholabuse.mp4';
        handles.activex1.controls.play();
        pause(100);run('MAIN_CODE.m');
        run('Emotion_Identification.m');
        if(count ==1)
        handles.activex1.URL = 'alcohol abuse\alcoholabuse1.mp4';
        handles.activex1.controls.play();
        else
        end        
             
else
    tts('The requested key related informations are not available with me');
end





function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
javaaddpath('iText-4.2.0-com.itextpdf.jar')
pdf_text = pdfRead('key.pdf');
set(handles.edit3, 'Min', 0, 'Max', 2);
set(handles.edit3,'String',(pdf_text));


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   set(handles.edit1,'String','--');
   set(handles.edit2,'String','--'); 
   set(handles.edit3,'String','--');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close E_Learning