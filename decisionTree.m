function [tree] = decisionTree(X,y,label)
    addpath(genpath('Classification'));
    addpath(genpath('Regression'));
    if label == 1
        tree = classificationTree(X,y,0,[]);
    else
        tree = RegressionTree(X,y);
    end
    
end

