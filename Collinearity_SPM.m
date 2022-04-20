% Written by Benedetta Cecconi

load('Onsets_Roving.mat')
load('Onsets_Classic.mat')

%then you need to load the efficiency values for both conditions that you
%generated with the script "Efficiency_Analysis.m". Here, as an example, I
%used the eff values for the 3rd contrast (std-dev): "eff_diff_roving"

%% find min Roving 
[min_R,x] = find(eff_diff_roving == min(eff_diff_roving));
onset_std_R_min = onset_std_roving{1,min_R};
onset_dev_R_min = onset_dev_roving{1,min_R};

%% find max Roving
[max_R,x] = find(eff_diff_roving == max(eff_diff_roving));
onset_std_R_max = onset_std_roving{1,max_R};
onset_dev_R_max = onset_dev_roving{1,max_R};

%% find median Roving 
med_position = floor(numel(eff_diff_roving)/2);
[~,ord_R] = sort(eff_diff_roving);
[med_R] = ord_R(med_position : med_position+1);

onset_std_roving_med = onset_std_roving{1,med_R};
onset_dev_roving_med = onset_dev_roving{1,med_R};

%% Same procedure for the Classic
%....

