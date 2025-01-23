function [ EELS_map_range ] = plotEELSrangemap( x_axis,EELS_map,map_range)
%Plot the 2D map from a select EELS energy range
%   此处显示详细说明
[map_row,map_list,~] = size(EELS_map);
map_channel = find(x_axis >= map_range(1) & x_axis <= map_range(2));
EELS_map_range = zeros(map_row,map_list);
%%EELS_map_range_ls = zeros(map_row);
for row_temp = 1:map_row
    for list_temp = 1:map_list
        for channel_temp = map_channel(1):map_channel(end)
            EELS_map_range(row_temp,list_temp) = EELS_map_range(row_temp,list_temp) + EELS_map(row_temp,list_temp,channel_temp);
        end
        %%EELS_map_range_ls(row_temp) = EELS_map_range_ls(row_temp) + EELS_map_range(row_temp,list_temp);
    end
end
%%DataMap(EELS_map_range,1,map_row,1,map_list,['RAW ',num2str(map_num),' ',num2str(energy_window),' meV'],path);
end

