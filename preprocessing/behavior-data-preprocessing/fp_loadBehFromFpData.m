function [beh]=fp_loadFiberTableFromFpData(sessionFolder)
matFilename=[sessionFolder filesep 'fpData.mat'];
load(matFilename);