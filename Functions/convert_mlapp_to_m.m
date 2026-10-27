

export_mlapp_to_m('C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\ICP-Base\ICP-Base_dev', 'C:\Users\Sebastian\OneDrive - Universitaet Bern\PhD\ICP-Base\ICP-Base_dev\Source_code_readable')

           

function export_mlapp_to_m(source_folder, target_folder)
% EXPORT_MLAPP_TO_M  Writes the code of every .mlapp file below source_folder
% as a readable .m file into target_folder.
%
%   export_mlapp_to_m('C:\Users\Me\ICP-Base', 'C:\Users\Me\ICP-Base_mfiles')
%
% The copies get the suffix _readable in the file name AND in the class name
% (classdef line and constructor), so they can stay on the MATLAB path next to the
% original apps without shadowing them.
% Apps whose file name contains one of the strings in excluded_patterns are skipped.

    name_suffix       = '_readable';
    excluded_patterns = {'Correction_Module', 'VisModule', 'Combine', 'GeoC', 'EasyPlot', 'HistogramFilter', };

    if ~isfolder(source_folder)
        error('export_mlapp_to_m:noSource', 'Source folder not found: %s', source_folder);
    end
    if ~isfolder(target_folder)
        mkdir(target_folder);
    end

    files = dir(fullfile(source_folder, '**', '*.mlapp'));

    is_excluded = false(numel(files), 1);
    for p = 1:numel(excluded_patterns)
        is_excluded = is_excluded | contains({files.name}', excluded_patterns{p}, 'IgnoreCase', true);
    end
    for k = find(is_excluded)'
        fprintf('EXCLUDED %s\n', fullfile(files(k).folder, files(k).name));
    end
    files = files(~is_excluded);

    if isempty(files)
        disp('No .mlapp files found.');
        return
    end

    written_names = strings(0, 1);
    n_ok = 0;

    for k = 1:numel(files)
        source_file = fullfile(files(k).folder, files(k).name);
        [~, app_name] = fileparts(files(k).name);
        readable_name = [app_name name_suffix];

        % two apps with the same name in different subfolders would overwrite each other
        if any(written_names == readable_name)
            fprintf('SKIPPED  %s  (name already exported from another folder)\n', source_file);
            continue
        end

        try
            code = read_mlapp_code(source_file);
        catch ME
            fprintf('FAILED   %s  (%s)\n', source_file, ME.message);
            continue
        end

        code   = rename_class(code, app_name, readable_name);
        header = sprintf(['%% GENERATED from %s on %s by export_mlapp_to_m. ' ...
            'This file is for reading purposes, any real changes need to be applied to the .mlapp files and exported again.\n'], ...
            files(k).name, char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm')));

        out_file = fullfile(target_folder, [readable_name '.m']);
        fid = fopen(out_file, 'w', 'n', 'UTF-8');
        if fid < 0
            fprintf('FAILED   %s  (cannot write %s)\n', source_file, out_file);
            continue
        end
        fprintf(fid, '%s%s', header, code);
        fclose(fid);

        written_names(end+1, 1) = string(readable_name); %#ok<AGROW>
        n_ok = n_ok + 1;
        fprintf('OK       %s  ->  %s\n', source_file, out_file);
    end

    fprintf('\n%d of %d apps exported to %s (%d excluded)\n', ...
        n_ok, numel(files), target_folder, nnz(is_excluded));
end


function code = rename_class(code, old_name, new_name)
    % the classdef line and the constructor must carry the new name, like the file
    code = regexprep(code, ['(^\s*classdef\s+)' old_name '\>'], ['$1' new_name], 'once', 'lineanchors');
    code = regexprep(code, ['(function\s+app\s*=\s*)' old_name '\>'], ['$1' new_name], 'once');
end


function code = read_mlapp_code(mlapp_file)
    % first choice: the internal function that App Designer itself uses
    try
        code = matlab.internal.getCode(mlapp_file);
        if ~isempty(code)
            return
        end
    catch
        % not available in this release, use the file contents instead
    end

    % fallback: an .mlapp is a zip file, the code is stored in matlab/document.xml
    temp_folder = tempname;
    mkdir(temp_folder);
    cleanup = onCleanup(@() rmdir(temp_folder, 's')); %#ok<NASGU>

    zip_copy = fullfile(temp_folder, 'app.zip');
    copyfile(mlapp_file, zip_copy);
    unzip(zip_copy, fullfile(temp_folder, 'content'));

    document = xmlread(fullfile(temp_folder, 'content', 'matlab', 'document.xml'));
    paragraphs = document.getElementsByTagName('w:p');

    lines = strings(paragraphs.getLength, 1);
    for p = 0:paragraphs.getLength - 1
        texts = paragraphs.item(p).getElementsByTagName('w:t');
        line = "";
        for t = 0:texts.getLength - 1
            node = texts.item(t);
            if node.hasChildNodes
                line = line + string(node.getFirstChild.getData);
            end
        end
        lines(p + 1) = line;
    end
    code = char(strjoin(lines, newline));
end