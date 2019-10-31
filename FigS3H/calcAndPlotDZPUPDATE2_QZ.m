% Author: QZ
% 08/29/2019
function [nanIdxs,mouseIDs,CSaline,CDZP,CBase,DSaline,DDZP,DBase,...
    RTSaline,RTDZP,RTBase,CTSaline,CTDZP,CTBase] = calcAndPlotDZPUPDATE2_QZ(twdb,...
    mouseIDs,rTones,cTones,numSessions,strioStr,dzpData)
CSaline = zeros(1,length(mouseIDs));
CDZP = zeros(1,length(mouseIDs));
CBase = zeros(1,length(mouseIDs));
DSaline = zeros(1,length(mouseIDs));
DDZP = zeros(1,length(mouseIDs));
DBase = zeros(1,length(mouseIDs));
RTSaline = cell(1,length(mouseIDs));
RTDZP = cell(1,length(mouseIDs));
RTBase = cell(1,length(mouseIDs));
CTSaline = cell(1,length(mouseIDs));
CTDZP = cell(1,length(mouseIDs));
CTBase = cell(1,length(mouseIDs));
nanIdxs = [];
for i = 1:length(mouseIDs)
    msID = mouseIDs{i};
    disp(['------' num2str(i) ': Mouse ' msID '------']);
    numSession = numSessions(i);
    rTone = rTones(i);
    cTone = cTones(i);
    dzpIdx = first(twdb_lookup(table2struct(dzpData),'index',...
        'key','mouseID',msID,'key','injection','Diazepam'));
    salIdx = cell2mat(twdb_lookup(table2struct(dzpData),'index',...
        'key','mouseID',msID,'key','injection','Saline'));
    baseIdx = first(twdb_lookup(twdb,'index','key','mouseID',msID,...
        'key','sessionNumber',numSession));
    dzpTrialData = twdb(dzpIdx).trialData;
    baseTrialData = twdb(baseIdx).trialData;
    dzpFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,dzpIdx,dzpTrialData);
    baseFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,baseIdx,baseTrialData);
    [dpBase,rTraceBase,cTraceBase,cBase,~,~] = get_dprime_traceArea_UPDATE2(baseTrialData,...
        baseFluorData,rTone,cTone);
    CBase(i) = cBase;
    DBase(i) = dpBase;
    RTBase{i} = rTraceBase;
    CTBase{i} = cTraceBase;
    [dpDZP,rTraceDZP,cTraceDZP,cDZP,~,~] = get_dprime_traceArea_UPDATE2(dzpTrialData,...
        dzpFluorData,rTone,cTone);
    CDZP(i) = cDZP;
    DDZP(i) = dpDZP;
    RTDZP{i} = rTraceDZP;
    CTDZP{i} = cTraceDZP;
    if length(salIdx) == 1
        disp('!')
        salineTrialData = twdb(salIdx).trialData;
        salineFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx,salineTrialData);
        [dpSaline,rtSaline,ctSaline,cSaline,~,~] = get_dprime_traceArea_UPDATE2(salineTrialData,...
            salineFluorData,rTone,cTone);
    else
        salineBeforeTrialData = twdb(salIdx(1)).trialData;
        salineAfterTrialData = twdb(salIdx(2)).trialData;
        salineBeforeFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx(1),salineBeforeTrialData);
        salineAfterFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx(2),salineAfterTrialData);
        [dpSalineBefore,rTraceSalineBefore,cTraceSalineBefore,cSalineBefore,...
            ~,~] = get_dprime_traceArea_UPDATE2(salineBeforeTrialData,...
            salineBeforeFluorData,rTone,cTone);
        [dpSalineAfter,rTraceSalineAfter,cTraceSalineAfter,cSalineAfter,...
            ~,~] = get_dprime_traceArea_UPDATE2(salineAfterTrialData,...
            salineAfterFluorData,rTone,cTone);
        cSaline = nanmean([cSalineBefore,cSalineAfter]);
        dpSaline = nanmean([dpSalineBefore,dpSalineAfter]);
        rtSaline = nanmean([rTraceSalineBefore',rTraceSalineAfter']);
        ctSaline = nanmean([cTraceSalineBefore',cTraceSalineAfter']);
    end
    CSaline(i) = cSaline;
    DSaline(i) = dpSaline;
    RTSaline{i} = rtSaline;
    CTSaline{i} = ctSaline;
    if isnan(nanmean(rtSaline)) || isnan(nanmean(ctSaline)) || ...
            isnan(nanmean(rTraceBase)) || isnan(nanmean(cTraceBase)) || ...
            isnan(nanmean(rTraceDZP)) || isnan(nanmean(cTraceDZP))
        nanIdxs = [nanIdxs i];
    end
