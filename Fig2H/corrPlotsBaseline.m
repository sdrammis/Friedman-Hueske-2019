function corrPlotsBaseline(twdb)

% 07/10/2019
% Author: QZ
% corrPlotsBaseline.m
%% Part I. All Mice (07/10/2019-07/12/2019) session level
% cases = mouseFilter(twdb,'all',age,health,striosomality);
load('behavioralDB_06_06_2019.mat');
learn = 'all';
striosomality = 'all';
WT = mouseFilter(twdb,learn,'all','WT',striosomality,1); % ~~~~~~MODIFY~~~~~~
wtIdxs = zeros(1,length(WT));
for i = 1:length(WT)
    disp(['------' num2str(i) '------']);
    [~,twdbIdx,~] = getBaselineSessionNum_QZ(twdb,WT(i),1,3);
    wtIdxs(i) = twdbIdx;
end
wtAges = [twdb(wtIdxs).firstSessionAge];
% wtStrio = {twdb(wtIdxs).intendedStriosomality};
[~,c_WT,~,~,~,~,~,~,~] = calcCorrStats(twdb,WT,wtIdxs);

HD = mouseFilter(twdb,learn,'all','HD',striosomality,1); % ~~~~~~MODIFY~~~~~~
hdIdxs = zeros(1,length(HD));
for i = 1:length(HD)
    disp(['------' num2str(i) '------']);
    [~,twdbIdx,~] = getBaselineSessionNum_QZ(twdb,HD(i),1,3);
    hdIdxs(i) = twdbIdx;
end
hdAges = [twdb(hdIdxs).firstSessionAge];
% hdStrio = {twdb(hdIdxs).intendedStriosomality};
[~,c_HD,~,~,~,~,~,~,~] = calcCorrStats(twdb,HD,hdIdxs);
% plotting
% WT vs. HD
%% Get more data
yngWTIdxs1 = find(wtAges <= 8);
midWTIdxs1 = intersect(find(wtAges>=9),find(wtAges<=12));
oldWTIdxs1 = find(wtAges >= 13);
c_yngWT = c_WT(yngWTIdxs1);
c_midWT = c_WT(midWTIdxs1);
c_oldWT = c_WT(oldWTIdxs1);
yngHDIdxs1 = find(hdAges <= 8);
midHDIdxs1 = intersect(find(hdAges>=9),find(hdAges<=12));
oldHDIdxs1 = find(hdAges >= 13);
c_yngHD = c_HD(yngHDIdxs1);
c_midHD = c_HD(midHDIdxs1);
c_oldHD = c_HD(oldHDIdxs1);
%% Figure 1-3 - WT vs. HD; C, DP, LRR
figure();
hold on;
plotNoBar({c_yngWT,c_midWT,c_oldWT,},'',...
    {'<=8 months','9-12 months','>=13 months'},'','c','b','b',true);
hold on;
plotNoBar({c_yngHD,c_midHD,c_oldHD},'C',...
    {'<=8 months','9-12 months','>=13 months'},'C, WT vs. HD','m',...
    'r','r',true);
hold off;
legend('WT Young','WT Mid','WT Old','WT','HD Young','HD Mid','HD Old',...
    'HD','Location','BestOutside');
hold off;
%% Calculate Statistics
disp('------C Across Age------');
% WT
ttest2_QZ(c_yngWT,c_midWT,'Young-Mid WT: ');
ttest2_QZ(c_yngWT,c_oldWT,'Young-Old WT: ');
ttest2_QZ(c_midWT,c_oldWT,'Mid-Old WT: ');
% HD
ttest2_QZ(c_yngHD,c_midHD,'Young-Mid HD: ');
ttest2_QZ(c_yngHD,c_oldHD,'Young-Old HD: ');
ttest2_QZ(c_midHD,c_oldHD,'Mid-Old HD: ');

disp('------C Across Genotypes------');
ttest2_QZ(c_yngHD,c_yngWT,'Young HD-WT: ');
ttest2_QZ(c_midHD,c_midWT,'Mid HD-WT: ');
ttest2_QZ(c_oldHD,c_oldWT,'Old HD-WT: ');

disp('------One-Way ANOVA------');
cYWT = cell(1,length(yngWTIdxs1));
cYWT(:) = {'Young WT'};
cMWT = cell(1,length(midWTIdxs1));
cMWT(:) = {'Mid WT'};
cOWT = cell(1,length(oldWTIdxs1));
cOWT(:) = {'Old WT'};
cYHD = cell(1,length(yngHDIdxs1));
cYHD(:) = {'Young HD'};
cMHD = cell(1,length(midHDIdxs1));
cMHD(:) = {'Mid HD'};
cOHD = cell(1,length(oldHDIdxs1));
cOHD(:) = {'Old HD'};
groups1 = horzcat(cYWT,cMWT,cOWT,cYHD,cMHD,cOHD);
values1 = [c_yngWT,c_midWT,c_oldWT,c_yngHD,c_midHD,c_oldHD];
[p1,tab1,stats1] = anova1(values1,groups1);
disp(['Significance: ' num2str(p1)]);
%% Datatable
% DATATABLE_END_YNGHD = table(HD(yngHDIdxs1)',c_yngHD','VariableNames',{'mouseIDs','C'});
% DATATABLE_END_MIDHD = table(HD(midHDIdxs1)',c_midHD','VariableNames',{'mouseIDs','C'});
% DATATABLE_END_OLDHD = table(HD(oldHDIdxs1)',c_oldHD','VariableNames',{'mouseIDs','C'});
% DATATABLE_END_YNGWT = table(WT(yngWTIdxs1)',c_yngWT','VariableNames',{'mouseIDs','C'});
% DATATABLE_END_MIDWT = table(WT(midWTIdxs1)',c_midWT','VariableNames',{'mouseIDs','C'});
% DATATABLE_END_OLDWT = table(WT(oldWTIdxs1)',c_oldWT','VariableNames',{'mouseIDs','C'});