
Wind Rose and Normal Distribution Generator



Source Code
The “Source Code” folder contains a C++ code that inputs a file in FSL format and outputs the same file (renames it “Input Text.txt”) and another file 
named “wind data.csv”  with the wind direction (first column) and wind speed (second column) of the selected height range.

The code accounts for insufficient data that is represented in FSL format as 99999. If there is a value of 99999 for either wind speed, wind direction, 
or height, then no data from that line is outputted to the wind data file. 

The code had to be altered slightly for the New Mexico data since there were some slight differences in the FSL format. First, there is no space between 
the latitude and longitude inputs for the location used. This does seem to be common among other data sites. To account for this, the code simply reads 
in the latitude and longitude as a single input. Second, the format of the data changes on the lines where “3” is the input in the first column. Before 
1990 there are only 3 values on the line whereas after 1990, there are 4 values. This does not seem to be a common trend with data from other stations. 
This is accounted for in the code by running a separate code if the file chosen to read is “NewMexicoData.txt.”

If no alterations need to be made to the source code, an executable of the code named “SourceCode” may be accessed in the Wind Analysis folder. 

Input Text
The purpose of outputting the same file that was inputted is to be sure the code is reading everything properly. Occasionally, the data accessed may 
have some irregularities which can then easily be found and fixed using this file.

Wind Rose
“WindRose.m” is a MATLAB function that needs both a wind-direction vector and wind-speed vector. “ExcellImportExport.m” is a MATLAB code that inputs 
the “wind data.csv” file with the wind-direction and wind-speed vectors, duplicates it as “wind data.xlsx,” which is then used to create a wind rose 
and a normal distribution curve of the data. This also outputs a JPG of both graphs and an Excel file name “wind data outputs” that contains the wind 
rose JPG and a table of the frequencies of the speeds and directions of the wind which can all be found in the “Wind Analysis” folder after compiling 
is complete. 

Wind Rose Documentation
license.txt 
The original WindRose.m file was developed and distributed by Daniel Pereira. Alterations and distribution of the code are permitted if the conditions 
mentioned in the “license.txt” file are met. 
WindRose_Doc.pdf
A file produced by the WindRose.m publisher describing how to make alterations to the code in order to change the looks of the graph. 
WindRose_Doc.m
Matlab code for all the alterations that are mentioned and displayed in the WindRose_Doc.pdf file.

Data
More data in FSL format from sites around the world may be accessed here:
http://esrl.noaa.gov/raobs/
A guide to FSL format may be found here: 
http://esrl.noaa.gov/raobs/intl/fsl_format-new.cgi

Process Outline
1. Put the data file that is in the FSL format into the Wind Analysis folder
2. Run the “SourceCode” executable inputting the name of the file and the range of heights.
3. Open both “ExcelImportExport.m” and “WindRose.m” in MATLAB. 
4. Change the title lines in both codes to the desired title for the normal distribution curve and the wind rose graph. These lines are at the beginning 
of both files. Also, if a specific wind direction is to be analyzed for in the normal distribution curve (default 0-360 degrees), this may also be 
changed at the beginning of the “ExcelImportExport.m” code. 
5. Run ExcelImportExport.m.

