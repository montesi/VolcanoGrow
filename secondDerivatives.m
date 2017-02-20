function [wxx,wyy,wxy]=secondDerivatives(W,Xm,Ym);%,yf,lam,mu);
% function [sigma_xx,sigma_yy,sigma_zz,sigma_xy]=secondDerivatives(W,Xm,Ym);%,yf,lam,mu);

h=max(abs(Xm(1)-Xm(2)),abs(Ym(1)-Ym(2)));


% Kernels
pxx = [0,0,0;1, -2, 1;0,0,0]/(h^2); %d^2w/dx^2 
% pxx=pxx/h^2;
pyy= pxx';%[0,1,0;0, -2,0;0,1,0]/(h^2); %d^2w/dy^2
% pyy=pyy/h^2;
pxy= [-1 0 1; %d^2w/dxdy
    0 0 0;
    1 0 -1]/(-4*h^2);
% pxy=flipud(pxy);
% px=[-1 0 1]; %dw/dx px = px/(2*h);
% py=[-1 0 1]'; %dw/dy py=py/(2*h);

% Initialize
wxx=zeros(size(Xm)); wyy=zeros(size(Xm)); wxy=zeros(size(Xm));
%wx=zeros(size(Xm)); wy=zeros(size(Xm));
% Numerical second derivatives
%for i= 1:numel(Xm(1,:))
for i= 2:size(Xm,1)-1;
    %for j=2:numel(Xm(:,1))-1
    for j=2:size(Xm,2)-1;
        wl=W(i-1:i+1,j-1:j+1);
        wxx(i,j)=sum(sum(wl.*pxx));
        wyy(i,j)=sum(sum(wl.*pyy));
        wxy(i,j)=sum(sum(wl.*pxy));
%         wxx(i,j)=sum(sum(pxx.*W(i,j-1:j+1)));
%         wyy(i,j)=sum(sum(pyy.*W(i-1:i+1,j)));
%         %         wx(i,j)=sum(sum(px.*W(i,j-1:j+1)));
%         %         wy(j,i)=sum(sum(py.*W(j-1:j+1,i)));
%         %         if (i>1) && (i<numel(Xm(1,:)));
%         wxy(i,j)=sum(sum(pxy.*W(i-1:i+1, j-1:j+1)));
%         %         end
    end
end
%lam=((E*v)/((1+v)*(1-2*v))); mu=(E/(2*(1-v)));
% % numerical Stresses
% sigma_xx=yf*((lam+2*mu)*wxx + lam*wyy);
% sigma_yy=yf*(lam*wxx +(lam+2*mu)*wyy);
% sigma_zz= yf*lam*(wxx+wyy);
% sigma_xy=2*mu*yf*wxy;
% % sigma_xz=2*mu*wx;
% % sigma_yz=2*mu*wy;



% dxx=(Xm.^2)./(W.^3);
% dyy=(Ym.^2)./(W.^3);
% dxy=(Xm.*Ym)./(W.^3);
% 
% sigma_xx=yf*((lam+2*mu)*dxx + lam*dyy);
% sigma_yy=yf*(lam*dxx +(lam+2*mu)*dyy);
% sigma_zz= yf*lam*(dxx+dyy);
% sigma_xy=2*mu*yf*dxy;