function [ output_args ] = save3Dto2Dcsv( EELS_map_3D,savepath)
%UNTITLED 此处显示有关此函数的摘要
%   first row is local with role of 'list - row'.
[map_row,map_list,channel_num] = size(EELS_map_3D);
EELS_map_2D = NaN(map_row * map_list,channel_num + 1);%%x-list;y-row
count = 1;
for row_temp = 1:map_row
    for list_temp = 1:map_list
        EELS_map_2D(count,1) = list_temp*100 + row_temp;%%['x',num2str(list_temp,'%02d'),'y',num2str(row_temp,'%02d')];
        EELS_map_2D(count,2:channel_num + 1) = EELS_map_3D(row_temp,list_temp,:);
        count = count + 1;
    end
end
csvwrite(savepath,EELS_map_2D');
end

