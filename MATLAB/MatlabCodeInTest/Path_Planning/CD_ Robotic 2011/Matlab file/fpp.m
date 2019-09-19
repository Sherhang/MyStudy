function varargout = fpp(varargin)
% FPP M-file for fpp.fig
%      FPP, by itself, creates a new FPP or raises the existing
%      singleton*.
%
%      H = FPP returns the handle to a new FPP or the handle to
%      the existing singleton*.
%
%      FPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FPP.M with the given input arguments.
%
%      FPP('Property','Value',...) creates a new FPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fpp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fpp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fpp

% Last Modified by GUIDE v2.5 16-Dec-2010 08:30:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fpp_OpeningFcn, ...
                   'gui_OutputFcn',  @fpp_OutputFcn, ...
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


% --- Executes just before fpp is made visible.
function fpp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fpp (see VARARGIN)

% Choose default command line output for fpp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fpp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

map=[];
setappdata(0,'map',map);
posf=0;
setappdata(0,'posf',posf);
mapf=0;
setappdata(0,'mapf',mapf);

axes(handles.axes1) % Select the proper axes
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')



% --- Outputs from this function are returned to the command line.
function varargout = fpp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

posf=0;
setappdata(0,'posf',posf);
mapf=0;
setappdata(0,'mapf',mapf);
i=1:100;
j=1:100;
w = str2double(get(handles.edit1,'String'));
map=[];
setappdata(0,'map',map);
A=zeros(100,100);
axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j),60)
set(handles.axes2,'XMinorTick','on')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

posf=0;
setappdata(0,'posf',posf);
mapf=1;
setappdata(0,'mapf',mapf);
axes(handles.axes2) % Select the proper axes
set(handles.axes2,'XMinorTick','on')
axis([1 100 1 100]);
% hold on
h=msgbox('Draw a wall by using the left mouse button for start and right mouse button for ending the wall');
uiwait(h,5);
if ishandle(h)==1
    delete(h);
end
but=0;
%but=1 left     but=3 right
while(but~=1)
    [xs,ys,but]=ginput(1);
end
but=0;
while(but~=3)
    [xe,ye,but]=ginput(1);
end

xs=round(xs*10)/100;
ys=round(ys*10)/100;
xe=round(xe*10)/100;
ye=round(ye*10)/100;

map = getappdata(0,'map');
w = str2double(get(handles.edit1,'String'));
map=mmap([xs,ys],[xe,ye],map,w);
setappdata(0,'map',map);

i=1:100;
j=1:100;

x=map(:,2);
y=map(:,1);
w=map(:,3);
R=[];
A1=[];
% GoalY=y(length(x));
% GoalX=x(length(x));

for I=1:100
  for J=1:100
      R=[];
      for r=1:length(x)-1
          R=[R w(r)/((J/10-y(r))^2+(I/10-x(r))^2)];
      end
%          RG = sqrt((J/10-GoalY)^2+(I/10-GoalX)^2);
         A1(I,J) = sum(R);
            if (A1(I,J)>300)
                A1(I,J)=300;
            end  
 end
end
A=A1;
axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j),60)
set(handles.axes2,'XMinorTick','on')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i=1:100;
j=1:100;

mapf = getappdata(0,'mapf');
if(mapf==1)
map = getappdata(0,'map');
x=map(:,2);
y=map(:,1);
w=map(:,3);
R=[];
A1=[];
% GoalY=y(length(x));
% GoalX=x(length(x));

for I=1:100
  for J=1:100
      R=[];
      for r=1:length(x)-1
          R=[R w(r)/((J/10-y(r))^2+(I/10-x(r))^2)];
      end
%          RG = sqrt((J/10-GoalY)^2+(I/10-GoalX)^2);
            A1(I,J) = sum(R);
            if (A1(I,J)>300)
                A1(I,J)=300;
            end  
 end
end
A=A1;
axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j),60)
set(handles.axes2,'XMinorTick','on')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = str2double(get(handles.edit1,'String'));
h=msgbox('Select the target using the left mouse button');
uiwait(h,5);
if ishandle(h)==1
    delete(h);
end
but=0;
while(but~=1)
    [xval,yval,but]=ginput(1);
end
pos=[xval/10,yval/10];
setappdata(0,'pos',pos);
posf=1;
setappdata(0,'posf',posf);
axes(handles.axes2) % Select the proper axes
hold on
plot(xval,yval,'ro');
hold off
else
    msgbox('Please select or create map at first');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 w = str2double(get(handles.edit1,'String'));

map = getappdata(0,'map');
pos = getappdata(0,'pos');
posf = getappdata(0,'posf');
if(posf==1)
xval=round(pos(1)*10)/10;
yval=round(pos(2)*10)/10;
map=[map;
     xval  yval   w];

