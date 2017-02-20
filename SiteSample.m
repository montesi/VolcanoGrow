function [xs,ys]=SiteSample(ns,r0,type)
% [xs,ys]=SiteSample(ns,r0,type)
% produces ns samples distributed over radius r0 with distribution of type:
%   type=1: uniform probability, p=p0=1/r0 if r<r0, p=0 otherwise
%   type=2: probability proportional to area, p dr = p0 r dr if r<r0, p=0 otherwise
%   other:  probability proportional to area, p dr = p0 r dr if r<r0, p=0 otherwise
% r:        radius
% th:       angle
% [xs,ys]:  coordonates of samples sites

switch type
    case 1
        rdist=@(c,r0)r0*c;
%         disp('uniform probability, p=p0=1/r0 if r<r0, p=0 otherwise');
    case 2
        rdist=@(c,r0)r0*sqrt(c);
%         disp('probability proportional to area, p dr = p0 r dr if r<r0, p=0 otherwise')
    otherwise
        rdist=@(c,r0)r0*sqrt(c);
%         disp('case not found: use probability proportional to area, p dr = p0 r dr if r<r0, p=0 otherwise')
end
%ns=1000; %number of samples
%r0=1; %radius of magma source
c=rand([1,ns]); %random values of cumulative probability function
r=rdist(c,r0); %radius of potential eruptive sites
th=rand([1,ns])*2*pi; %angle of potential eruptive sites
xs=r.*cos(th);
ys=r.*sin(th);

% % visualize sample sites
% figure(2); clf;
% subplot(211)
% plot(xs,ys,'ob');
% ts=linspace(0,2*pi,100);
% hold on; plot(r0*cos(ts),r0*sin(ts),'r');
% xlabel('x'); ylabel('y');
% title(sprintf('%d samples',ns));
% axis equal
%
% subplot(212)
% plot(r,th,'ob');
% hold on; plot(r0*[1,1],[0,2*pi],'r');
% axis([0,1.5*r0,0,2*pi])
% xlabel('r'); ylabel('\theta');
% % title(sprintf(disp(rdist)))
