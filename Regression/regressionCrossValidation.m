function rmse = regressionCrossValidation(X,y,fold)
    k = fold;
    length_of_fold = floor(length(X)/k);
    rmse_list = zeros(1,k);
    tic;
    for i=1:k
        x_test = X((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold , :);
        y_test = y((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold);
    
        x_train = X;
        x_train((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold , :) = [];
        y_train = y;
        y_train((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold) = [];
        
        decision_tree = RegressionTree(x_train,y_train); 
        DrawDecisionTree(decision_tree, "Tree");


        value = evaluateTree(decision_tree, x_test);
        rmse_regression_tree = sqrt(mean((y_test - value).^2));
        rmse_regression_tree = rmmissing(rmse_regression_tree);
        avg_rmse_regression_tree = sum(rmse_regression_tree)/length(rmse_regression_tree);
%         disp(avg_rmse_regression_tree);
                
        rmse_list(i) = avg_rmse_regression_tree;
        
    end

    final_average_rmse = sum(rmse_list)/length(rmse_list);
    disp("---- 10-fold cross-validation regression decision tree summary ---");
    disp("Final average RMSE Score: "+final_average_rmse);
    disp("------------------------------ end of summary ------------------------------");
end

