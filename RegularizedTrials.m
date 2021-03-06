function [RT] = RegularizedTrials(TSE_A,TSE_B)
% 
% Regularize Trial Lengths
%
%   This script takes the user generate input of start and end times for
% for trials, but expects them to generate trials of different lengths, 
% due to variability in rat running behavior. The output then, accordin to
% user-configured options, is to adjust the length of the trial to a
% standard length.
%
% INPUTS:
%
% TSE_A & TSE_B: matrices of start and end times for each trial (Trials X 
%       2) for all trials of a given type (left or right, correct or 
%       incorrect, etc.)
%
%
% OUTPUTS:
% 
% RT: Structure array with structure elements corrosponding to input 1 and
%       2, and contents of a matrix of adjusted start and end time for each
%       trial (i.e. RT.A and RT.B each containing N X 2 matrices).

for i = 1:length(TSE_A)
    dif_A(i,1) = TSE_A(i,2) - TSE_A(i,1);
    dif_B(i,1) = TSE_B(i,2) - TSE_B(i,1);
end

for i = 1:length(dif_A)
    search(i,1) = min(dif_A);
    search(i,2) = min(dif_B);
    Shortest = min(min(search));
end
clear search dif_A dif_B
for i = 1:length(TSE_A)
    RT_A(i,1) = TSE_A(i,2) - Shortest;
    RT_A(i,2) = TSE_A(i,2);
    RT_B(i,1) = TSE_B(i,2) - Shortest;
    RT_B(i,2) = TSE_B(i,2);
end
clear Shortest
for i = 1:size(RT_A,1)
    for j = 1:size(RT_A,2);
        RT.Left(i,j) = RT_A(i,j);
        RT.Right(i,j) = RT_B(i,j);
    end
end
clear i j RT_A RT_B

end

