%%%%%%%%%%%%%%%%%%%%%%%%% SILLSFIG_UPDATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currentfig = get(gcf,'UserData');

if currentfig > 0 %i.e. if the active figure is a standard
    tags = [STD.order_opened]; %list all the standards available, using their order_opened tags
    A.DC = find(tags == currentfig); %make the current standard the one just selected via clicking its graph.

    %figure(SCP.handles.h_fig);

    %%%%%%%%%%%%%% outputs %%%%%%%%%%%%%%%%

    if A.DC > 0
        set(SCP.handles.h_currentSTD_filename_out,'string',STD(A.DC).fileinfo.name);

        if ~isempty(STD(A.DC).bgwindow)
            set(SCP.handles.h_currentSTD_bgfrom_out,'string',STD(A.DC).bgwindow(1));
            set(SCP.handles.h_currentSTD_bgto_out,'string',STD(A.DC).bgwindow(2));
            bgtotal = STD(A.DC).bgwindow(2) - STD(A.DC).bgwindow(1);
            set(SCP.handles.h_currentSTD_bgtotal_out,'string',bgtotal);
            clear bgtotal;
        else
            set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
        end

        if ~isempty(STD(A.DC).sigwindow)
            set(SCP.handles.h_currentSTD_sigfrom_out,'string',STD(A.DC).sigwindow(1));
            set(SCP.handles.h_currentSTD_sigto_out,'string',STD(A.DC).sigwindow(2));
            sigtotal = STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1);
            set(SCP.handles.h_currentSTD_sigtotal_out,'string',sigtotal);

        else
            set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigtotal_out,'string',[]);
        end

    else
        set(SCP.handles.h_currentSTD_filename_out,'string',[]);
        set(SCP.handles.h_currentSTD_SRM_out,'Visible','off');
        set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
        set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
        set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
        set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
        set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
        set(SCP.handles.h_currentSTD_sigtotal_out,'string',[]);
    end

elseif currentfig < 0 %i.e. if the active figure is an unknown
    tags = [UNK.order_opened]; %list all the standards available, using their order_opened tags
    A.KC = find(tags == currentfig); %make the current standard the one just selected via clicking its graph.

    %    figure(SCP.handles.h_fig);

    %%%%%%%%%%%%%% outputs %%%%%%%%%%%%%%%%

    if A.KC > 0

        set(SCP.handles.h_currentUNK_filename_out,'string',UNK(A.KC).fileinfo.name);

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

