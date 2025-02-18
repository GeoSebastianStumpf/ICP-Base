%ERASE_STDWINDOW
% This callback is summoned whenever the user want to delete an integration window
% selection in the standard plot window.

currentfig = get(gcf,'UserData'); %find out which unknown we are dealing with
currentobj = get(gco,'tag');
stdtags = [STD.order_opened]; %list all the unknowns available, using their order_opened tags
DC = find(stdtags == currentfig); %make the current unknown the one just selected via clicking its graph.

if strcmp(currentobj,'STD.handles.h_stdbg_erase')==1
    
    %reset the background window
    STD(DC).bgwindow = []; 
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['bgfrom' STD(DC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['bgto' STD(DC).order_opened]),'string',[],'Value',[]);
    set(STD(DC).handles.h_stdbg_total,'string',[]);
    SILLSFIG_UPDATE;
    
elseif strcmp(currentobj,'STD.handles.h_stdsig_erase')==1

    %reset the background window
    STD(DC).sigwindow = []; 
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['sigfrom' STD(DC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['sigto' STD(DC).order_opened]),'string',[],'Value',[]);
    set(STD(DC).handles.h_stdsig_total,'string',[]);
    SILLSFIG_UPDATE;

end
clear searchdestroy
