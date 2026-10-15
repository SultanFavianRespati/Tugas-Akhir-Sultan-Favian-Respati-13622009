filepath = "G:\.shortcut-targets-by-id\1RnlP5mtkr7ucoDUDjRAoeqcZf203n-aR\Flight Data KMSP 30R";
lsfilepath = string(ls(filepath));
extractpath = "D:\KMSP 30R Extracted";

error = cell(4222,1);
parfor i = 3:4222
    try
    unzip(fullfile(filepath, lsfilepath(i)), extractpath)
    catch ME
        error{i,1} = ME.message
        continue
    end
end
writecell(error, fullfile(extractpath, "errorlog.txt"))