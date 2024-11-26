function [array_inserted] = insert_pilot(origanl_array, index, insertion_value , row_size)
%index here represtnts which column do you want to insert a pilot at
%the array size here gets bigger by exactly one in row sizes
%row_Size default should be '1' but in case that you need to insert
%multiple rows that are next to each other at some specifc location
pilot_row = insertion_value * ones(row_size,width(origanl_array));

if index == 1
    array_inserted = [pilot_row; origanl_array(index:end,:)];
elseif index == height(origanl_array)
    array_inserted = [origanl_array(1:index-1,:); pilot_row];
else
    array_inserted = [origanl_array(1:index-1,:); pilot_row; origanl_array(index:end,:)];
end