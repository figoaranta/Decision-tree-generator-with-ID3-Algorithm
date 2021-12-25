function [tree] = classificationTree(feature,label,treshold,usedFeature)
    attributeNames={'outlook','temperature','humidity','windy','play'};
    dataset = [feature,label];
    node = struct('op', 'null', 'kids',[],'prediction','null',"attribute",1,"branches",[]);
    informationGainsOfFeatures = containers.Map();
    entropyOfCurrentSet = entropy(dataset);
    if entropyOfCurrentSet <= treshold || length(usedFeature) == size(feature,2)
        probabilitOfYes = sum(label(:) == 1)/length(label);
        node.op = "";
        if probabilitOfYes >= 0.5
            node.prediction = 1;
        else
            node.prediction = 0;
        end
        
    else
%         entropy !== 0
        for i = 1:size(feature,2)
            lengthOfClasses = length(unique(feature(:,i)));
            entropies = [];
            probabilities = [];
            for j = 1:lengthOfClasses
                subDataset = dataset(dataset(:,i) == j,:);
                entrophyOfAClass = entropy(subDataset);
                probabilityOfAClass = length(subDataset)/length(dataset);
                entropies = [entropies,entrophyOfAClass];
                probabilities = [probabilities,probabilityOfAClass];
            end
            averageEntrophyOfAFeature = sum(probabilities.*entropies);
            informationGain = entropyOfCurrentSet - averageEntrophyOfAFeature;
            featureName = string(i);
            informationGainsOfFeatures(featureName) = informationGain;
        end
      
        informationGainsOfFeaturesValues = cell2mat(values(informationGainsOfFeatures));
        informationGainsOfFeaturesKeys = keys(informationGainsOfFeatures);


%         set used-feature(s) to have a very low information gain
        informationGainsOfFeaturesValues(usedFeature) = -9999;

%         Getting the highest information gain indeces
        indeces = cellfun(@(x)isequal(x,max(informationGainsOfFeaturesValues)),values(informationGainsOfFeatures));
        featureNameWithHighestInformationGain = informationGainsOfFeaturesKeys(indeces); %Cell format
    
%         Remove feature(s) that have been used
        
        featureNameWithHighestInformationGainVector = cellfun(@(x) str2num(char(x)), featureNameWithHighestInformationGain);
        featureIndex = setdiff(featureNameWithHighestInformationGainVector,usedFeature);
        featureIndex = featureIndex(1);
%         featureIndex = max(featureNameWithHighestInformationGainVector);
        
%         Append active feature of a node
        usedFeature = [usedFeature,featureIndex];

%         Set up a node name
        node.op = string("Feature "+featureIndex);
%         node.op = string(attributeNames((featureIndex)));
        
        branches = (unique(feature(:,double(featureIndex))))';
        node.branches = branches;
%         Add child node
%         nodeVec = [];
        nodeCell = {};
        treshold = treshold + 0.25;
        for i=1:length(unique(feature(:,double(featureIndex))))
            subDataset = dataset(dataset(:,featureIndex) == i,:);
            newFeature = subDataset(:,1:size(subDataset,2)-1);
            newLabel = subDataset(:,size(subDataset,2));
            newNode = classificationTree(newFeature,newLabel,treshold,usedFeature);
            nodeCell{end+1} = newNode;
%             nodeVec = [nodeVec, newNode];
        end
%         dataset(:,featureIndex) = []; Remove feature if needed
%         node.kids = nodeVec;
            node.kids = nodeCell;
    end
    tree = node;
end



