%ERASE_UNKWINDOW
% This callback is summoned whenever the user want to delete an integration window
% selection in the unknown plot window

currentfig = get(gcf,'UserData'); %find out which unknown we are dealing with
currentobj = get(gco,'tag');
unktags = [UNK.order_opened]; %list all the unknowns available, using their order_opened tags
KC = find(unktags == currentfig); %make the current unknown the one just selected via clicking its graph.

if strcmp(currentobj,'UNK.handles.h_unkbg_erase')==1
    
    %reset the background window
    UNK(KC).bgwindow = []; 
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.9 .9 .9]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['bgfrom' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['bgto' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(UNK(KC).handles.h_unkbg_total,'string',[]);
    SILLSFIG_UPDATE;
    
elseif strcmp(currentobj,'UNK.handles.h_unkmat1_erase')==1

    %reset the background window
    UNK(KC).mat1window = []; 
    UNK(KC).mattotal = 0;
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.9 1 .9]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['mat1from' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['mat1to' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(UNK(KC).handles.h_unkmat1_total,'string',[]);
    SILLSFIG_UPDATE;

elseif strcmp(currentobj,'UNK.handles.h_unkmat2_erase')==1

    %reset the background window
    UNK(KC).mat2window = []; 
    UNK(KC).mattotal = 0;
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.8 1 .8]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['mat2from' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['mat2to' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(UNK(KC).handles.h_unkmat2_total,'string',[]);

elseif strcmp(currentobj,'UNK.handles.h_unkcomp1_erase')==1

    %reset the background window
    UNK(KC).comp1window = []; 
    UNK(KC).sigtotal = 0;
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.9 .9 1]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['comp1from' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['comp1to' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(UNK(KC).handles.h_unkcomp1_total,'string',[]);
    SILLSFIG_UPDATE;

elseif strcmp(currentobj,'UNK.handles.h_unkcomp2_erase')==1

    %reset the background window
    UNK(KC).comp2window = []; 
    UNK(KC).sigtotal = 0;
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.8 .8 1]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['comp2from' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['comp2to' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(UNK(KC).handles.h_unkcomp2_total,'string',[]);
    SILLSFIG_UPDATE;

elseif strcmp(currentobj,'UNK.handles.h_unkcomp3_erase')==1

    %reset the background window
    UNK(KC).comp3window = []; 
    UNK(KC).sigtotal = 0;
    
    %get rid of the current patch
    searchdestroy = findobj(gcf,'facecolor',[.7 .7 1]);
    delete(searchdestroy); 
    
    %clear the textboxes
    set(findobj('UserData',['comp3from' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(findobj('UserData',['comp3to' -1000*UNK(KC).order_opened]),'string',[],'Value',[]);
    set(UNK(KC).handles.h_unkcomp3_total,'string',[]);
    SILLSFIG_UPDATE;

end
clear currentfig currentobj unktags KC searchdestroy
