function data = importImageJBCData(filename, dataLines)
%IMPORTFILE Import data from a text file
%  NEURONSPATTERN05PLOTDATA = IMPORTFILE(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the numeric data.
%
%  NEURONSPATTERN05PLOTDATA = IMPORTFILE(FILE, DATALINES) reads data for
%  the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  NeuronsPattern05PlotData = importfile("Z:\Keck\Programs\MO\FinalConsolidated\Neurons\Analysis\Neurons_Pattern 05_PlotData.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 08-May-2019 13:30:22

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["X", "Y", "YFit"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
data = readtable(filename, opts);

%% Convert to output type
data = table2array(data);
end