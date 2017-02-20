function VolcanoFigure(xp,yp,L,W,Score,C,xs,ys,ip,dA);
figure(ip); clf;
subplot 221; imagesc(xp,yp,L+W); axis equal; axis tight; colorbar; title ('Topography');
subplot 222; imagesc(xp,yp,W); axis equal; axis tight; colorbar; title ('Deflection')
subplot 223; imagesc(xp,yp,Score); axis equal; axis tight;  title ('Score')
% set(gca,'Clim',[0,7]); colormap(jet(7));colorbar
set(gca,'Clim',[-1,8]); colormap(jet(9));colorbar
subplot 224;
set(gca,'dataaspectratio',[10,10,1000]); box on; view(3)
hold on;
HS=surf(xp,yp,L+W,L+W); shading interp; lighting gouraud
hold on; contour3(xp,yp,L+W,'k'); HW=surf(xp,yp,W); shading interp;
HL=camlight; colorbar; title(sprintf('Total erupted volume: %g km^3',sum(L(:))*dA/1e9));
set(HS,'facealpha',0.5)
set(gca,'xlim',[-150,150],'ylim',[-150,150])

%%
figure(ip+1); clf;
subplot 221; imagesc(xp,yp,max(0,C(:,:,1))); axis equal; axis tight; colorbar
subplot 222; imagesc(xp,yp,max(0,C(:,:,2))); axis equal; axis tight; colorbar
subplot 223; imagesc(xp,yp,max(0,C(:,:,3))); axis equal; axis tight;
% set(gca,'Clim',[0,7]); colormap(jet(7));
colorbar
subplot 224; imagesc(xp,yp,Score); axis equal; axis tight;
set(gca,'Clim',[-1,8],'xlim',[-150,150],'ylim',[-150,150]); colormap(jet(9));colorbar
hold on;plot(xs/1000,ys/1000,'ok')
