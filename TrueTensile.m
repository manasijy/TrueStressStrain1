%% 
%{
Program to read the stress strain data from xl file 
It corrects the data for incorrect elastic slope


%}

filename = 'C:\Users\PC#3\Desktop\TrueStressStrain\Specimen_RawData_1_L.csv';
delimiter = ',';
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); 
raw(R) = {NaN}; 
Tstrain = cell2mat(raw(:, 1));
Tstress = cell2mat(raw(:, 2));
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;

%{
Correct the stress and strain data
Slope_test = 12000  - This is measured from the test data. This may change
for another test. So please get/confirm this value by linear fit.
Slope_Material = 78000 - This is got from tensile tests with extensometer
%}

Slope_test = 12000;
Slope_Material = 78000;

new_e = Tstrain - Tstress*(1/Slope_test - 1/Slope_Material);
Heading = {'True_Strain', 'True_Stress'};
Corrected_Data = [new_e, Tstress];
xlswrite('New_Data.xlsx', Heading,'A1:B1'); %writes the header for columns
xlswrite('New_Data.xlsx', Corrected_Data,'A2:B1308');% 1308 is the number of rows in the input data file, cross check it.

%%
% %For plotting both results
% plot(new_e,Tstress)
% hold on
% plot(Tstrain,Tstress)
% hold off
%%