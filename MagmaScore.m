function [C,Score]=MagmaScore(Xm,Ym,W,lam,mu,sigma_overburden,H,sigma_yield,DPG)

%%In the driver script: sigma_overburden=@(yf)-rho*g*h*((1-yf)/2);
% sigma_yield=0; 
Pbot=00e6;
% DPG=0; % delta pressure gradient
%rho=1; %3000 kg/m^3
%g=1; %3.8 m/s^2
% lam= ????
% mu= ????
% second derivatives of displacement
[dxx,dyy,dxy]=secondDerivatives(W,Xm,Ym); % Definition of 1/R
% vertical stress gradient
dsxx=-((lam+2*mu)*dxx + lam*dyy);%+rand(size(Xm))*0.1; 
dsyy=-(lam*dxx +(lam+2*mu)*dyy); 
dszz=-lam*(dxx+dyy); 
dsxy=-2*mu*dxy;
% find principal components
[V,D] = principalHorizontalStress(dsxx,dsyy,dsxy);

C(:,:,1)=(D(:,:,2)-dszz)*(H/2)+sigma_yield; %yield at the top
C(:,:,2)=(D(:,:,1)-dszz)*(-H/2)+sigma_yield;%+sigma_overburden(-H/2); %yield at the bottom

% for i=1:2; %top, bottom of plate
%     yf=H*((-1)^(i+1))/2;% [-1,1]; 
%     sov=sigma_overburden(yf);%rho*g*(H/2-yf);
%     C(:,:,i)=D(:,:,1)*(-yf)-sov-sigma_yield;
%     
% %     [sigma_xx, sigma_yy, sigma_zz, sigma_xy]=derivatives2stress(dxx,dyy,dxy,lam,mu,yf);
% %     [V,D] = principalHorizontalStress(sigma_xx,sigma_yy,sigma_xy);   
%       
% %     sigma_overburden=-rho*g*h*((1-yf)/2);    
% %     C(:,:,i)=D(:,:,end)-sigma_overburden-sigma_yield; %positive when verified
% %     C(:,:,i)=D(:,:,end)-sigma_overburden(yf)-sigma_yield; %positive when verified
% end
C(:,:,3)=-(C(:,:,1)-C(:,:,2))/H+DPG;%positive when verified
Score=(C(:,:,1)>=0)+2*(C(:,:,2)>=0)+4*(C(:,:,3)>=0); 






% 
% is=1:5:size(Xm,1); % consider every 5 x values
% js=1:5:size(Xm,2); % consider every 5 y values
% Dn=D(:,:,end);% keep minimal eig value
% 
% hold off
% 
% for i=1:3;
%     figure(4); hold on; 
%     subplot (2,2,i);
%     title(sprintf('Criterion %i',i))
%     colormap hot;
%     contourf(Xm, Ym, sqrt(max(C(:,:,i),0)),'linestyle','none');
%     colorbar;
% %     quiver(Xm(is,js),Ym(is,js),-V(is,js,2,end),V(is,js,1,end),0.5,'k.','linewidth',1);
% %     quiver(Xm(is,js),Ym(is,js),V(is,js,2,end),-V(is,js,1,end),0.5,'k.','linewidth',1);
%     xlabel('x/\alpha','fontsize', 18)
%     ylabel('y/\alpha','fontsize', 18)
%     set(gca, 'fontsize',14); axis equal; axis tight;
%     axis([min(Xm(:)),max(Xm(:)),min(Ym(:)),max(Ym(:))]);
% %     text(min(Xm(:))+0.05*(max(Xm(:))-min(Xm(:))),...
% %         min(Ym(:))+0.90*(max(Ym(:))-min(Ym(:))),...      
% %         sprintf('y_f=%g',yf),...
% 
% %         'backgroundcolor','w','edgecolor','k');
% hold off
% end
% 
% hold on
% subplot 224
% title('total score')
% contourf(Xm, Ym, Score, ...%(C(:,:,1)>=0)+(C(:,:,2)>=0)+(C(:,:,3)>=0),...
%     [0:3],'linestyle','none') %where all three criterion are verified 
% 
% 
% colorbar;
% % quiver(Xm(is,js),Ym(is,js),V(is,js,1,1),V(is,js,2,1),0.5,'k.','linewidth',1);
% % quiver(Xm(is,js),Ym(is,js),-V(is,js,1,1),-V(is,js,2,1),0.5,'k.','linewidth',1);
% xlabel('x/\alpha','fontsize', 18)
% ylabel('y/\alpha','fontsize', 18)
% set(gca, 'fontsize',14); axis equal; axis tight;
% axis([min(Xm(:)),max(Xm(:)),min(Ym(:)),max(Ym(:))]);
% 
% hold off


% [q,i] = min(Dn);
% [~,j] = min(q);
% Dn(i(j),j);