elseif currentfig == 0 %i.e. if the current figure is the SILLS Control Panel

    currentobj = get(gco,'tag');

    if strcmp(currentobj,'SCP.handles.h_currentSTD_SRM_out') == 1 %i.e. if the SRM selection was just changed

        A.DC = get(SCP.handles.h_currentSTD_popup,'value'); %confirm which is the current STD
        A.MC = get(SCP.handles.h_currentSTD_SRM_out,'value'); %grab the current SRM value
        STD(A.DC).SRM = A.MC; %assign the selected SRM to the current STD

    elseif strcmp(currentobj,'SCP.handles.h_currentSTD_popup') == 1

        A.DC = get(SCP.handles.h_currentSTD_popup,'value');

        if A.DC > 0
            set(SCP.handles.h_currentSTD_SRM_out,'value',STD(A.DC).SRM);
            A.MC = STD(A.DC).SRM;
            set(SCP.handles.h_currentSTD_filename_out,'string',STD(A.DC).fileinfo.name);
            set(SCP.handles.h_currentSTD_driftpoints_popup,'value',STD(A.DC).timepoint);
            set(SCP.handles.h_currentSTD_drifthh_edit,'string',STD(A.DC).hh);
            set(SCP.handles.h_currentSTD_driftmm_edit,'string',STD(A.DC).mm);

            if ~isempty(STD(A.DC).bgwindow)
                set(SCP.handles.h_currentSTD_bgfrom_out,'string',STD(A.DC).bgwindow(1));
                set(SCP.handles.h_currentSTD_bgto_out,'string',STD(A.DC).bgwindow(2));
                bgtotal = STD(A.DC).bgwindow(2) - STD(A.DC).bgwindow(1);
                set(SCP.handles.h_currentSTD_bgtotal_out,'string',bgtotal);
                clear bgtotal;
            else
                set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
                set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
                set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
            end

            if ~isempty(STD(A.DC).sigwindow)
                set(SCP.handles.h_currentSTD_sigfrom_out,'string',STD(A.DC).sigwindow(1));
                set(SCP.handles.h_currentSTD_sigto_out,'string',STD(A.DC).sigwindow(2));
                sigtotal = STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1);
                set(SCP.handles.h_currentSTD_sigtotal_out,'string',sigtotal);
                clear sigtotal;
            else
                set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
                set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
                set(SCP.handles.h_currentSTD_sigtotal_out,'string',[]);
            end

        else
            set(SCP.handles.h_currentSTD_filename_out,'string',[]);
            set(SCP.handles.h_currentSTD_SRM_out,'Visible','off');
            set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');
            set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_driftcolon,'Visible','off');
            set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigtotal_out,'string',[]);
        end

    elseif strcmp(currentobj,'SCP.handles.h_std_delete_button') == 1

        if A.DC > 0
            A.MC = STD(A.DC).SRM;
            set(SCP.handles.h_currentSTD_SRM_out,'value',A.MC);
            set(SCP.handles.h_currentSTD_filename_out,'string',STD(A.DC).fileinfo.name);
            set(SCP.handles.h_currentSTD_driftpoints_popup,'value',STD(A.DC).timepoint);
            set(SCP.handles.h_currentSTD_drifthh_edit,'string',STD(A.DC).hh);
            set(SCP.handles.h_currentSTD_driftmm_edit,'string',STD(A.DC).mm);

            if ~isempty(STD(A.DC).bgwindow)
                set(SCP.handles.h_currentSTD_bgfrom_out,'string',STD(A.DC).bgwindow(1));
                set(SCP.handles.h_currentSTD_bgto_out,'string',STD(A.DC).bgwindow(2));
                bgtotal = STD(A.DC).bgwindow(2) - STD(A.DC).bgwindow(1);
                set(SCP.handles.h_currentSTD_bgtotal_out,'string',bgtotal);
                clear bgtotal;
            else
                set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
                set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
                set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
            end

            if ~isempty(STD(A.DC).sigwindow)
                set(SCP.handles.h_currentSTD_sigfrom_out,'string',STD(A.DC).sigwindow(1));
                set(SCP.handles.h_currentSTD_sigto_out,'string',STD(A.DC).sigwindow(2));
                sigtotal = STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1);
                set(SCP.handles.h_currentSTD_sigtotal_out,'string',sigtotal);
                clear sigtotal;
            else
                set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
                set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
                set(SCP.handles.h_currentUNK_sigtotal_out,'string',[]);
            end

        else
            set(SCP.handles.h_currentSTD_filename_out,'string',[]);
            set(SCP.handles.h_currentSTD_SRM_out,'visible','off');
            set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');
            set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_driftcolon,'Visible','off');
            set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigtotal_out,'string',[]);
        end

    elseif strcmp(currentobj,'SCP.handles.h_unk_delete_button') == 1

        if A.KC > 0

            set(SCP.handles.h_currentUNK_filename_out,'string',UNK(A.KC).fileinfo.name);
            %             set(SCP.handles.h_currentUNK_driftpoints_popup,'value',UNK(A.KC).timepoint);
            %             set(SCP.handles.h_currentUNK_drifthh_edit,'string',UNK(A.KC).hh);
            %             set(SCP.handles.h_currentUNK_driftmm_edit,'string',UNK(A.KC).mm);

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
                set(SCP.handles.h_currentUNK_sigtotal_out,'string',[]);
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
                c = UNK(A.KC).comp3window(2)-UNK(A.KC).comp3window(1);
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
            %             set(SCP.handles.h_currentUNK_driftpoints_popup,'Visible','off');
            %             set(SCP.handles.h_currentUNK_drifthh_edit,'Visible','off');
            %             set(SCP.handles.h_currentUNK_driftcolon,'Visible','off');
            %             set(SCP.handles.h_currentUNK_driftmm_edit,'Visible','off');
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

    elseif strcmp(currentobj,'SCP.handles.h_currentUNK_popup') == 1

        A.KC = get(SCP.handles.h_currentUNK_popup,'value');

        if A.KC > 0

            set(SCP.handles.h_currentUNK_filename_out,'string',UNK(A.KC).fileinfo.name);
            %             set(SCP.handles.h_currentUNK_driftpoints_popup,'value',UNK(A.KC).timepoint);
            %             set(SCP.handles.h_currentUNK_drifthh_edit,'string',UNK(A.KC).hh);
            %             set(SCP.handles.h_currentUNK_driftmm_edit,'string',UNK(A.KC).mm);


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

    else % i.e. an old project was just loaded;
        if A.DC > 0
            A.MC = STD(A.DC).SRM;
            set(SCP.handles.h_currentSTD_SRM_out,'visible','on','value',A.MC);
            set(SCP.handles.h_currentSTD_filename_out,'string',STD(A.DC).fileinfo.name);
            set(SCP.handles.h_currentSTD_driftpoints_popup,'value',STD(A.DC).timepoint);
            set(SCP.handles.h_currentSTD_drifthh_edit,'string',STD(A.DC).hh);
            set(SCP.handles.h_currentSTD_driftmm_edit,'string',STD(A.DC).mm);
            if strcmp(A.timeformat,'integer_points')==1;
                set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','on');
                set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','off');
                set(SCP.handles.h_currentSTD_driftcolon,'Visible','off');
                set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','off');
            else
                set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');
                set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','on');
                set(SCP.handles.h_currentSTD_driftcolon,'Visible','on');
                set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','on');
            end

            if ~isempty(STD(A.DC).bgwindow)
                set(SCP.handles.h_currentSTD_bgfrom_out,'string',STD(A.DC).bgwindow(1));
                set(SCP.handles.h_currentSTD_bgto_out,'string',STD(A.DC).bgwindow(2));
                bgtotal = STD(A.DC).bgwindow(2) - STD(A.DC).bgwindow(1);
                set(SCP.handles.h_currentSTD_bgtotal_out,'string',bgtotal);
                clear bgtotal;
            else
                set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
                set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
                set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
            end

            if ~isempty(STD(A.DC).sigwindow)
                set(SCP.handles.h_currentSTD_sigfrom_out,'string',STD(A.DC).sigwindow(1));
                set(SCP.handles.h_currentSTD_sigto_out,'string',STD(A.DC).sigwindow(2));
                sigtotal = STD(A.DC).sigwindow(2)-STD(A.DC).sigwindow(1);
                set(SCP.handles.h_currentSTD_sigtotal_out,'string',sigtotal);
                clear sigtotal;
            else
                set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
                set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
                set(SCP.handles.h_currentUNK_sigtotal_out,'string',[]);
            end

        else
            set(SCP.handles.h_currentSTD_filename_out,'string',[]);
            set(SCP.handles.h_currentSTD_SRM_out,'visible','off');
            set(SCP.handles.h_currentSTD_driftpoints_popup,'Visible','off');
            set(SCP.handles.h_currentSTD_drifthh_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_driftcolon,'Visible','off');
            set(SCP.handles.h_currentSTD_driftmm_edit,'Visible','off');
            set(SCP.handles.h_currentSTD_bgfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgto_out,'string',[]);
            set(SCP.handles.h_currentSTD_bgtotal_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigfrom_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigto_out,'string',[]);
            set(SCP.handles.h_currentSTD_sigtotal_out,'string',[]);
        end

        if A.KC > 0

            set(SCP.handles.h_currentUNK_filename_out,'string',UNK(A.KC).fileinfo.name);
            %             set(SCP.handles.h_currentUNK_driftpoints_popup,'value',UNK(A.KC).timepoint);
            %             set(SCP.handles.h_currentUNK_drifthh_edit,'string',UNK(A.KC).hh);
            %             set(SCP.handles.h_currentUNK_driftmm_edit,'string',UNK(A.KC).mm);


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
    end
end

clear currentfig currentobj tags sigtotal delcall delquery
