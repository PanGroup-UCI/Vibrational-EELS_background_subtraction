%% 0-basic setting
clear variables;clc;clf;close all;

path_root = 'C:\Users\yanxi\Documents\MATLAB\Github_Repositories\Vibrational_EELS_background_subtraction';
path = [path_root,'\'];
filename_EELS = 'Example_BTO_deleted.dm4';%%remember to change it everytime

dispersion = 0.5;%%meV/channel
save_number = 0;

% for binning the data and different fitting models
bin = [2,2]; % [1,1] for no binning (Y,X)

% fitting paramters
fit_seg_num = 3; %energy_range_segment_number: 2, 3, or 4
fit_range_energy = [8.5, 9, 72, 78, 105, 120, 230, 240]; % BTO or STO
fit_model = 'power0'; %options: 'power','exppoly','power0' w/o offset
coeff_start = [3e-2 1.8 -2e-3];%% based on 0.1eV, meV and hundredth
energy_factor = 30; %meV
Upper_bound = [0.1, 5, 0.1];
Lower_bound = -Upper_bound;

path_output = [path_root, '\0_output', num2str(bin), '_', fit_model,'\']; mkdir(path_output);

% for map channel
plot_energy_range = [10,100];
window_first_start = 10;
window_width = 10; %%meV
range_num = 10;

%% 1. load data
EELS_map_raw_DM = ReadDMFile([path,filename_EELS]);
[map_list, map_row, channel_max] = size(EELS_map_raw_DM);

%transpose
EELS_map_raw = NaN(map_row,map_list,channel_max);
for list_temp = 1:map_list
    for row_temp = 1:map_row
        EELS_map_raw(row_temp,list_temp,:) = EELS_map_raw_DM(list_temp,row_temp,:);
    end
end

%save data to csv
save_number = save_number+1;
savepath_raw = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','raw','.csv'];
save3Dto2Dcsv(EELS_map_raw,savepath_raw);

%% 2. align ZLP
[~,ZLP_location] = max(EELS_map_raw,[],3);%find ZLP location
ZLP_location_min = min(min(ZLP_location));
EELS_map_raw_align = NaN(map_row,map_list,channel_max);
for list_temp = 1:map_list
    for row_temp = 1:map_row
        channel_zero_shift = ZLP_location(row_temp,list_temp) - ZLP_location_min;
        for channel_temp = 1:channel_max - channel_zero_shift %% drag all the peaks to the same position
            EELS_map_raw_align(row_temp,list_temp,channel_temp) = EELS_map_raw(row_temp,list_temp,channel_temp + channel_zero_shift);
        end
    end
end

save_number = save_number+1;
savepath_raw_align = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','raw_align','.csv'];
save3Dto2Dcsv(EELS_map_raw_align,savepath_raw_align);
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','raw_align','.mat'],'EELS_map_raw_align');

% 2.1. establish x axis
energy_axis = NaN(1,channel_max);
for channel_temp = 1:channel_max
    energy_axis(1,channel_temp) = dispersion * (channel_temp - ZLP_location_min);
end
save_number = save_number+1;
csvwrite([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','energy_axis','.csv'],energy_axis');
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','energy_axis','.mat'],'energy_axis');

% plot all spectra for linescan
plot_channel_range = floor(plot_energy_range/dispersion) + ZLP_location_min;
x_label = 'Energy Loss (meV)';
y_label = 'Raw Intensity (a.u.)';
f_title = 'Raw Spectrum';
plotEELSls(energy_axis,EELS_map_raw_align,plot_channel_range,map_list,map_row,x_label,y_label,f_title);
saveas(gcf,[path_output,filename_EELS,'_','raw_align','.jpg'],'jpg');

% 2.3. binning data
map_row_bin = map_row - bin(1) + 1;
map_list_bin = map_list - bin(2) + 1;
EELS_map_raw_align_bin = zeros(map_row_bin,map_list_bin,channel_max);
for list_bin_temp = 1:map_list_bin
    for row_bin_temp = 1:map_row_bin
        for list_subreg_temp = 1:bin(2)
            for row_subreg_temp = 1:bin(1)
                list_temp = list_subreg_temp + list_bin_temp - 1;
                row_temp = row_subreg_temp + row_bin_temp - 1;
                EELS_map_raw_align_bin(row_bin_temp,list_bin_temp,:) = EELS_map_raw_align_bin(row_bin_temp,list_bin_temp,:)...
                    + EELS_map_raw_align(row_temp,list_temp,:);
            end
        end
    end
end

savepath_raw_align_bin = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','raw_align_bin_',num2str(bin),'.csv'];
save3Dto2Dcsv(EELS_map_raw_align_bin,savepath_raw_align_bin);
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','raw_align_bin_',num2str(bin),'.mat'],'EELS_map_raw_align_bin');

% update raw_align with raw_align_bin
EELS_map_raw_align = EELS_map_raw_align_bin;
[map_row, map_list, channel_max] = size(EELS_map_raw_align);
[ZLP_intensity,ZLP_location] = max(EELS_map_raw_align,[],3);%find ZLP location

%% 3. normalized by ZLP
EELS_map_nor = zeros(map_row,map_list,channel_max);
for row_temp = 1:map_row
    for list_temp = 1:map_list
        EELS_map_nor(row_temp,list_temp,:) = EELS_map_raw_align(row_temp,list_temp,:)/ZLP_intensity(row_temp,list_temp);
    end
end
save_number = save_number+1;
savepath_nor = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor','.csv'];
save3Dto2Dcsv(EELS_map_nor,savepath_nor);
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor','.mat'],'EELS_map_nor');

% plot all normalized spectra for linescan
x_label = 'Energy Loss (meV)';
y_label = 'Normalized Intensity (ZLP=1)';
f_title = 'Normalized Spectrum';
plotEELSls(energy_axis,EELS_map_nor,plot_channel_range,map_list,map_row,x_label,y_label,f_title);
saveas(gcf,[path_output,filename_EELS,'_','nor','.jpg'],'jpg');

%% 4. fitting background
fit_range_channel = [];
fit_range_channel_temp = [];
for seg_temp = 1:fit_seg_num
    fit_range_channel = [fit_range_channel_temp find(energy_axis >= fit_range_energy(2*seg_temp - 1) & energy_axis <= fit_range_energy(2*seg_temp))];
    fit_range_channel_temp = fit_range_channel;
end
clear fit_range_channel_temp;

% fitting and save output
energy_fit = energy_axis(fit_range_channel);
EELS_map_nor_fit = EELS_map_nor(:,:,fit_range_channel);
energy_fit_hundredth = energy_fit/energy_factor;
spectra_fit_coeff = NaN(map_row,map_list,2*numel(coeff_start));%%5 factors with value and error/ will be changed

% compute fitted background
energy_part = energy_axis(fit_range_channel(1):fit_range_channel(end));
save_number = save_number+1;
csvwrite([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','energy_axis_part','.csv'],energy_part');
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','energy_axis_part','.mat'],'energy_part');

channel_part_total = fit_range_channel(end) - fit_range_channel(1) + 1;
EELS_map_nor_part = EELS_map_nor(:,:,fit_range_channel(1):fit_range_channel(end));
energy_part_hundredth = energy_part/energy_factor;
EELS_map_nor_part_BKG = NaN(map_row,map_list,channel_part_total);

for row_temp = 1:map_row
    for list_temp = 1:map_list
        location = [row_temp,list_temp];
        x_data = reshape(energy_fit_hundredth,1,[]);
        y_data = reshape(EELS_map_nor_fit(row_temp,list_temp,:),1,[]);
        if strcmp(fit_model, 'power')
            fitresult = FitBKGpower(x_data,y_data,Upper_bound,Lower_bound,coeff_start);
        elseif strcmp(fit_model, 'power0')
            fitresult = FitBKGpower0(x_data,y_data,Upper_bound,Lower_bound,coeff_start);
        elseif strcmp(fit_model, 'exppoly')
            fitresult = FitBKGexppoly(x_data,y_data,Upper_bound,Lower_bound,coeff_start);
        elseif strcmp(fit_model, 'pVoigt')
            fitresult = FitBKGpVoigt(x_data,y_data,Upper_bound,Lower_bound,coeff_start);
        else disp('wrong fit_model'); return
        end
        x_data_part = reshape(energy_part_hundredth,1,[]);
        y_fit = fitresult(x_data_part)';
        EELS_map_nor_part_BKG(row_temp,list_temp,:) = y_fit;
        
        coef_values = coeffvalues(fitresult);
        coef_error = (max(confint(fitresult,0.95)) - min(confint(fitresult,0.95)))/2;
        spectra_fit_coeff(row_temp,list_temp,:) = reshape([coef_values;coef_error],1,[]);
    end
end
save_number = save_number + 1;
savepath_fit_output = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','fit_output','.csv'];
save3Dto2Dcsv(spectra_fit_coeff,savepath_fit_output);

x_label = 'Energy Loss (meV)';
y_label = 'Normalized Intensity (ZLP=1)';
f_title = 'Part background';
plotEELSls(energy_part,EELS_map_nor_part_BKG,[1,channel_part_total],map_list,map_row,x_label,y_label,f_title);
saveas(gcf,[path_output,filename_EELS,'_','part_BKG','.jpg'],'jpg');

save_number = save_number + 1;
savepath_nor_BKG = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor_BKG','.csv'];
save3Dto2Dcsv(EELS_map_nor_part_BKG,savepath_nor_BKG);

EELS_map_nor_part_sub = EELS_map_nor_part - EELS_map_nor_part_BKG;
x_label = 'Energy Loss (meV)';
y_label = 'Normalized Intensity (ZLP=1)';
f_title = 'Signal';
plotEELSls(energy_part,EELS_map_nor_part_sub,[1,channel_part_total],map_list,map_row,x_label,y_label,f_title);
saveas(gcf,[path_output,filename_EELS,'_','part_sub','.jpg'],'jpg');
save_number = save_number + 1;
savepath_nor_sub = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor_sub','.csv'];
save3Dto2Dcsv(EELS_map_nor_part_sub,savepath_nor_sub);
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor_sub','.mat'],'EELS_map_nor_part_sub');

%% 5. range map
EELS_map_nor_part_sub_range = NaN(map_row,map_list,range_num);
for range_num_temp = 1:range_num
    map_range_energy = [window_first_start + window_width*(range_num_temp - 1),window_first_start + window_width*range_num_temp];
    EELS_map_nor_part_sub_range(:,:,range_num_temp) = plotEELSrangemap(energy_part,EELS_map_nor_part_sub,map_range_energy);
    figure;
    imagesc(EELS_map_nor_part_sub_range(:,:,range_num_temp));
    axis equal;colorbar;
    ylim([0.5 map_row+0.5]); xlim([0.5 map_list+0.5]);
    set(gca,'TickDir','out');
    title([num2str(map_range_energy),' meV range normalized']);
    saveas(gcf,[path_output,filename_EELS,'_','sub_nor_range_',num2str(map_range_energy),' meV','.jpg'],'jpg');
end
save_number = save_number + 1;
savepath_EELS_map_nor_part_sub_range = [path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor_sub_range','.csv'];
%%csvwrite(savepath_EELS_map_nor_part_sub_range,EELS_map_nor_part_sub_range');
save3Dto2Dcsv(EELS_map_nor_part_sub_range,savepath_EELS_map_nor_part_sub_range);
save([path_output,filename_EELS,'_',num2str(save_number,'%02d'),'_','nor_sub_range','.mat'],'EELS_map_nor_part_sub_range');
%%close all;