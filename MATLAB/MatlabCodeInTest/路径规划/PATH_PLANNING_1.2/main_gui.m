function varargout = main_gui(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
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


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
    %Call in necessary defaults
    global Obstacles;
    global ExploringTree;
    global BestPath;
    global GoalAndStart;
    Obstacles = 1;
    ExploringTree = 1;
    BestPath = 1;
    GoalAndStart = 0;
    set(handles.MessagePrompt,'String','Choose a path planning algorithm');
    
    % Choose default command line output for main_gui
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 

    % Get default command line output from handles structure
    varargout{1} = handles.output;

% --- Executes on button press in ObstaclesButton.
function ObstaclesButton_Callback(hObject, eventdata, handles)
    global Obstacles;
    
    Obstacles = get(hObject,'Value');
    DISPLAY_everything(handles);

% --- Executes on button press in TreeButton.
function TreeButton_Callback(hObject, eventdata, handles)
    global ExploringTree;
    
    ExploringTree = get(hObject,'Value');
    DISPLAY_everything(handles);

% --- Executes on button press in PathButton.
function PathButton_Callback(hObject, eventdata, handles)
    global BestPath;
    
    BestPath = get(hObject,'Value');
    DISPLAY_everything(handles);

% --- Executes on button press in GoalAndStart.
function GoalAndStart_Callback(hObject, eventdata, handles)
    global GoalAndStart;
    
    GoalAndStart = get(hObject,'Value');
    DISPLAY_everything(handles);

% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
    global PLANNER;
    global START;
    global BOUNDARY;
    global map;
    global Q;
    global bestPath;
    
    switch(PLANNER)
        case 1
            [Q,bestPath] = RRT(map,START,BOUNDARY,handles);
        case 2
            [Q,bestPath] = RRTSTAR(map,START,BOUNDARY,handles);
        case 3
            [Q,bestPath] = BITSTAR(map,START,BOUNDARY,handles);
    end
    DISPLAY_everything(handles);
    set(handles.ObstaclesButton,'Enable','on');
    set(handles.TreeButton,'Enable','on');
    set(handles.PathButton,'Enable','on');
    set(handles.GoalAndStart,'Enable','on');
    
function DISPLAY_everything(handles)
    global Q;
    global map;
    global bestPath;
    global START;
    global BOUNDARY;
    global Obstacles;
    global ExploringTree;
    global BestPath;
    global GoalAndStart;
    
    hold on;
    cla(handles.Figure);
    if(Obstacles == 1)
        DISPLAY_patchwork(map,handles.Figure);
    end
    if(ExploringTree == 1)
        DISPLAY_tree(Q,handles.Figure);
    end
    if(BestPath == 1)
        DISPLAY_best_path(Q,bestPath,handles.Figure);
    end
    if(GoalAndStart == 1)
        DISPLAY_goal_and_start(START,BOUNDARY,handles.Figure);
    end
    axis equal;
    hold off;

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
    global START;
    global BOUNDARY;
    global PLANNER;
    
    %Reset planner, map, and start and goal points
    PLANNER = [];
    START.x = [];
    START.y = [];
    BOUNDARY.xmin = [];
    BOUNDARY.ymin = [];
    BOUNDARY.xmax = [];
    BOUNDARY.ymax = [];
    
    %Freeze calculate, pause, and cancel buttons in addition to all solver
    %buttons and map selectors
    set(handles.Calculate,'Enable','off');
    set(handles.ChooseMap,'Enable','off');
    set(handles.ChoosePath,'String','');
    set(handles.Browse,'Enable','off');
    set(handles.PointTable,'Enable','off');
    set(handles.PointTable,'Data',{});
    set(handles.InputCursor,'Enable','off');
    set(handles.ViewSetup,'Enable','off');
    cla(handles.Figure);
    set(handles.MessagePrompt,'String','Choose a path planning algorithm');
    set(handles.ObstaclesButton,'Enable','off');
    set(handles.TreeButton,'Enable','off');
    set(handles.PathButton,'Enable','off');
    set(handles.GoalAndStart,'Enable','off');

% --- Executes on selection change in Listbox.
function Listbox_Callback(hObject, eventdata, handles)
    global PLANNER;
    
    PLANNER = get(hObject,'Value');
    
    %Reactivate anything to do with map finding
    set(handles.ChooseMap,'Enable','on');
    set(handles.Browse,'Enable','on');
    set(handles.MessagePrompt,'String','Choose a map. Note: maps must be in 2D grid format with occupied spaces as 0 and unoccupies as 1.');

% --- Executes during object creation, after setting all properties.
function Listbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ChoosePath_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
    global Path;
    global map;
    
    [Directory,File] = uigetfile();
    Path = strcat(File,Directory);
    cla(handles.Figure);
    set(handles.ChoosePath,'String',Path);
    set(handles.PointTable,'Enable','on');
    set(handles.InputCursor,'Enable','on');
    set(handles.ViewSetup,'Enable','on');
    set(handles.MessagePrompt,'String','Choose start point and goal boundaries. Either type point locations directly into table, or select them with input by cursor. View setup with view setup.');
    
    mapstruct = load(Path);
    map_names = fieldnames(mapstruct);
    map = getfield(mapstruct,map_names{1});
    
    DISPLAY_patchwork(map,handles.Figure);
    
function PointTable_CellSelectionCallback(hObject, eventdata, handles)
    PointTable_CellEditCallback(hObject, eventdata, handles);
    
function PointTable_CellEditCallback(hObject, eventdata, handles) 
    global START;
    global BOUNDARY;
    
    filled = 0;
    data = get(handles.PointTable,'Data');
    
    if(isempty(data{1,1}) ~= 1)
        START.x = data{1,1};
        filled = filled + 1;
    end
    if(isempty(data{2,1}) ~= 1)
        START.y = data{2,1};
        filled = filled + 1;
    end
    if(isempty(data{1,2}) ~= 1)
        FIRST.x = data{1,2};
        filled = filled + 1;
    end
    if(isempty(data{2,2}) ~= 1)
        FIRST.y = data{2,2};
        filled = filled + 1;
    end
    if(isempty(data{1,3}) ~= 1)
        LAST.x = data{1,3};
        filled = filled + 1;
    end
    if(isempty(data{2,3}) ~= 1)
        LAST.y = data{2,3};
        filled = filled + 1;
    end
    BOUNDARY.xmin = min(FIRST.x,LAST.x);
    BOUNDARY.ymin = min(FIRST.y,LAST.y);
    BOUNDARY.xmax = max(FIRST.x,LAST.x);
    BOUNDARY.ymax = max(FIRST.y,LAST.y);
    
    %If START and BOUNDARY have no null spaces then enable the calculation
    %section
    if(filled == 6)
        set(handles.Calculate,'Enable','on');
    end

% --- Executes on button press in ViewSetup.
function ViewSetup_Callback(hObject, eventdata, handles)
    global map;
    global START;
    global BOUNDARY;
    
    hold on;
    cla(handles.Figure);
    pause(0.1);
    set(handles.MessagePrompt,'String','These are the start and goal boundaries. You can change these by reselecting.');
    DISPLAY_patchwork(map,handles.Figure);
    DISPLAY_goal_and_start(START,BOUNDARY,handles.Figure);
    hold off;


% --- Executes on button press in InputCursor.
function InputCursor_Callback(hObject, eventdata, handles)
    global START;
    global BOUNDARY;
    
    %Pause for a while so it will allow selection from figure
    pause(0.1);
    
    %Wait for a point selection from figure
    set(handles.MessagePrompt,'String','Please select the start point from the figure');
    waitfor(handles.Figure,'currentPoint');
    cursorCoordinates = get(handles.Figure,'currentPoint');
    START.y = cursorCoordinates(1,1);
    START.x = cursorCoordinates(1,2);
    set(handles.PointTable,'Data',{START.x,[],[];START.y,[],[];[],[],[];[],[],[]});
    
    %Now get the two boundary points
    set(handles.MessagePrompt,'String','Please select the top left corner of the goal boundary');
    waitfor(handles.Figure,'currentPoint');
    cursorCoordinates = get(handles.Figure,'currentPoint');
    FIRST.y = cursorCoordinates(1,1);
    FIRST.x = cursorCoordinates(1,2);
    set(handles.PointTable,'Data',{START.x,FIRST.x,[];START.y,FIRST.y,[];[],[],[];[],[],[]});
    set(handles.MessagePrompt,'String','Please select the bottom right corner of the goal boundary');
    waitfor(handles.Figure,'currentPoint');
    cursorCoordinates = get(handles.Figure,'currentPoint');
    LAST.y = cursorCoordinates(1,1);
    LAST.x = cursorCoordinates(1,2);
    set(handles.PointTable,'Data',{START.x,FIRST.x,LAST.x;START.y,FIRST.y,LAST.y;[],[],[];[],[],[]});
    BOUNDARY.xmin = min(FIRST.x,LAST.x);
    BOUNDARY.xmax = max(FIRST.x,LAST.x);
    BOUNDARY.ymin = min(FIRST.y,LAST.y);
    BOUNDARY.ymax = max(FIRST.y,LAST.y);
    
    %Now just make sure that all the cells are filled
    PointTable_CellEditCallback(hObject, eventdata, handles);
