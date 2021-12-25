function [entropy] = entropy(dataset)

    y = dataset(:,size(dataset,2));
    
    probabilitOfYes = sum(y(:) == 1)/length(y);
    probabilitOfNo = sum(y(:) == 0)/length(y);
    log2OfprobabilitOfYes = log2(probabilitOfYes);
    log2OfprobabilitOfNo = log2(probabilitOfNo);
    
    result = - probabilitOfYes * log2OfprobabilitOfYes - probabilitOfNo * log2OfprobabilitOfNo;

    if(isnan(result))
        entropy = 0;
    else
        entropy = result;
    end

end

