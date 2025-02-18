function SIGDAT = set_automatic_drifttime(SIGDAT)
    for h = 1:length(SIGDAT)
        % Get the minimum 
        starttime = min(SIGDAT(h).signal.Time_Sec_);

        % Round up the seconds
        starttime = ceil(starttime);

        % Format the seconds to the right HH:MM format
        startdate = datestr(seconds(starttime),'HH:MM');

        % Split the startdate into hours and minutes
        time_parts = split(startdate, ':');
        hours = char(time_parts(1));
        minutes = char(time_parts(2));

        % Save the hours and minutes in the cut_sig structure
        SIGDAT(h).hh = hours;
        SIGDAT(h).mm = minutes;
    end
end