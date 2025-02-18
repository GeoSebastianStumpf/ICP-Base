

SessionTable = table();

project(1).session.session_name = "asdf";
project(2).session.session_name = "qewr";
project(3).session.session_name = "zxcv";

for i = 1:numel(project)
    SessionTable.Number{i, 1} = i;
    SessionTable.SessionName{i, 1} = project(i).session.session_name;

end

