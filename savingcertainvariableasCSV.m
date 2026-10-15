% Saving certain variable as CSV files
clc; clear; tic; starttime = string(datetime("now","Format", 'dd-MM-yyyy_HH-mm-SS')); disp(starttime)
filepath = "D:\KMSP 30R Copy";
lsfilepath = string(ls(filepath));
chosenvar = "press_static_npm2";
extractpath = "C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\extract folder";
csvsavepath = fullfile("C:\Users\Sultan F. Respati\Documents\00. TA\KMSPFILEANALYSIS\saved " + chosenvar + " csv");

if isfolder(extractpath) ~= 0
    rmdir(extractpath,"s");
else
    mkdir(extractpath)
end

if isfolder(csvsavepath) == 0
    mkdir(csvsavepath);
end

errorlog = cell(4222,1);
parfor i = 3:4222
    extractpathi = fullfile(extractpath, sprintf('%d', i))
    mkdir(extractpathi)
    try
     unzip(fullfile(filepath, lsfilepath(i,:)), extractpathi);
    catch ME
        errorlog{i} = ME.message;
        continue
    end
     lsextractpathi = string(ls(extractpathi));
     opt = detectImportOptions(fullfile(extractpathi, lsextractpathi(3,:)));
     opt.SelectedVariableNames = chosenvar;
     data = readmatrix(fullfile(extractpathi, lsextractpathi(3,:)), opt);
     data = data(~isnan(data));
     data(isempty(data)) = [];
     writematrix(data, fullfile(csvsavepath, join([chosenvar lsextractpathi(3,:)])))
     rmdir(extractpathi,"s")
     toc
end
endtime = string(datetime("now","Format", 'dd-MM-yyyy_HH-mm-SS')); disp(starttime), disp(endtime)
if ~isempty(errorlog) == 1
    errorlog = errorlog(~cellfun(@isempty,errorlog));
    writecell([{starttime}; errorlog; {endtime}], fullfile("D:\KMSP main datasave\errorlog " + chosenvar + " " + starttime + ".txt"))
end
rmdir(extractpath, "s")
toc