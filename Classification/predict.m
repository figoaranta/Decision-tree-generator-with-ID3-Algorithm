function predicted_label = predict(tree,feature)

feature = feature;
predicted_label = [];
attributeNames={'outlook','temperature','humidity','windy','play'};

% disp(tree.op)

for i = 1 : length(feature)
    tree_c = tree;
    while tree_c.prediction == 'null'
        index = find(attributeNames==tree_c.op);
        value = feature(i,index);
        if ismember(value,tree_c.branches)
            value_index = find(tree_c.branches==value);
        else
            value_index = 1;
        end
        tree_c = tree_c.kids{value_index};
    end
    predicted_label = [predicted_label ; tree_c.prediction];
end

% disp(predicted_label)