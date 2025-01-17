function y = plotUpstreamData(masterN,varargin)
p=inputParser;
addParameter(p,'curvature',1,@isnumeric)
addParameter(p,'type','ccdf',@ischar)
addParameter(p,'axes','log',@ischar)
addParameter(p,'xlabel','Max Upstream Length',@ischar)
addParameter(p,'ylabel','',@ischar)
addParameter(p,'title','',@ischar)
addParameter(p,'all',true,@islogical)
addParameter(p,'normalized',true,@islogical)
addParameter(p,'N',1,@isnumeric)
parse(p,varargin{:})
Nnum = p.Results.N;

if ~isfield(masterN,'Ldata')
    masterN = findMaxPath3Wrapper(masterN,'curvature',1);
end
if p.Results.all
    mTestN = 0;
    for i=1:length(masterN)
        if p.Results.normalized
            mTestN = [mTestN;vD(masterN(i).Ldata.mSPF)/max(vD(masterN(i).Ldata.mSPF))];
        else
            mTestN = [mTestN;vD(masterN(i).Ldata.mSPF)];
        end
    end
else
    if p.Results.normalized
        mTestN = vD(masterN(Nnum).Ldata.mSPF)/max(vD(masterN(Nnum).Ldata.mSPF));
    else
        mTestN = vD(masterN(Nnum).Ldata.mSPF);
    end
end


figure
switch p.Results.type
    case 'cdf'
        [ycdf,xcdf] = cdfcalc(mTestN);
        plot(xcdf,ycdf(1:end-1));
    case 'ccdf'
        [ycdf,xcdf] = cdfcalc(mTestN);
        xccdf = xcdf;
        yccdf = 1-ycdf(1:end-1);
        plot(xccdf,yccdf);
    case 'hist'
        histogram(mTestN);
        
end
switch p.Results.axes
    case 'log'
        set(gca,'xscale','log')
        set(gca,'yscale','log')
    case 'linear'
        set(gca,'xscale','linear')
        set(gca,'yscale','linear')        
end
    
xlabel(p.Results.xlabel)
ylabel(p.Results.ylabel)
title(p.Results.title)




end
% 
% % masterN = findMaxPath3Wrapper(masterN);
% mTestN = 0;
% for i=1:length(masterN)
% mTestN = [mTestN;vertcatDeep(masterN(i).Ldata.mSPF)/max(vertcatDeep(masterN(i).Ldata.mSPF))];
% end
% 
% 
% histogram(mTestN,'Normalization','cdf')
% histogram(mTestN,'Normalization','pdf')
% set(gca,'xscale','log')
% set(gca,'yscale','log')
% 
% ylabel('N');
% xlabel('Max upstream Length (microns)')
% 
% plotMaxUpHeat(masterN(30))
% 
% X = randn(10000,1);
% [ycdf,xcdf] = cdfcalc(mTestN);
% xccdf = xcdf;
% yccdf = 1-ycdf(1:end-1);
% plot(xcdf,yccdf);
% 
% 
% [D,Ang,InitAngs,WA,SA] = AvgAngleVsD(masterN,'curvature',1,'method','LT');
% D = D{1};
% figure;
% hold
% for i=1:length(masterN)
% %     [ycdf,xcdf] = cdfcalc(vD(masterN(i).Ldata.mSPF));
%     [ycdf,xcdf] = cdfcalc(vertcatDeep(masterN(i).Ldata.mSPF)/max(vertcatDeep(masterN(i).Ldata.mSPF)));
%     xccdf = xcdf;
%     yccdf = 1-ycdf(1:end-1);
%     plot(xccdf,yccdf,'Color',[(D(i)-min(D))/(max(D)-min(D)),0,0]);
% end
% hold
%     