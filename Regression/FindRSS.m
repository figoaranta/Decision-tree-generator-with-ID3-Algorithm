function [rss, threshold] = FindRSS(feature, label)
    rss = zeros(length(feature)-1,1);
    threshold = zeros(length(feature)-1,1);
    
    for i=1:length(feature)-1
        % Find root mean (Threshold)
        meanRoot = mean(feature(i:i+1));
        redLine = 0;
        for j=1:length(feature)
            if feature(j) > meanRoot
                redLine = j-1;
                break
            end
        end
        
        % Find left mean
        meanLeft = mean(label(1:redLine));
    
        % Find right mean
        meanRight = mean(label(redLine+1:length(feature)));
    
        % Find RSS
        RSS = 0;
        for j=1:redLine
            RSS = RSS + (feature(j)-meanLeft)^2;
        end
    
        for j=redLine+1:length(feature)
            RSS = RSS + (feature(j)-meanRight)^2;
        end
    
        rss(i) = RSS;
        threshold(i) = meanRoot;
    end

    if length(feature) == 1
        rss(1) = sqrt(mean(label));
        threshold(1) = sqrt(mean(feature));
    end
end