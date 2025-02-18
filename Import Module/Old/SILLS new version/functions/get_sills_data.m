function [SMAN,STD,UNK, A, SRM] = get_sills_data

SMAN = struct('h_SMAN',[],'headers',[],'handles',[],'figure_state','shut');

%Set up STD structure array (contains all information about the calibration standards)
STD = struct('data',[],'textdata',[],'colheaders',[],'fileinfo',[],'num_elements',[],...
            'SRM',[],'bgwindow',[],'sigwindow',[],'order_opened',[],...
            'figure_state',[],'timepoint',[],'XLim_orig',[],'YLim_orig',[],'YLim_orig_element',[],'handles',[],...
            'incrmt',[],'lines',[],'hh',[],'mm',[]);

%Set up UNK structure array (contains all information about the analytes
UNK = struct('data',[],'textdata',[],'colheaders',[],'fileinfo',[],'num_elements',[],...
            'internal_standard',[],'bgwindow',[],'mat1window',[],'mat2window',[],'mattotal',[],...
            'comp1window',[],'comp2window',[],'comp3window',[],'sigtotal',[],...
            'XLim_orig',[],'YLim_orig',[],'YLim_orig_element',[],...
            'order_opened',[],'figure_state',[],'timepoint',[],'hh',[],'mm',[],'Info',[],...
            'MAT_corrtype',[],'MATcorrfile',[],'MATcorrfile_index',[],'MATQIS',[],'MATQISiso',[],'MATQISox',[],'MATQIS_conc',[],'MATQIS_concwt',[],'MATunit',1,...
            'MATQIS_conc_error',[],'MAT_oxide_total',[],'MAT_oxide_total_error',[],'MAT_Fe_ratio',[],...
            'SIG_quanttype',[],...
            'SIGQIS1',[],'SIGQIS1iso',[],'SIGQIS1ox',[],...
            'SIGQIS1_conc',[],'SIGQIS1_concwt',[],...
            'SIGQIS1_conc_error',[],'SIG1unit',1,...            
            'SIGQIS2',[],'SIGQIS2iso',[],'SIGQIS2ox',[],...
            'SIGQIS2_conc',[],'SIGQIS2_concwt',[],...
            'SIGQIS2_conc_error',[],'SIG2unit',1,...
            'SIGsalinity',[],'SIGsalinity_error',[],'SALT',[],'SALT_mass_balance_factor',0.5,... %Mass balance factor changed in 1.0.6
            'SIG_oxide_total',[],'SIG_oxide_total_error',[],'SIG_Fe_ratio',[],...
            'SIG_constraint1',[],'SIG_constraint2',[],'SIG_tracer',[],'SIG_traceriso',[]);

% Set up the A structure array (contains all universal variables)
A = struct( 'sillsdir',[],'sillsfile',[],...
            'sillspath',[],'SRM_files',[],'SRM_num',[],...
            'SRM_filenames',[],'userSRMfile',[],'userSRMpathname',[],...
            'SRMcheck',[],'USERSRMFILE',[],'MC',[],...
            'STD_num',[],'d',[],'D',[],'DC',[],...
            'UNK_num',[],'k',[],'K',[],'KC',[],...
            'input_type','cps',...
            'timeformat','hhmm','timepoints',1,'flickernoise',0,...
            'flickDT',0.010,'ISOTOPE_list',[],'ISOTOPE_num',[],...
            'CALC_MANAGER_open',0,'SIGQUANT_open',0,'SIGSALT_open',0,...
            'Oxide_test',0,'Oxides',[],'DT_VALUES',[],...
            'UNK_with_matrix',[],'UNK_with_matrix_index',[],...
            'UNK_with_matrix_num',0,'REFIS','','REFIS_list_index',1,...
            'REPORTIS','','REPORTIS_list_index',1,'STD_TIMES',[],...
            'UNK_TIMES',[],'DRIFT_regression',[],'CALIB',[],...
            'report_settings_oxide','off','report_settings_population','off',...
            'CALIBPLOT_open',0,'CAL_xisotope',1,'CAL_yisotope',1,...
            'dummy',0.1,'LODff',3,'cpsonly',0,'LODmethod','Pettke'); %changed in 1.0.2 (Added dummy and LODff value) and 1.0.3; Added LODmethod in 1.3.2
        
A.STDPOPUPLIST = {}; %Added in 1.1.0
A.UNKPOPUPLIST = {}; %Added in 1.1.0
A.ratios.num = 0; %Added in 1.0.4
A.ratios.index = []; %Added in 1.0.4
A.ratios.show = []; %Added in 1.0.4
A.ratios.names = {}; %Added in 1.0.4

%define a matrix containing the common rock-forming oxides

A.Oxides = {'Si' 'SiO2';
           'Ti' 'TiO2';
           'Al' 'Al2O3';
           'Fe' 'Fe2O3';
           'Fe' 'FeO';
           'Mn' 'MnO';
           'Mg' 'MgO';
           'Ca' 'CaO';
           'Na' 'Na2O';
           'K' 'K2O';
           'P' 'P2O5'};

A.Oxides_mol_wts = [28.09 60.09 1;
           47.87 79.90 1;
           26.98 101.96 2;
           55.85 159.69 2;
           55.85 71.85 1;
           54.94 70.94 1;
           24.30 40.31 1;
           40.08 56.08 1;
           22.99 61.98 2;
           39.10 94.20 2;
           30.97 141.95 2];
      
%define a matrix containing chlorides

A.Chlorides = {'Li' 'LiCl';
    'Be' 'BeCl2';
    'B' 'BCl3';
    'Na' 'NaCl';
    'Mg' 'MgCl2';
    'Al' 'AlCl3';
    'Si' 'SiCl4';
    'P' 'PCl5';
    'K' 'KCl';
    'Ca' 'CaCl2';
    'Sc' 'ScCl3';
    'Ti' 'TiCl4';
    'V' 'VCl4';
    'Cr' 'CrCl3';
    'Mn' 'MnCl2';
    'Fe' 'FeCl2';
    'Co' 'CoCl2';
    'Ni' 'NiCl2';
    'Cu' 'CuCl';
    'Zn' 'ZnCl2';
    'Ga' 'GaCl3';
    'Ge' 'GeCl2';
    'As' 'AsCl3';
    'Rb' 'RbCl';
    'Sr' 'SrCl2';
    'Y' 'YCl3';
    'Zr' 'ZrCl4';
    'Nb' 'NbCl5';
    'Mo' 'MoCl6';
    'Tc' 'TcCl2';
    'Ru' 'RuCl3';
    'Rh' 'RhCl3';
    'Pd' 'PdCl2';
    'Ag' 'AgCl';
    'Cd' 'CdCl2';
    'In' 'InCl3';
    'Sn' 'SnCl2';
    'Sb' 'SbCl3';
    'Cs' 'CsCl';
    'Ba' 'BaCl2';
    'La' 'LaCl3';
    'Ce' 'CeCl3';
    'Pr' 'PrCl3';
    'Nd' 'NdCl3';
    'Pm' 'PmCl3';
    'Sm' 'SmCl3';
    'Eu' 'EuCl3';
    'Gd' 'GdCl2';
    'Tb' 'TbCl3';
    'Dy' 'DyCl3';
    'Ho' 'HoCl3';
    'Er' 'ErCl3';
    'Tm' 'TmCl3';
    'Yb' 'YbCl3';
    'Lu' 'LuCl3';
    'Hf' 'HfCl4';
    'Ta' 'TaCl5';
    'W' 'WCl6';
    'Re' 'ReCl4';
    'Os' 'OsCl4';
    'Ir' 'IrCl4';
    'Pt' 'PtCl4';
    'Au' 'AuCl';
    'Hg' 'HgCl';
    'Tl' 'TlCl';
    'Pb' 'PbCl2';
    'Bi' 'BiCl3';
    'Th' 'ThCl4';
    'U' 'UCl4'};
    
A.Chlorides_mol_wts = [6.94 42.39 1;
    9.01 79.91 2;
    10.81 117.16 3;
    22.99 58.44 1;
    24.3 95.2 2;
    26.98 133.33 3;
    28.09 169.89 4;
    30.97 208.22 5;
    39.1 74.55 1;
    40.08 110.98 2;
    44.96 151.31 3;
    47.87 189.67 4;
    50.94 192.74 4;
    52 158.35 3;
    54.94 125.84 2;
    55.85 126.75 2;
    58.93 129.83 2;
    58.69 129.59 2;
    63.55 99 1;
    65.39 136.29 2;
    69.72 176.07 3;
    72.61 143.51 2;
    74.92 181.27 3;
    85.47 120.92 1;
    87.62 158.52 2;
    88.91 195.26 3;
    91.22 233.02 4;
    92.91 270.16 5;
    95.94 308.64 6;
    98.91 169.81 2;
    101.1 207.45 3;
    102.9 209.25 3;
    106.4 177.3 2;
    107.9 143.35 1;
    112.4 183.3 2;
    114.8 221.15 3;
    118.7 189.6 2;
    121.8 228.15 3;
    132.9 168.35 1;
    137.3 208.2 2;
    138.9 245.25 3;
    140.1 246.45 3;
    140.9 247.25 3;
    144.2 250.55 3;
    146.9 253.25 3;
    150.4 256.75 3;
    152.0 258.35 3;
    157.2 228.1 2;
    158.9 265.25 3;
    162.5 268.85 3;
    164.9 271.25 3;
    167.3 273.65 3;
    168.9 275.25 3;
    173.0 279.35 3;
    175.0 281.35 3;
    178.5 320.3 4;
    180.9 358.15 5;
    183.8 396.5 6;
    186.2 328 4;
    190.2 332 4;
    192.2 334 4;
    195.1 336.9 4;
    197 232.45 1;
    200.6 236.05 1;
    204.4 239.85 1;
    207.2 278.1 2;
    209 315.35 3;
    232 373.8 4;
    238 379.8 4];
    
A.Chlorides_num = size(A.Chlorides);
A.Chlorides_num = A.Chlorides_num(1);
    
           
A.STD_num = 0;
A.d = 0;
A.D = 0;
A.DC = 0;
% Note: A.d is the number of times a standard figure has been opened, irrespective of deletions
%       A.D is the number of open standard figures

A.UNK_num = 0;
A.k = 0;
A.K = 0;
A.KC = 0;
% Note: A.k is the number of times a standard figure has been opened, irrespective of deletions
%       A.K is the number of open standard figures

% workaroung for r2014b and higher introduced graphic updates
% the following specifies the colors for parts of the drift window, i.e.
% representing the default colors of matlab. MW July 2016.
colorset=[
    0         0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
    ];

% %%%%%%%%%% Section 3: read in 3 SRM data: NIS_612, NIST_610, STDGL_2b2 data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % First setup SRM structure array
SRM = struct('data',[],'textdata',[],'rowheaders',[],'fileinfo',[],'name',[]);

%end