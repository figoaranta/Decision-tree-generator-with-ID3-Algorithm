clc;
clear;
close all;
addpath(genpath('Regression'));
addpath(genpath('Classification'));
addpath(genpath('Datasets'));

load("mapped_name_gender_dataset.mat"); %load classification dataset
load("Datasets/pearson_air_quality.mat");
% args:
%   treeLabel           - binary label to indicate which tree to call(1 - classification | 0 - regression)
%   fold                - number of fold in cross validation

%% Call decision tree
c_treeLabel = 1;
r_treeLabel = 0;


% Call Classification Tree
shuffle = randperm(size(final_x_train, 1))';
classificationX = final_x_train(shuffle,:);
classificationY = final_y_train(shuffle);
ClassificationTree = decisionTree(classificationX,classificationY,c_treeLabel);
drawDecisionTree(ClassificationTree,"Classification Tree (ID3 Algorithm)");

% Call Regression Tree
regressionX = X(1:1000,:);
regressionY = y(1:1000);
regressionTree = decisionTree(regressionX,regressionY,r_treeLabel);
drawDecisionTree(regressionTree,"Regression Tree");
%% Cross Validation
fold = 10;

% Classification 10-fold Cross-Validation
classificationCrossValidation(classificationX,classificationY,fold);

% Regression 10-fold Cross-Validation
regressionCrossValidation(regressionX,regressionY,fold);


