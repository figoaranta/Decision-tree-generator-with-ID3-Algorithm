% df = load("pearson_air_quality.mat");
% X = df.X;
% y = df.y;

function root = RegressionTree(X, y) 
    labels = y;
    features = X;
    
    minimum = 20; % potential parameter

    min_rss = [];
    for i=1: width(features)
        sortedFeature = [features(:,i), labels];
        sortedFeature = sortrows(sortedFeature,1);
        sortedLabel = sortedFeature(:,2);
        [rss, threshold] = FindRSS(sortedFeature(:,i), sortedLabel);
        smoll = min(rss);
        min_rss = [min_rss, smoll(1)];
    end
    
    tree = [];
    for k=1:length(min_rss)
        top_root = find(min_rss==min(min_rss));
        sortedFeature = [features(:,top_root), labels];
        sortedFeature = sortrows(sortedFeature,1);
        sortedLabel = sortedFeature(:,2);
        feature_top_root = sortedFeature(:,1);
        side = 'left';
        rootNode = 0;
    
        while true
            index = 0;
            if strcmp('right', side)
                for i=1:length(tree)-1
                    if length(tree(length(tree)-i).kids) < 2 && isnan(tree(length(tree)-i).prediction)
                        index = i;
                        break;
                    end
                end
                if index == 0
                    break
                end
                rootNode = tree(length(tree)-index).threshold;
            end
        
            if rootNode == 0
                rangelow = 1;
                rangehigh = length(feature_top_root);
            else
                rangelow = tree(length(tree)-index).attribute(1);
                rangehigh = tree(length(tree)-index).attribute(2);
            end
            
            for i=rangelow:rangehigh
                if feature_top_root(i) > rootNode
                    if rootNode ~= 0
                        redLine = i-1;
                    else
                        redLine = length(feature_top_root);
                    end
                    break
                else
                    redLine = i-1;
                end
            end
        
            if redLine == 0
                redLine = 1;
            end
        
            if rootNode == 0
                rangelow = 1;
                rangehigh = length(feature_top_root);
            else
                if strcmp('left', side)
                    rangelow = tree(length(tree)-index).attribute(1);
                    rangehigh = redLine;
                else
                    rangelow = redLine+1;
                    rangehigh = tree(length(tree)-index).attribute(2);
                    if k ~= length(min_rss) && rangehigh == length(feature_top_root)
                        break
                    end
                end
            end
            
            if strcmp('left', side)
                feature = feature_top_root(rangelow:redLine);
                label = sortedLabel(rangelow:redLine);
            else
                feature = feature_top_root(redLine:rangehigh);
                label = sortedLabel(redLine:rangehigh);
            end
        
            [rss, threshold] = FindRSS(feature, label);
            num = find(rss==min(rss));
            num = num + rangelow - 1;
            prediction = sortedLabel(num(1));
            op = feature_top_root(num(1));
        
            if strcmp('right', side)
                rootNode = op;
                for i=rangelow:rangehigh
                    if feature_top_root(i) > rootNode
                        if rootNode ~= 0
                            redLine = i-1;
                        else
                            redLine = length(feature_top_root);
                        end
                        break
                    end
                end
            end
        
            if strcmp('left', side)
                if redLine-rangelow < minimum % reached the end of the branch (become left leaf)
                    name = "";
                    side = "right";
                else
                    name = "Feature "+top_root+" < "+op; %
                    prediction = nan;
                end
            else
                if redLine-rangelow < minimum && rangehigh - rangelow < minimum % reached the end of the branch (become right leaf)
                    name = "";
                    % time to go up
                else
                    name = "Feature "+top_root+" >= "+op; %
                    side = "left";
                    prediction = nan;
                end
            end
        
            node = CreateNode(name, prediction, op, [rangelow, rangehigh]);
            if rootNode ~= 0
                tree(length(tree)-index).kids = [tree(length(tree)-index).kids, node];
            end
            tree = [tree, node];
            rootNode = op;
        end
        min_rss(top_root) = nan;
    end
    
    root = CreateTree(tree(1).op, tree(1).prediction, tree(1).threshold, tree(1).attribute);
    for i=2:length(tree)
        root = CreateTree(tree(i).op, tree(i).prediction, tree(i).threshold, tree(i).attribute, root);
    end
    
%     DrawDecisionTree(root, "Tree");
end

function tree = CreateNode(name, prediction, threshold, attribute)
    tree = struct();
    tree.op = name;
    tree.kids = [];
    tree.prediction = prediction;
    tree.attribute = attribute; % [rangelow, rangehigh]
    tree.threshold = threshold;
end
