#include<iostream>
#include<iomanip>
#include<fstream>
#include<vector>
#include<string>


using namespace std;

int main()
{
	int num1, num2, num3, num4, num5, num6, num7, year, n;
	int height, temp, elevation, pressure, winddir, windspeed, hour;
	double hmax, hmin;
	string date, lat, lng, location, units, filename, fileoutname;
	ifstream fin;
	ofstream fout, fout1;


	cout << "Enter the name of the .txt file you wish to read (inlcuding '.txt'). " << endl;
	cin >> filename;

	fileoutname = "wind data.csv";

	cout << "What is the max height (m)? " << endl;
	cin >> hmax;

	cout << "What is the minumum height (m)?" << endl;
	cin >> hmin;

	//Open the files to stream
	fin.open(filename);
	fout.open("InputText.txt");
	fout1.open(fileoutname);

	//Set the headers of the output file to be "direction" and "speed"
	fout1 << "direction" << "," << "speed" <<  endl;
	
	n = 1;
	
	//Check to be sure the file opened properly
	if (fin.fail() == 1)
	{
		cout << "Failed to open file." << endl;
		system("Pause");
	}
	//Resume if the file is opened properly
	else
	{
		cout << "Computing...";
		//Check to see if the input file is the New Mexico Data
		if (filename == "NewMexicoData.txt")
		{

			while (!fin.eof())
			{
				
				fin >> num1;

				//Check what the first input is 

				if (num1 == 254)
				{
					//Input the hour, day, month, and year of the reading
					fin >> hour;
					fin >> num3;
					fin >> date;
					fin >> year;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << hour << setw(10) << num3 << setw(10)
						<< date << setw(10) << year << setw(10) << endl;

				}
				else if (num1 == 1)
				{
					//Input the wban#, wmo#, latitude, longetude, elevation, and Rtime
					fin >> num2;
					fin >> num3;

					//input the latitude and longetude data together since there is no space between the two of them.
					fin >> lat;	

					fin >> elevation;
					fin >> num5;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << num2 << setw(10) << num3 << setw(10)
						<< lat << setw(10) << lng << setw(10) << elevation << setw(10) << num5
						<< endl;
				}
				else if (num1 == 2)
				{
					//Input Hydro, MXWD, TROPL, Lines, TIndex, and Source
					fin >> num2;
					fin >> num3;
					fin >> num4;
					fin >> num5;
					fin >> num6;
					fin >> num7;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << num2 << setw(10) << num3 << setw(10)
						<< num4 << setw(10) << num5 << setw(10) << num6 << setw(10) << num7
						<< endl;
				}

				else if (num1 == 3)
				{
					//Check if the year being computed is less than 1990 since there is a slight difference in format
					if (year <= 1990)
					{
						//Input STAID and the Units
						fin >> location;
						fin >> units;

						//Output to "InputText.txt" what was read
						fout << setw(10) << num1 << setw(10) << location << setw(10) << num3 << setw(10)
							<< units << setw(10) << endl;
					}
					else
					{
						//Input STAID, Sonde, and the Units
						fin >> location;
						fin >> num3;
						fin >> units;

						//Output to "InputText.txt" what was read
						fout << setw(10) << num1 << setw(10) << location << setw(10) << num3 << setw(10)
							<< units << setw(10) << endl;
					}
				}

				else if (num1 == 4 || 5 || 6 || 7 || 8 || 9)
				{
					//Input Pressure, Height, Temperature, Dew-Point, Wind Direction, and Wind Speed
					fin >> pressure;
					fin >> height;
					fin >> temp;
					fin >> num2;
					fin >> winddir;
					fin >> windspeed;
					
					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << pressure << setw(10) << height << setw(10) << temp << setw(10)
						<< num2 << setw(10) << winddir << setw(10) << windspeed << setw(10) << endl;


					//Check to see if the total height is in the target area and that there is usable data at those points
					if ((height + elevation) >= hmin && (height + elevation) <= hmax && height != 99999 && winddir != 99999 && windspeed != 99999)
					{
						//Output the Wind Direction and the Wind Speed
						fout1 << winddir << "," << windspeed <<  endl;
					}

				}
			}
		}
		else
		{
			while (!fin.eof())
			{
				fin >> num1;

				//Check what the first input is 

				if (num1 == 254)
				{
					//Input the hour, day, month, and year of the reading
					fin >> hour;
					fin >> num3;
					fin >> date;
					fin >> year;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << hour << setw(10) << num3 << setw(10)
						<< date << setw(10) << year << setw(10) << endl;

				}
				else if (num1 == 1)
				{
					//Input the wban#, wmo#, latitude, longetude, elevation, and Rtime
					fin >> num2;
					fin >> num3;
					fin >> lat;
					fin >> lng;
					fin >> elevation;
					fin >> num5;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << num2 << setw(10) << num3 << setw(10)
						<< lat << setw(10) << lng << setw(10) << elevation << setw(10) << num5
						<< endl;
				}
				else if (num1 == 2)
				{
					//Input Hydro, MXWD, TROPL, Lines, TIndex, and Source
					fin >> num2;
					fin >> num3;
					fin >> num4;
					fin >> num5;
					fin >> num6;
					fin >> num7;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << num2 << setw(10) << num3 << setw(10)
						<< num4 << setw(10) << num5 << setw(10) << num6 << setw(10) << num7
						<< endl;
				}

				else if (num1 == 3)
				{
					//Input STAID, Sonde, and the Units
					fin >> location;
					fin >> num3;
					fin >> units;
				}

				else if (num1 == 4 || 5 || 6 || 7 || 8 || 9)
				{
					//Input Pressure, Height, Temperature, Dew-Point, Wind Direction, and Wind Speed
					fin >> pressure;
					fin >> height;
					fin >> temp;
					fin >> num2;
					fin >> winddir;
					fin >> windspeed;

					//Output to "InputText.txt" what was read
					fout << setw(10) << num1 << setw(10) << pressure << setw(10) << height << setw(10) << temp << setw(10)
						<< num2 << setw(10) << winddir << setw(10) << windspeed << setw(10) << endl;

					//Check to see if the total height is in the target area and that there is usable data at those points
					if ((height + elevation) >= hmin && (height + elevation) <= hmax && height != 99999 && winddir != 99999 && windspeed != 99999)
					{
						//Output the Wind Direction and the Wind Speed
						fout1 << winddir << "," << windspeed <<  endl;
					}

				}
			}
		}
	}
	fin.close();
	fout.close();
	fout1.close();
	return 0;
}