function [ output_args ] = plotEELSls( energy_axis,EELS_map_intensity,plot_range_channel,map_list,map_row,x_label,y_label,f_title )
%plot 2D spectrum in EELS_map
%   此处显示详细说明
figure;
for list_temp = 1:map_list
    for row_temp = 1:map_row
        X = reshape(energy_axis(1,plot_range_channel(1):plot_range_channel(2)),1,[]);
        Y = reshape(EELS_map_intensity(row_temp,list_temp,plot_range_channel(1):plot_range_channel(2)),1,[]);
        color_blue = list_temp/map_list;
        color_red = 1 - color_blue;
        color_green = (row_temp - 1)/map_row;
        colornew = [color_red color_green color_blue];
        plot(X,Y,'color',colornew);
        xlabel( x_label ); ylabel( y_label );
        grid on;hold on
    end
end
title(f_title);


