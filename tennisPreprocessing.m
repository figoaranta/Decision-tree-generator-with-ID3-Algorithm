close all;
clear;
clc;

%% Categorial -> Numerical and CSV -> mat
% T = readtable('tennis.csv','HeaderLines',0,'ReadVariableNames',true);
% cellTable = T{:,:};
% dataset = [];
% 
% for i=1:size(cellTable,2)
%     cellColumn = (cellTable(:,i));
%     numCellColumn = grp2idx(cellColumn);
%     dataset = [dataset,numCellColumn];
% end
% 
% X = dataset(:,1:4);
% y = dataset(:,5);
% y = y - 1;
% 
% save("tennis.mat","X","y");

%% Loading cleaned data
load("tennis.mat");
% load("mapped_name_gender_dataset.mat");
% X = final_x_train;
% y = final_y_train;
% entropy(X,y);
% newData = [];
% dataset = [X,y];
% subDataset = dataset(dataset(:,1) == 2,:);
% newData = [dataset(dataset(:,1) == 2,:); dataset(dataset(:,1) == 2,:);dataset(dataset(:,1) == 3,:)]

% X = newData(:,1:4);
% y = newData(:,5);

% tree = id3(X,y,0,[]);
% drawDecisionTree(tree,"ID3");

Cross_val(X,y,2);


