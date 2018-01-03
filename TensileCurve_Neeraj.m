%% Program to correct the machine slack during tensile test

%{
To use this program first create two column vectors :
Tstrain and Tstress. This can be done either using import functionality of
matlab or 
1) create a new variable from the matlab toolbar icon 'New Variable'.
2) Copy the respective columns from excel and paste that in the matrix for
the new variables Tstress and Tstrain.

Now run the program. It will create a New data matrix in the current folder
with strain and stress columns with updated values. These can be used to
plot in origin, excel or matlab (code commented at the end).

Please crosscheck the slope_test value i.e. the slope of the test data in
the elastic region. If it is not 12000 MPa then change the value of the
constant below appropriately.
%}
Slope_test = 12000;
Slope_Material = 78000;

new_e = Tstrain - Tstress*(1/Slope_test - 1/Slope_Material);
Heading = {'True_Strain', 'True_Stress'};
Corrected_Data = [new_e, Tstress];
xlswrite('New_Data.xlsx', Heading,'A1:B1'); %writes the header for columns
xlswrite('New_Data.xlsx', Corrected_Data,'A2:B1308');% 1308 is the number of rows in the input data file, cross check it.

%%
% %For plotting both results
% plot(new_e,Tstress)
% hold on
% plot(Tstrain,Tstress)
% hold off
%%