function root = CreateTree(name, prediction, threshold, attribute, root)
    if nargin < 5
        root=CreateNode(name, prediction, threshold, attribute);
        return
    else
        if ~isstruct(root)
            root=CreateNode(name, prediction, threshold, attribute);
            return
        end
    end
    
    if isempty(root.kids)
        root.kids = [root.kids, CreateNode(name, prediction, threshold, attribute)];
        return
    end

    if ~isempty(root.kids)
        if root.threshold > threshold
            root.kids{1}=CreateTree(name, prediction, threshold, attribute, root.kids{1});
        else
            if length(root.kids) == 1
                root.kids = [root.kids, CreateNode(name, prediction, threshold, attribute)];
                return
            end
            root.kids{2}=CreateTree(name, prediction, threshold, attribute, root.kids{2});
        end
    end
    return
end

function node = CreateNode(name, prediction, threshold, attribute)
    node = struct();
    node.op = name;
    node.kids = {};
    node.prediction = prediction;
    node.attribute = attribute; % [rangelow, rangehigh]
    node.threshold = threshold;
end