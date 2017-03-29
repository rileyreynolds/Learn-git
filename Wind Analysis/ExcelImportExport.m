clc; clear all; close all;


%CHOOSE A NAME FOR THE TITLE OF THE PROBABILITY DISTRIBUTION CHART
GraphTitle= 'Gabon 20.1-21.6 km';


%CHOOSE THE DIRECTION OF INTEREST BETWEEN 0 AND 360      
%FOR THE PROBABILITY DISTRIBUTION CHART
MinDirection=0;
MaxDirection=360;






%% Change the .csv file to a .xlsx file that can be read by the program
a=readtable('wind data.csv');
A = table2array(a);
if exist('wind data.xlsx','file'); delete('wind data.xlsx'); end
xlswrite('wind data.xlsx', A);



%% Check that excel.exe is not running

[~,result] = system('tasklist /FI "imagename eq excel.exe" /fo table /nh'); %Check if the process excel.exe is running (taks manager process list)
while ~isempty(strfind(result,'EXCEL.EXE')) % If excel.exe is there, display message
    PosibAnswers   = {'I have saved my work and manually closed excel','I cannot close excel, kill the process'};
    Seleccion    = questdlg({'Excel is running.';'Save your work, close excel and choose one of the following options.'},'EXCEL IS RUNNING!',PosibAnswers{1},PosibAnswers{2},PosibAnswers{1});
    switch Seleccion
        case PosibAnswers{2} % If user wants to kill the process
            system('taskkill /IM "Excel.exe" /F /T'); % Kill the process, force termination
    end
    [~,result]   = system('tasklist /FI "imagename eq excel.exe" /fo table /nh'); % Re check that excel is not running.
end

%% Reading data, creating windrose, writing output table and saving image into file.
% Read the excel spreadsheet data

%d=readtable('GabonWindResults.txt');
%D = table2array(a);


ExcelName   = [pwd filesep 'wind data.xlsx'];          % Full path to Excel input file e.g.: 'C:\Users\User1\Desktop\Wind data.xlsx'
OutputExcel = [pwd filesep 'wind data outputs.xlsx'];  % Full path to Excel output file e.g.: 'C:\Users\User1\Desktop\Wind data.xlsx'
if exist(OutputExcel,'file'); delete(OutputExcel); end % Delete the output excel if it exists, as a new one will be created.
[data]      = xlsread(ExcelName); % 'Data'

% Assign direction and speed
direction = data(:,1); % Directions are in the first column
speed = data(:,2);     % Speeds are in the second column

% Define options for the wind rose 
Options = {'anglenorth',0,... 'The angle in the north is 0 deg (this is the reference from our data, but can be any other)
           'angleeast',90,... 'The angle in the east is 90 deg
           'labels',{'N (0°)','S (180°)','E (90°)','W (270°)'},... 'If you change the reference angles, do not forget to change the labels.
           'freqlabelangle',45};

% Launch the windrose with necessary output arguments.
[figure_handle,count,speeds,directions,Table] = WindRose(direction,speed,Options);

% Write the output table into same excel, new worksheet
% Change OutputExcel to ExcelName if you want the outputs to be created in the input excel.
xlswrite(OutputExcel,Table,1,'A1'); % Write into the ExcelFile the table data in sheet 1 (you can specify a name), starting at cell A1.

% Save the figure into an image file
ImageName = ['WindRose_' datestr(now,'yymmdd_HHMMSS') '.png']; % Save the image into WindRose_date_time.png
print('-dpng',ImageName,'-painters'); % Print = save
%delete(figure_handle); % Close the widnrose figure
clear figure_handle;   % Clear the figure handle variable

%% Writing the image into excel (tricky part)
% Retrieve image dimensions
a      = size(imread(ImageName));
width  = a(2);
height = a(1);
clear a;

% Open the excel file for internal modifications
Excel = actxserver ('Excel.Application'); % handle to excel application
try
    ExcelWorkbook = Excel.workbooks.Open(OutputExcel); % Excel 2010+
catch exc
    try
        ExcelWorkbook = invoke(Excel.workbooks,'Open',OutputExcel); % Previous versions
    catch exc2
        disp(exc.message);disp(exc2.message);throw(exc2); % didn't work. could not open excel file for modifications.
    end
end

% Get the sheet name
Sheets  = Excel.ActiveWorkBook.Sheets;
ActSht = Sheets.Item(1); % If you specified a name for the output sheet, specify it here again, insetad of 1.

