%{
ghgjhjhgjh
hjhkhj
hkjhkjhkj
%}
% Create data for use in the examples that follow:
%     values = {1, 2, 3 ; 4, 5, 'x' ; 7, 8, 9};
%     headers = {'First', 'Second', 'Third'};
%     xlswrite('myExample.xls', [headers; values]);
%     moreValues = rand(5);
%     xlswrite('myExample.xls', moreValues, 'MySheet');
%  
%     % Read data from the first worksheet into a numeric array:
%     A = xlsread('myExample.xls')
%  
%     % Read a specific range of data:
%     subsetA = xlsread('myExample.xls', 1, 'B2:C3')
%  
%     % Read from a named worksheet:
%     B = xlsread('myExample.xls', 'MySheet')
%  
%     % Request the numeric data, text, and a copy of the unprocessed (raw)
%     % data from the first worksheet:
%     [ndata, text, alldata] = xlsread('myExample.xls')

new_e = Tstrain1 - Tstress1*(1/12000 - 1/78000);
plot(new_e,Tstress1)
hold on
plot(Tstrain1,Tstress1)
plot(new_e,Tstress1)
hold on
plot(Tstrain1,Tstress1)