function cross_validation = classificationCrossValidation(feature,label,k)

X = feature;
y = label;
k = k;
% i=2;
length_of_fold = floor(length(X)/k);

precision = [];
recall = [];
f1 = [];
for i = 1:k
    x_test = X((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold , :);
    y_test = y((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold);

    x_train = X;
    x_train((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold , :) = [];
    y_train = y;
    y_train((k-i)*length_of_fold+1 : (k-i+1)*length_of_fold) = [];

    tree = classificationTree(x_train,y_train,0,[]);
    drawDecisionTree(tree,"Classification Tree (ID3 Algorithm) Fold-"+ string(i)); hold on;
    y_pred = predict(tree,x_test);

    true_positive = 0;
    false_positive = 0; 
    true_negative = 0;
    false_negative = 0;

    for j = 1:length(y_pred)
        if and(y_pred(j) == 1 , y_pred(j) == y_test(j))
            true_positive = true_positive + 1;
        elseif and(y_pred(j) == 1 , not(y_pred(j) == y_test(j)))
            false_positive = false_positive + 1;
        elseif and(y_pred(j) == 0 , y_pred(j) == y_test(j))
            true_negative = true_negative + 1;
        else 
            false_negative = false_negative + 1;
        end
    end

    precision_curr = true_positive/(true_positive+false_positive);
    recall_curr = true_positive/(true_positive+false_negative);
    f1_curr = true_positive/(true_positive+(false_positive+false_negative)/2);

    precision = [precision , precision_curr];
    recall = [recall , recall_curr];
    f1 = [f1 , f1_curr];

    


averageF1 = sum(f1)/length(f1);
averagePrecision = sum(precision)/length(precision);
averageRecall = sum(recall)/length(recall);

end
disp("---- 10-fold cross-validation classification decision tree (ID3) summary ---")
disp("Average f1 score: " + averageF1)
disp("Average precision score: " + averagePrecision)
disp("Average recall score: " + averageRecall)
disp("------------------------------ end of summary ------------------------------")