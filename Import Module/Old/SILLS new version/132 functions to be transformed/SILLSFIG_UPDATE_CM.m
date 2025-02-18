%SILLSFIG_UPDATE_CM

%this callback is summoned when an unknown file is copied or deleted from
%the Calculation Manager

%update the file name in the popup and the output text

if A.KC > 0

    set(SCP.handles.h_currentUNK_popup,'string',A.UNKPOPUPLIST,'value',A.KC);
    set(SCP.handles.h_currentUNK_filename_out,'string',UNK(A.KC).fileinfo.name);

    %update the background values
    if ~isempty(UNK(A.KC).bgwindow)
        set(SCP.handles.h_currentUNK_bgfrom_out,'string',UNK(A.KC).bgwindow(1));
        set(SCP.handles.h_currentUNK_bgto_out,'string',UNK(A.KC).bgwindow(2));
        bgtotal = UNK(A.KC).bgwindow(2) - UNK(A.KC).bgwindow(1);
        set(SCP.handles.h_currentUNK_bgtotal_out,'string',bgtotal);
        clear bgtotal;
    else
        set(SCP.handles.h_currentUNK_bgfrom_out,'string',[]);
        set(SCP.handles.h_currentUNK_bgto_out,'string',[]);
        set(SCP.handles.h_currentUNK_bgtotal_out,'string',[]);
    end

    if ~isempty(UNK(A.KC).mat1window)
        set(SCP.handles.h_currentUNK_mat1from_out,'string',UNK(A.KC).mat1window(1));
        set(SCP.handles.h_currentUNK_mat1to_out,'string',UNK(A.KC).mat1window(2));
        mat1total = UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1);
        set(SCP.handles.h_currentUNK_mat1total_out,'string',mat1total);
        clear mat1total;
        x = UNK(A.KC).mat1window(2)-UNK(A.KC).mat1window(1);
    else
        set(SCP.handles.h_currentUNK_mat1from_out,'string',[]);
        set(SCP.handles.h_currentUNK_mat1to_out,'string',[]);
        set(SCP.handles.h_currentUNK_mat1total_out,'string',[]);
        x = 0;
    end

    if ~isempty(UNK(A.KC).mat2window)
        set(SCP.handles.h_currentUNK_mat2from_out,'string',UNK(A.KC).mat2window(1));
        set(SCP.handles.h_currentUNK_mat2to_out,'string',UNK(A.KC).mat2window(2));
        mat2total = UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1);
        set(SCP.handles.h_currentUNK_mat2total_out,'string',mat2total);
        clear mat2total;
        y = UNK(A.KC).mat2window(2)-UNK(A.KC).mat2window(1);
    else
        set(SCP.handles.h_currentUNK_mat2from_out,'string',[]);
        set(SCP.handles.h_currentUNK_mat2to_out,'string',[]);
        set(SCP.handles.h_currentUNK_mat2total_out,'string',[]);
        y = 0;
    end

    if ~isempty(UNK(A.KC).comp1window)
        set(SCP.handles.h_currentUNK_comp1from_out,'string',UNK(A.KC).comp1window(1));
        set(SCP.handles.h_currentUNK_comp1to_out,'string',UNK(A.KC).comp1window(2));
        comp1total = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
        set(SCP.handles.h_currentUNK_comp1total_out,'string',comp1total);
        clear comp1total;
        a = UNK(A.KC).comp1window(2)-UNK(A.KC).comp1window(1);
    else
        set(SCP.handles.h_currentUNK_comp1from_out,'string',[]);
        set(SCP.handles.h_currentUNK_comp1to_out,'string',[]);
        set(SCP.handles.h_currentUNK_comp1total_out,'string',[]);
        a = 0;
    end

    if ~isempty(UNK(A.KC).comp2window)
        set(SCP.handles.h_currentUNK_comp2from_out,'string',UNK(A.KC).comp2window(1));
        set(SCP.handles.h_currentUNK_comp2to_out,'string',UNK(A.KC).comp2window(2));
        comp2total = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
        set(SCP.handles.h_currentUNK_comp2total_out,'string',comp2total);
        clear comp2total;
        b = UNK(A.KC).comp2window(2)-UNK(A.KC).comp2window(1);
    else
        set(SCP.handles.h_currentUNK_comp2from_out,'string',[]);
        set(SCP.handles.h_currentUNK_comp2to_out,'string',[]);
        set(SCP.handles.h_currentUNK_comp2total_out,'string',[]);
        b = 0;
    end

    if ~isempty(UNK(A.KC).comp3window)
        set(SCP.handles.h_currentUNK_comp3from_out,'string',UNK(A.KC).comp3window(1));
        set(SCP.handles.h_currentUNK_comp3to_out,'string',UNK(A.KC).comp3window(2));
        comp3total = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
        set(SCP.handles.h_currentUNK_comp3total_out,'string',comp3total);
        clear comp3total;
        c = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
        set(SCP.handles.h_currentUNK_sigtotal_out,'string',UNK(A.KC).sigtotal);
    else
        set(SCP.handles.h_currentUNK_comp3from_out,'string',[]);
        set(SCP.handles.h_currentUNK_comp3to_out,'string',[]);
        set(SCP.handles.h_currentUNK_comp3total_out,'string',[]);
        c = 0;
    end

    UNK(A.KC).mattotal = x + y;
    set(SCP.handles.h_currentUNK_mattotal_out,'string',UNK(A.KC).mattotal);
    if UNK(A.KC).mattotal == 0;
        set(SCP.handles.h_currentUNK_mattotal_out,'string',[]);
    end
    clear x y

    UNK(A.KC).sigtotal = a + b + c;
    set(SCP.handles.h_currentUNK_sigtotal_out,'string',UNK(A.KC).sigtotal);
    if UNK(A.KC).sigtotal == 0;
        set(SCP.handles.h_currentUNK_sigtotal_out,'string',[]);
    end
    clear a b c

else
    set(SCP.handles.h_currentUNK_filename_out,'string',[]);
    set(SCP.handles.h_currentUNK_bgfrom_out,'string',[]);
    set(SCP.handles.h_currentUNK_bgto_out,'string',[]);
    set(SCP.handles.h_currentUNK_bgtotal_out,'string',[]);
    set(SCP.handles.h_currentUNK_mat1from_out,'string',[]);
    set(SCP.handles.h_currentUNK_mat1to_out,'string',[]);
    set(SCP.handles.h_currentUNK_mat1total_out,'string',[]);
    set(SCP.handles.h_currentUNK_mat2from_out,'string',[]);
    set(SCP.handles.h_currentUNK_mat2to_out,'string',[]);
    set(SCP.handles.h_currentUNK_mat2total_out,'string',[]);
    set(SCP.handles.h_currentUNK_mattotal_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp1from_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp1to_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp1total_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp2from_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp2to_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp2total_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp3from_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp3to_out,'string',[]);
    set(SCP.handles.h_currentUNK_comp3total_out,'string',[]);
    set(SCP.handles.h_currentUNK_sigtotal_out,'string',[]);
end
