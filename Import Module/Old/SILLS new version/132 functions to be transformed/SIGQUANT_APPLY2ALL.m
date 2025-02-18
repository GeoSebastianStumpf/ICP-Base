%SIGQUANT_APPLY2ALL

%summoned when an 'Apply to All' button is clicked from within the Signal
%Quantification figure

A.KC = get(gcf,'UserData');

%determine which 'Apply to All' button was selected
tag = get(gco,'tag');

if strcmp(tag,'SIG1') == 1
    for c = 1:A.UNK_num;

%        if UNK(A.KC).sigtotal > 0
            UNK(c).SIG_constraint1 = UNK(A.KC).SIG_constraint1;
            UNK(c).SIGQIS1 = UNK(A.KC).SIGQIS1;
            UNK(c).SIGQIS1iso = UNK(A.KC).SIGQIS1iso;
            UNK(c).SIGQIS1_conc = UNK(A.KC).SIGQIS1_conc;
            if A.Oxide_test ~= 0
                UNK(c).SIGQIS1ox = UNK(A.KC).SIGQIS1ox;
                UNK(c).SIGQIS1_concwt = UNK(A.KC).SIGQIS1_concwt;
                UNK(c).SIG_oxide_total = UNK(A.KC).SIG_oxide_total;
            end            
            if A.Na_test ~= 0
                UNK(c).SIGsalinity = UNK(A.KC).SIGsalinity;
                UNK(c).SALT = UNK(A.KC).SALT;
                UNK(c).SALT_mass_balance_factor = UNK(A.KC).SALT_mass_balance_factor;
            end
            if A.Fe_test ~= 0
                UNK(c).SIG_Fe_ratio = UNK(A.KC).SIG_Fe_ratio;
            end
            UNK(c).SIG1unit = UNK(A.KC).SIG1unit;
            a = c; %variable that is passed to SIGINTSTD
            SIGSET; %in order to update the CALCULATION MANAGER
 %       end
    end

elseif strcmp(tag,'SIG2') == 1

    for c = 1:A.UNK_num;

  %      if UNK(A.KC).sigtotal > 0
            UNK(c).SIG_tracer = UNK(A.KC).SIG_tracer;
            UNK(c).SIG_constraint2 = UNK(A.KC).SIG_constraint2;
            UNK(c).SIGQIS2 = UNK(A.KC).SIGQIS2;
            UNK(c).SIGQIS2iso = UNK(A.KC).SIGQIS2iso;
            UNK(c).SIGQIS2_conc = UNK(A.KC).SIGQIS2_conc;
            if A.Oxide_test ~= 0
                UNK(c).SIGQIS2ox = UNK(A.KC).SIGQIS2ox;
                UNK(c).SIGQIS2_concwt = UNK(A.KC).SIGQIS2_concwt;
            end
            UNK(c).SIG2unit = UNK(A.KC).SIG2unit;
   %     end
    end
end
