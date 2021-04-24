function [v, f, vt, vn] = readObj(filename)
%
% obj = readObj(fname)
%
% This function parses wavefront object data
% It reads the mesh vertices, texture coordinates, normal coordinates
% and face definitions(grouped by number of vertices) in a .obj file 
% 
% INPUT: fname - wavefront object file full path
%
% OUTPUT: v - mesh vertices
%       : vt - texture coordinates
%       : vn - normal coordinates
%       : f - face definition assuming faces are made of of 3 vertices
%
% by Renjie Chen, ren.jie.c@gmail.com
%

[filepath,filename,fileext] = fileparts(filename);
if isempty(fileext)
	objname = [filename '.obj'];
else
	objname = [filename fileext];
end
if isempty(filepath)
    filepath = '.';
end

% Check if obj file exists
if exist([filepath filesep objname]) == 0
    filepath = getenv('ModelsFolder');
    if exist([filepath filesep objname]) == 0
        error(['Can''t find ' objname]);
    end
end

% set up field types
str = sprintf('\n\n%s', fileread([filepath filesep objname]));

if numel(str)>1 && str(1) == 'v'
    assert(false, 'Invalid file format!');
end

% use 'tokens' instead of 'match' to remove the text head
% a = regexp(str, '\n\s*v (.*)', 'dotexceptnewline', 'tokens');

a = regexp(str, '\n\s*v .*', 'dotexceptnewline', 'match');

% v = cell2mat(textscan(sprintf('%s\n', a{:}), 'v %f %f %f%*[^\n]'));
% v = cell2mat(textscan(strcat(a{:}), 'v %f %f %f%*[^\n]'));
v = textscan([a{:}], 'v %f %f %f%*[^\n]', 'CollectOutput', 1);
v = v{1};

a = regexp(str, '\n\s*f .*', 'dotexceptnewline', 'match');  % allow spaces before 'f ...'
if ~isempty(a)
    noslash = isempty( strfind(a{1}, '/') );
    deg = numel( regexp(a{1}, '\d%*[^ ]*') );
    if noslash
        f = cell2mat(textscan([a{:}], ['f' repmat(' %d', 1, deg)]));
    else
        f = cell2mat( textscan([a{:}], ['f' repmat(' %d%*[^ ] ', 1, deg-1) ' %d%*[^\n]']) ); % to do, take care other attributes
    end
end

vt = []; vn = []; 
a = regexp(str, '\nvn .*', 'dotexceptnewline', 'match');
if ~isempty(a)
    vn = cell2mat(textscan([a{:}], 'vn %f %f %f'));
end

a = regexp(str, 'vt .*', 'dotexceptnewline', 'match');
a = cellfun(@(x) x(3:end), a, 'UniformOutput', false);
if ~isempty(a)
%     vt = cell2mat(textscan([a{:}], '%f %f %*[^\n]'));

%     vt = sscanf([a{:}], '%f', [numel(a),inf]);
    vt = reshape(sscanf([a{:}]', '%f', [numel(a),inf]), [], numel(a))';
end


f = double(f);

if min( min(f) ) == 0
    f = f+1;
end

sprintf('点的个数为%d,面数为%d',max(f(:)),size(f,1)); 