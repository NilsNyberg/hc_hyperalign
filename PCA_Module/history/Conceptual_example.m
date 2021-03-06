% Some notes:

% The concept comes from this following paper Haxby, J. V., Connolly, A.
% C., & Guntupalli, J. S. (2014). Decoding Neural Representational Spaces
% Using Multivariate Pattern Analysis. Annual Review of Neuroscience,
% 37(1), 435?456. http://doi.org/10.1146/annurev-neuro-062012-170325

% This approach makes most sense when we would like to decode the
% data pattern. However, if we do not want to decode behaivoral pattern,
% the multiplication of Neural by Time (Q) matrix with a Behavioral (B)
% matrix is not necessary. 
% 

close all 
clear all 
%load example data
load T_maze_demo.mat pos1 Q1 

% Pos1 is a vector describing where the animial is at each time point.
% Q1 is a vector how each neuron responds at each time point

%% B (Behavioral) matrix --> Time by location maxtrix  T by L
pos1.data; % location data, can be binned data 
pos1.tvec;  % time data, can be bined data 

% pos1.data generate random location
%pos1.data(5001:end) = randi(100,1,5000);

[N,Xedges,Yedges] = histcounts2(pos1.tvec,pos1.data,1:10001,1:11);

B=[];
for it = 1:size(pos1.tvec,2)
    for ic = 1:100
        if pos1.data(it) ==ic
            B(it,ic) = 1;
        else
            B(it,ic) = 0;
        end
    end
