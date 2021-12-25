function value = evaluateTree(tree, x_test)

node = tree;
curr = node;
value = [];
for i=1:length(x_test)
    tested = x_test(i);
    curr = node;
    while(~isempty(curr.kids))
        if(tested < curr.threshold)
            curr = curr.kids{1};
        else if(length(curr.kids) == 1)
               curr = curr.kids{1};
        else
            curr = curr.kids{2};
        end
        end
    end

    value(i) = curr.prediction;
    end
end
