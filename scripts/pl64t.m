function [xf]=pl64t(x,cutoff);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function xf=pl64t(x,cutoff);
%
% low-pass filters the time series x using the
% PL64 filtered described in Rosenfeld, 1983
% WHOI technical report 85-35, pg.21.
% 
% The time series is folded over and
% cosine tapered at each end to return a
% filtered time series of the same length.
%
% half amplitude at "cutoff" samples
% half amplitude default 33 hours
%
% Steve Lentz 22 July 1992
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%default to pl64
if (nargin==1); cutoff=33; end;
 
[npts,ncol]=size(x);
xf=x;

fq=1./cutoff;
nw=floor(2.*cutoff);
nw2=2.*nw;

%generate filter weights
j=1:nw;
t=pi.*j;
den=fq.*fq.*t.^3;
wts=(2.*sin(2.*fq.*t)-sin(fq.*t)-sin(3.*fq.*t))./den;
% make symmetric filter weights
% coefficient is to match fortran version of outputs
wts=[wts(nw:-1:1),2.*fq,wts];
wts=wts./sum(wts);%normalize to exactly one

%fold tapered time series on each end
cs=cos(t'./nw2);
jm=[nw:-1:1];

for ic=1:ncol
% ['column #',num2str(ic)]
%find all good points
 jgd=find(isfinite(x(:,ic)));
 ngd=length(jgd);

 if (ngd>nw2) 
%detrend time series, then add trend back after filtering
 % xdt=detrend(x(jgd,ic));
 % trnd=x(jgd,ic)-xdt;
%find range of good data, i.e. first and last data points
  ns=jgd(1);ne=jgd(ngd);
  jc=[ns:1:ne].';
  npts=length(jc);
  xdt=x(jc,ic);
  trnd=xdt(1)+(jc-ns)*(xdt(npts)-xdt(1))./(npts);
% plot(jc,xdt,jc,trnd,'r');pause;
  xdt=xdt-trnd;

  y=[cs(jm).*xdt(jm);xdt;cs(j).*xdt(npts+1-j)];

% filter
  yf=filter(wts,1.0,y);

% strip off extra points
  xf(jc,ic)=yf(nw2+1:npts+nw2);

% add back trend
  xf(jc,ic)=xf(jc,ic)+trnd;


 else
     xf(:,ic)=nan*x(:,ic);
 'warning time series is too short filled NaN'
 end

end