end
disp(nanIdxs);
% clean data
CSaline(nanIdxs) = [];
CDZP(nanIdxs) = [];
CBase(nanIdxs) = [];
DSaline(nanIdxs) = [];
DDZP(nanIdxs) = [];
DBase(nanIdxs) = [];
RTSaline(nanIdxs) = [];
RTDZP(nanIdxs) = [];
RTBase(nanIdxs) = [];
CTSaline(nanIdxs) = [];
CTDZP(nanIdxs) = [];
CTBase(nanIdxs) = [];
mouseIDs(nanIdxs) = [];
% plotting
% figure() % Plot c and d'
% subplot(4,2,1)
% for i = 1:length(CDZP)
%     hold on
%     plotNoBar_UPDATE2({CBase(i),CDZP(i)},'C',{'Base','DZP'},strioStr,...
%         'b','b','b',1,0)
%     hold off
% end
% subplot(4,2,2)
% for i = 1:length(CSaline)
%     hold on
%     plotNoBar_UPDATE2({CBase(i),CSaline(i)},'C',{'Base','Saline'},strioStr,...
%         'r','r','r',1,0)
%     hold off
% end
% subplot(4,2,3)
% for i = 1:length(DDZP)
%     hold on
%     plotNoBar_UPDATE2({DBase(i),DDZP(i)},'DP',{'Base','DZP'},strioStr,...
%         'b','b','b',1,0)
%     hold off
% end
% subplot(4,2,4)
% for i = 1:length(DSaline)
%     hold on
%     plotNoBar_UPDATE2({DBase(i),DSaline(i)},'DP',{'Base','Saline'},...
%         strioStr,'r','r','r',1,0)
%     hold off
% end
% subplot(4,2,5)
% for i = 1:length(RTDZP)
%     hold on
%     plotNoBar_UPDATE2({RTBase{i},RTDZP{i}},'Reward Trace',{'Base','DZP'},...
%         strioStr,'b','b','b',0,0)
%     hold off
% end
% subplot(4,2,6)
% for i = 1:length(RTSaline)
%     hold on
%     plotNoBar_UPDATE2({RTBase{i},RTSaline{i}},'Reward Trace',{'Base','Saline'},...
%         strioStr,'r','r','r',0,0)
%     hold off
% end
% subplot(4,2,7)
% for i = 1:length(CTDZP)
%     hold on
%     plotNoBar_UPDATE2({CTBase{i},CTDZP{i}},'Cost Trace',{'Base','DZP'},strioStr,'b','b','b',0,0)
%     hold off
% end
% subplot(4,2,8)
% for i = 1:length(CTSaline)
%     hold on
%     plotNoBar_UPDATE2({CTBase{i},CTSaline{i}},'Cost Trace',{'Base','Saline'},strioStr,'r','r','r',0,0)
%     hold off
% end
figure() % Plot c and d'
subplot(2,2,1)
for i = 1:length(CDZP)
    hold on
    plotNoBar_UPDATE2({CSaline(i),CDZP(i)},'C',{'Saline','DZP'},strioStr,...
        'b','b','b',1,0)
    hold off
end
subplot(2,2,2)
for i = 1:length(DDZP)
    hold on
    plotNoBar_UPDATE2({DSaline(i),DDZP(i)},'DP',{'Saline','DZP'},strioStr,...
        'b','b','b',1,0)
    hold off
end
subplot(2,2,3)
for i = 1:length(RTDZP)
    hold on
    plotNoBar_UPDATE2({RTSaline{i},RTDZP{i}},'Reward Trace',{'Saline','DZP'},...
        strioStr,'b','b','b',0,0)
    hold off
end
subplot(2,2,4)
for i = 1:length(CTDZP)
    hold on
    plotNoBar_UPDATE2({CTSaline{i},CTDZP{i}},'Cost Trace',{'Saline','DZP'},...
        strioStr,'b','b','b',0,0)
    hold off
end
end