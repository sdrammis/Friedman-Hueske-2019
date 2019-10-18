function [miceTrials,rewardTones,costTones,sessionNumbers] = get_mouse_trials(twdb,miceIDs,upToLearned,firstTask)
if firstTask
    firstTaskKey = 'learnedFirstTask';
else 
    firstTaskKey = 'learnedReversalTask';
end
    sessionNumbers = [];
    miceTrials = cell(1,length(miceIDs));
    for m = 1:length(miceIDs)
        mouseID = miceIDs{m};
        sessionIdx = get_mouse_sessions(twdb,mouseID,firstTask,0,'all',0);
        
        if ~isempty(sessionIdx)
            mouseTrials = table;
            for idx = sessionIdx
                trialData = twdb(idx).trialData;
                if ~isempty(trialData)
                    if ~any(strcmp('Engagement', trialData.Properties.VariableNames))
                        trialData.Engagement = -1*ones(height(trialData),1);
                    end
                    trialData.SessionNumber = twdb(idx).sessionNumber*ones(height(trialData),1);
                    mouseTrials = [mouseTrials; trialData];
                end
            end

            if upToLearned
                learnedFirstTask = first(twdb_lookup(twdb, firstTaskKey, 'key', 'mouseID', mouseID));
                if learnedFirstTask ~= -1
                    mouseTrials = mouseTrials(1:learnedFirstTask,:);
                end
            end

            miceTrials{m} = mouseTrials;
            rewardTones(m) = twdb(idx).rewardTone;
            costTones(m) = twdb(idx).costTone;
            sessionNumbers(m) = twdb(idx).sessionNumber;
        else
            miceTrials{m} = -1;
            rewardTones(m) = -1;
            costTones(m) = -1;
            sessionNumbers(m) = 0;
        end
    end
end