[A,B,LMF,NoSol,xx,yy]=getpath(map);

i=1:100;
j=1:100;

if(LMF==1)
%    display('Local Minimum exists')
set(handles.text2,'String','Local Minimum exists')
end

if(NoSol==1)
%    display('No Solution')
    set(handles.text2,'String','No Solution has been found')
else
    if(LMF==1)
%    display('Local Minimum exists')
    set(handles.text2,'String','Local Minimum exists')
    else
%    display('A Solution exist')
    set(handles.text2,'String','Path has been found')
    end
end

axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j)+B(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')
hold off

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j)+B(i,j),60)
set(handles.axes2,'XMinorTick','on')
hold on
plot(yy,xx,'*')
hold off

posf=0;
setappdata(0,'posf',posf);
else
    msgbox('Please select the target position first');
end


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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

posf=0;
setappdata(0,'posf',posf);
mapf=1;
setappdata(0,'mapf',mapf);

i=1:100;
j=1:100;
w = str2double(get(handles.edit1,'String'));
map1=[];
map1=mmap([3,0],[3,2.5],map1,w);
map1=mmap([3,2.5],[6,2.5],map1,w);
map1=mmap([3,6],[3,10],map1,w);
map1=mmap([7,6],[7,10],map1,w);
map1=mmap([7,6],[8,6],map1,w);

map=map1;
setappdata(0,'map',map1);
x=map(:,2);
y=map(:,1);
w=map(:,3);
R=[];
A1=[];
% GoalY=y(length(x));
% GoalX=x(length(x));

for I=1:100
  for J=1:100
      R=[];
      for r=1:length(x)-1
          R=[R w(r)/((J/10-y(r))^2+(I/10-x(r))^2)];
      end
%          RG = sqrt((J/10-GoalY)^2+(I/10-GoalX)^2);
            A1(I,J) = sum(R);
            if (A1(I,J)>300)
                A1(I,J)=300;
            end  
 end
end
A=A1;
axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j),60)
set(handles.axes2,'XMinorTick','on')

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

posf=0;
setappdata(0,'posf',posf);
mapf=1;
setappdata(0,'mapf',mapf);
i=1:100;
j=1:100;
w = str2double(get(handles.edit1,'String'));
map2=[];
map2=mmap([1,2.5],[4,2.5],map2,w);
map2=mmap([2.5,6],[2.5,10],map2,w);
map2=mmap([7,0],[7,6],map2,w);
map2=mmap([7,6],[6,6],map2,w);

map=map2;
setappdata(0,'map',map2);
x=map(:,2);
y=map(:,1);
w=map(:,3);
R=[];
A1=[];
% GoalY=y(length(x));
% GoalX=x(length(x));

for I=1:100
  for J=1:100
      R=[];
      for r=1:length(x)-1
          R=[R w(r)/((J/10-y(r))^2+(I/10-x(r))^2)];
      end
%          RG = sqrt((J/10-GoalY)^2+(I/10-GoalX)^2);
         A1(I,J) = sum(R);
            if (A1(I,J)>300)
                A1(I,J)=300;
            end  
 end
end
A=A1;
axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j),60)
set(handles.axes2,'XMinorTick','on')

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
posf=0;
setappdata(0,'posf',posf);
mapf=1;
setappdata(0,'mapf',mapf);

i=1:100;
j=1:100;
w = str2double(get(handles.edit1,'String'));
map3=[];
map3=mmap([0,2],[2,3],map3,w);
map3=mmap([2,2],[2,6],map3,w);
map3=mmap([6,5],[8,1.5],map3,w);
map3=mmap([8,1.5],[8,1],map3,w);
map3=mmap([8,8],[10,9],map3,w);
map3=mmap([8,8],[7,8],map3,w);

map=map3;
setappdata(0,'map',map3);
x=map(:,2);
y=map(:,1);
w=map(:,3);
R=[];
A1=[];
% GoalY=y(length(x));
% GoalX=x(length(x));

for I=1:100
  for J=1:100
      R=[];
      for r=1:length(x)-1
          R=[R w(r)/((J/10-y(r))^2+(I/10-x(r))^2)];
      end
%          RG = sqrt((J/10-GoalY)^2+(I/10-GoalX)^2);
         A1(I,J) = sum(R);
            if (A1(I,J)>300)
                A1(I,J)=300;
            end  
 end
end
A=A1;
axes(handles.axes1) % Select the proper axes
mesh(i,j,A(i,j))
axis([1,100,1,100,-10,300])
view([-20,-15,20])
set(handles.axes1,'XMinorTick','on')

axes(handles.axes2) % Select the proper axes
contour(i,j,A(i,j),60)
set(handles.axes2,'XMinorTick','on')


% --- Executes during object creation, after setting all properties.
function pushbutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


