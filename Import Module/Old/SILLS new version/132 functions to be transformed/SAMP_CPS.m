%SAMP_CPS

%This script calculates the count rates in the mixed signal region that we 
%can attribute directly to the sample. In the first case, if there is no
%matrix correction, it is simple: we simple subtract the background count
%rates. In the second case, if there is a matrix-only tracer, we can
%subtract the contribution of the matrix and the background from the mixed
%signal

%1st CASE: No Matrix Correction
if UNK(c).MAT_corrtype == 1

    %subtract the background count rate from the mixed signal count rate
    UNK(c).samp_cps = UNK(c).sig_cps - UNK(c).bg_cps;

%2nd CASE: Matrix-only Tracer     
elseif UNK(c).MAT_corrtype ~=1 && UNK(c).SIG_constraint2 == 1

    tracer = UNK(c).SIG_tracer;

    %define the bg-corrected intensity ratio of the tracer in the mixed
    %signal relative to the host signal 
    intensity_ratio = (UNK(c).sig_cps(tracer)-UNK(c).bg_cps(tracer))/(UNK(c).mat_cps(tracer)-UNK(c).bg_cps(tracer));

    %calculate count rates in the mixed region attributable to the host
    host_cps_in_mix = (UNK(c).mat_cps-UNK(c).bg_cps)*intensity_ratio;

    %calculate the count rates in the mixed region attributable to the sample
    UNK(c).samp_cps = UNK(c).sig_cps - host_cps_in_mix - UNK(c).bg_cps;
    
%     a = find(UNK(c).samp_cps < 0);
%     UNK(c).samp_cps(a) = 0;
    
end        

clear tracer intensity_ratio host_cps_in_mix