% Convert the pixels into points
auxfig = figure('units','pixels','position',[0 0 width height]); % auxiliary figure with dimensions in pixels
set(auxfig,'units','points'); % convert dimensions into points
p = get(auxfig,'position');   % Get the position in points
delete(auxfig);               % close the auxiliary figure
clear auxfig;
p      = p * 0.75;            % Scale factor for image in excel, change as needed.
width  = p(3);                % Width in points
height = p(4);                % heihgt in points

% Add the picture inside the excel
ActSht.Shapes.AddPicture([pwd filesep ImageName],0,1,ActSht.Range('B1').Left,ActSht.Range(['A' num2str(size(Table,1)+2)]).Top,width,height);  % VBA reference:  .AddPicture(Filename, LinkToFile, SaveWithDocument, Left, Top, Width, Height)

% Close the excel file
[~,~,Ext]  = fileparts(OutputExcel);
if strcmpi(Ext,'.xlsx') % If xlsx file
    ExcelWorkbook.Save  % Save the workbook
    ExcelWorkbook.Close(false) % Close Excel workbook.
    Excel.Quit;         % Quit excel application
    delete(Excel);      % Delete the handle to the application
elseif strcmpi(Ext,'.xls') % If old format
    invoke(Excel.ActiveWorkbook,'Save'); % Save
    Excel.Quit          % Quit Excel application
    Excel.delete        % Delete the handle to the application.
end






%%%% PLOT THE NORMAL DISTRIBUTION CURVE FOR THE DATA %%%%



a=readtable('wind data.csv');

%a=readtable('wind data.xlsx');
name=GraphTitle;
dirmin=MinDirection;
dirmax=MaxDirection;
A = table2array(a);
n=size(A);
i=1;
C=[];

%FIND THE IMPORTANT DIRECTIONS
while i <= n(1,1)
    if A(i,1) >= dirmin && A(i,1) <= dirmax
        C(end+1,1)=A(i,1);
        C(end,2)=A(i,2);
    end
    i=i+1;
end

A=C;
%Find the mean speed
MU=mean(A(:,2));     
%Find the standard deviation
SIGMA=std(A(:,2));
%Find the max speed
MAX=max(A(:,2));
%Sort from lowest to highest speed
SORTspeed=sort(A(:,2));
%Find the norm of each data point
norm=normpdf(SORTspeed,MU,SIGMA);
%Find the max of the norm points
MAXnorm=max(norm);


%Find the size of the new sorted speed vector
n=size(SORTspeed);
%Create a new matrix with the speeds and their norm point 
B=[SORTspeed, norm];
%Find the 95th percentile of the speeds
per95=prctile(SORTspeed,95);


MU1=[];
zer1=[0];
zer2=[0];
zer3=[0];
zer4=[0];
pe95=[];
sig1=[];
sig2=[];
i=1;

while i<=n(1)
    %FIND THE MEAN
    if(B(i,1)<MU+3 && B(i,1)>MU-3)
       MU1(1,1)= B(i,1);
       MU1(2,1)=B(i,1);
       zer1(2,1)=B(i,2);
    end
    %FIND THE 95TH PERCENTILE
    if (B(i,1)>per95-2 && B(i,1)<per95+2)
        pe95(1,1)=B(i,1);
        pe95(2,1)=B(i,1);
        zer2(2,1)=B(i,2);
    end
    %FIND WITHIN +1 STANDARD DEVIATION
    if (B(i,1)<MU+SIGMA +3 && B(i,1)>MU+SIGMA -3)
        sig1(1,1)=B(i,1);
        sig1(2,1)=B(i,1);
        zer3(2,1)=B(i,2);
    end
    
    %FIND WITHIN -1 STANDARD DEVIATION
    if (B(i,1)<MU-SIGMA +3 && B(i,1)>MU-SIGMA -3)
        sig2(1,1)=B(i,1);
        sig2(2,1)=B(i,1);
        zer4(2,1)=B(i,2);
    end
    
    
    i=i+1;
end

figure (2) 
%Plot Mean Value
plot(MU1(:,1),zer1(:,1), 'm')
hold on

%Plot 95th Percentile Value
plot(pe95(:,1),zer2(:,1),'g')
hold on

%Plot +1 Standard Deviation
plot(sig1(:,1),zer3(:,1),'b')
hold on

%Plot -1 Standard Deviation
plot(sig2(:,1),zer4(:,1),'b')
hold on


%Plot the Probability Distribution
plot(SORTspeed,norm,'k')
title(name)
xlabel('Wind Speed m/10s')
xlim([0,MAX])
ylim([0,MAXnorm*1.1])
hold on
legend('Mean', '95th Percentile', '1 Standard Deviation')

% Save the figure into an image file
ImageName = ['Percentile_' name '.png']; % Save the image into WindRose_date_time.png
print('-dpng',ImageName,'-painters'); % Print = save