end
figure(1);subplot(1,4,1);imagesc(B');
title('Behavioral Matrix: Location by Time')

%% Q matrix --> neuron  by Time  matrix  size(Q1) N by T
Q = Q1(:,1:10000); % 10 by 10000 by one trial; the Q1 matrix has 5 trials
figure(1);subplot(1,4,2);imagesc(Q);
title('Neuron Matrix: Neuronal spike by Time')


%% R matrix --> Q*B  Neuron by location matrix N by L
R = B'*Q';
figure(1);subplot(1,4,3);imagesc(R);
title('Representaitonal Matrix: Neuronal By loction')


%% reduce the factors (neurons) to 3 major components
[reducedR scoreR] = pca(R,'NumComponents',10);

steps=size(scoreR,1)/20;

for i=1:size(scoreR,1)/steps
figure(1);subplot(1,4,4);
plot3(scoreR([1:steps*i-10],1),scoreR([1:steps*i-10],2),scoreR([1:steps*i-10],3),'r.');
axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
hold on; WaitSecs(0.01)
title('Dimension reduction to 3 components: Based on the Q matrix')
end



%% What if we reduce the dimensionality only based on the Q matrix

[reducedR scoreR] = pca(Q','NumComponents',10);

steps=size(scoreR,1)/200;

for i=1:size(scoreR,1)/steps
figure(2);
plot3(scoreR([1:steps*i-10],1),scoreR([1:steps*i-10],2),scoreR([1:steps*i-10],3),'r.');
axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
hold on; WaitSecs(0.01)
title('Dimension reduction to 3 components: Based on the Q matrix')
end





%% 5 trials data

Qtrail{1} = Q1(:,1:10000);
Qtrail{2} = Q1(:,10001:20000);
Qtrail{3} = Q1(:,20001:30000);
Qtrail{4} = Q1(:,30001:40000);
Qtrail{5} = Q1(:,40001:50000);


[coeff1,score1,latent,tsquared,explained,mu1] = pca(Qtrail{1}','NumComponents',10);

% rawQ = score1*coeff1' + repmat(mu1, size(score1,1),1);

rawQ = Qtrail{2}';
reconstruct_score = [rawQ - repmat(mean(rawQ), size(score1,1),1)]/coeff1';




%%
% [reducedR scoreR] = pca(Q','NumComponents',10);
scoreR = reconstruct_score;
steps=size(scoreR,1)/200;

for i=1:size(scoreR,1)/steps
figure(2);hold on; 
plot3(scoreR([1:steps*i-10],1),scoreR([1:steps*i-10],2),scoreR([1:steps*i-10],3));
% axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
hold on; WaitSecs(0.01)
title('Dimension reduction to 3 components: Based on the Q matrix')
end

% goodness of fit 


%% 

minlen = min(get_length(Qhpc_left));

for iq= 1:size(Qhpc_left,2)
    NQleft{iq}.data =Qhpc_left{iq}.data(:,end-minlen+1:end);
end

minlen=min(get_length(Qhpc_right));
for iq= 1:size(Qhpc_right,2)
    NQright{iq}.data =Qhpc_right{iq}.data(:,end-minlen+1:end);
end


%% Plot the data for the left trials. 


    InputMatrix = Qhpc_left;
    NumComponents =30;
    [Egvecs] = pca_egvecs(InputMatrix{1}.data,size(InputMatrix{1}.data,1));
    TransformM = Egvecs(:,1:3); % use the first 3 factor as the transformation matrix
    Ntrial = size(InputMatrix,2);    
    for itr = 1:Ntrial
        reconstruct_score{itr} = pca_project(InputMatrix{itr}.data,TransformM);
    end
    
    


figIn=2;
% for the left trials
for itr = 1:size(reconstruct_score,2)

     scoreR = reconstruct_score{itr};   
     curclr = rand(1,3);
     figure(figIn);subplot(1,3,1);    
     h=plot3(scoreR(:,1),scoreR(:,2),scoreR(:,3),'.-','color',curclr);
     h.Color(4) = 0.01;
     hold on; 
     axis on;
     grid on;title('left trials only')
     axis([-2 2 -2 2 -2 2]);

     
     figure(figIn);subplot(1,3,3);    
     h=plot3(scoreR(:,1),scoreR(:,2),scoreR(:,3),'r.-');
     h.Color(4) = 0.01;
     hold on; 
     axis on;
     grid on; title('left-red, right-blue')
     axis([-2 2 -2 2 -2 2]);

end




    InputMatrix = Qhpc_right;
    NumComponents =30;
%     [Egvecs] = pca_egvecs(InputMatrix{1}.data,size(InputMatrix{1}.data,1));
    TransformM = Egvecs(:,1:3); % use the first 3 factor as the transformation matrix
    Ntrial = size(InputMatrix,2);    
    for itr = 1:Ntrial
        reconstruct_score{itr} = pca_project(InputMatrix{itr}.data,TransformM);
    end
    
% for the right trials
for itr = 1:size(reconstruct_score,2)

     scoreR = reconstruct_score{itr};   
     curclr = rand(1,3);
     figure(figIn);subplot(1,3,2);    
     h=plot3(scoreR(:,1),scoreR(:,2),scoreR(:,3),'.-','color',curclr);
     h.Color(4) = 0.01;
     hold on; 
     axis on;
     grid on;title('right trials only')
     axis([-2 2 -2 2 -2 2]);

     
     figure(figIn);subplot(1,3,3);    
     h=plot3(scoreR(:,1),scoreR(:,2),scoreR(:,3),'b.-');
     h.Color(4) = 0.01;
     hold on; 
     axis on;
     grid on; title('left-red, right-blue') 
     axis([-2 2 -2 2 -2 2]);

end




%%
scoreR = mean(allscore,3);
    for i=1:size(scoreR,1)
        
        figure(4);
        plot3(scoreR([1:steps*i],1),scoreR([1:steps*i],2),scoreR([1:steps*i],3),'.-','color',curclr);
        axis([min(scoreR(:,1)) max(scoreR(:,1)) min(scoreR(:,2)) max(scoreR(:,2)) min(scoreR(:,3)) max(scoreR(:,3))]);
        hold on; 
        WaitSecs(0.001)
        title('Dimension reduction to 3 components: Based on the Q matrix')
        
        axis on;
        grid on;
    end