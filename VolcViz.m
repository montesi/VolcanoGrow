Hall=[20:20:100];
nH=numel(Hall);
%%
HSV=[270,0.25,0.25;255,0.375,0.375;235,0.5,0.5;215,.75,.625;200,.75,1;170,.75,1;130,.75,1;105,.75,1;60,.75,1;40,.75,1;24,.75,1;0,.75,1;10,.5,.875;15,.375,.75;10,.25,.625;0,0,.75;0,0,1];
CM1=hsv2rgb([HSV(:,1)/360,HSV(:,2),HSV(:,3)]);
nCM1=size(CM1,1);nCM=64;
CM=interp1(linspace(0,1,nCM1),CM1,linspace(0,1,nCM));
%%


figure(1); clf;orient tall; colormap(CM)
for iH=1:nH;
    H=Hall(iH)*1000;
    for Stype=[1,2];
        if Stype==1
            LabelStyle='cone';
        else
            LabelStyle='dome';
        end
        LabelRoot=sprintf('%s%g',LabelStyle,H/1000);
        fprintf('Working on H=%gkm, %s source\n',H/1000,LabelStyle);
        clear Step;
        load(sprintf('%s.mat',LabelRoot));
        ilast=numel(Step);
        subplot(nH,2,2*(iH-1)+Stype); hold on;
        %         pcolor(xg/1000,xg/1000,Step(ilast).L+Step(ilast).W);
        surf(xg/1000,xg/1000,Step(ilast).L+Step(ilast).W);
        set(gca,'clim',[-1000,4000]);
        shading flat;
        contour3(xg/1000,xg/1000,Step(ilast).L+Step(ilast).W,[-1000:1000:15000],'k');
        %
        axis equal; axis tight; ; title (sprintf('H=%gkm',H/1000));
        set(gca,'visible','off');
        lightangle(140,30);
        lightangle(280,50);
        
        %%
        figure(2); clf;orient tall; colormap(CM)
        dp=50;
        np=floor((ilast-1)/dp);
        nx=ceil(sqrt(np));ny=ceil(np/nx);
        for ip=1:1:ilast/dp;
            is=1+(ip-1)*dp;
            subplot(nx,ny,ip); hold on;
            surf(xg/1000,xg/1000,Step(is).L+Step(is).W);
            set(gca,'clim',[-1000,4000]);
            shading interp;
            contour3(xg/1000,xg/1000,Step(is).L+Step(is).W,[-1000:1000:15000],'k');
            axis equal; axis tight; %title (sprintf('H=%gkm',H/1000));
            set(gca,'visible','off');
            lightangle(140,30);
            lightangle(280,50)
        end
        print(2,'-dpdf',sprintf('%sEvolution.pdf',LabelRoot));
        
        %%
        figure(3); clf;orient tall; colormap(CM)
        
        set(3,'Position',[200,200,200,200]);
        set(gca,'NextPlot','replacechildren');
        dp=1;
        np=floor((ilast-1)/dp);
        clear myMovie;%=[];%struct('cdata',[],'colormap',[]);
        for ip=1:1:np;
            is=1+(ip-1)*dp;
%         figure(3); clf;orient tall; colormap(CM)
            hold off; 
            surf(xg/1000,xg/1000,Step(is).L+Step(is).W);
            set(gca,'clim',[-1000,4000]);
            shading interp;
            hold on;
            contour3(xg/1000,xg/1000,Step(is).L+Step(is).W,[-1000:1000:15000],'k');
            axis equal; axis tight; %title (sprintf('H=%gkm',H/1000));
            set(gca,'visible','off');
            lightangle(140,30);
            lightangle(280,50);
            view(0,90);
            axis equal; set(gca,'Xlim',Xmax*[-1,1]/1000,'Ylim',Xmax*[-1,1]/1000);
            set(gca,'Position',[0,0,1,1]);
            myMovie(ip)=getframe(gcf);
        end
        myVideo=VideoWriter(sprintf('%s.avi',LabelRoot));
        open(myVideo);
        writeVideo(myVideo,myMovie)
        close(myVideo);
        

    end
end

%%
print(1,'-dpdf',sprintf('VolcanoFinal.pdf',LabelRoot));