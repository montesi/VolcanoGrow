% VG.
% Physical parameters
E=0.5e11;    %[Pa]       Young's Modulus
nu=.25;     %[ND]       Poisson's Ratio
H=100e3;     %[m]        Plate thickness
g=3.8;      %[m/s^2]    gravity (Mars)
R=3390e3;   %[m]        Planetary radius (Mars)
rhom=3300;  %[kg/m^3]   Mantle density
rhos=0;     %[kg/m^3]   Surface density (air)
rhoc=2800;  %[kg/m^3]   Crust/Basalt density

sl=50e6; %local stress
DPG=sl/100; %excess magma pressure and buoyancy

% numerical parameters
Xmax=150e3; %[m] 1/2 of computation domains
nx=50;     %number of grid points
nstep=500;   %number of iterations
% Magma source
r0=100e3;
%[m]        Magma source radius
Stype=1;    %           type of source distribution
ns=100;     %           Number of random point sources in the magma source
% Eruption geometry
re=	50e3;    %[m]        Radius of eruption
He=100;     %[m]        thickness of eruption
%define eruption shape
r=@(x,y,x0,y0)((x-x0).^2+(y-y0).^2).^(1/2); %distance from point x0,y0
% l=@(x,y,x0,y0)He*le(r(x,y,x0,y0),re); %Step function
l=@(x,y,x0,y0)He*max(1-r(x,y,x0,y0)/re,0); %Step function

%grid setup
Xmin=-Xmax; %minimum coordinate
xg=linspace(Xmin,Xmax,nx);  % x-vector, aLso y-vector
xm=(xg(1:end-1)+xg(2:end))/2; %midpoints x-vector
dx=(Xmax-Xmin)/(nx-1);      % grid spacing
[Xm,Ym]=meshgrid(xm);       % grid midpoints
[Xg,Yg]=meshgrid(xg);       % grid points
dA=dx^2;    %area of grid


for H=[10,20,30,40,60,80,100]*1000;
    for Stype=[1,2];
        if Stype==1
            LabelStyle='cone';
        else
            LabelStyle='dome';
        end
        LabelRoot=sprintf('%s%g',LabelStyle,H/1000);
        fprintf('Working on H=%gkm, %s source',H/1000,LabelStyle);
        clear Step;
        
% conversions
% DPG=(rhoc-rhom)*g; %Buoyancy gradient

lam=E*nu/(1+nu)/(1-2*nu);   %[Pa]   Lamé parameters
mu=E/2/(1+nu);              %[Pa]   Lamé parameters
D=E*H^3/(12*(1-nu^2));        %[N.m]  Flexural rigidity
Drho=rhom-rhos;             %[kg/m^3] Density contrast across the plate
% alpha=(4*D/(Drho*g))^(1/4); %[m] 	Flexural wavelength
beta=(D/(E*H/R^2+Drho*g))^(1/4);    %[m] 	Flexural wavelength
% beta=(D/(Drho*g))^(1/4);    %[m] 	Flexural wavelength
L2W=rhoc*g*dA*(beta^2)/(2*pi*D); % conversion load thickness to deflection
% rgh=rhom*g*H;


%Initialize
L=Xg*0;W=L;U=L;Score=L+7;C=repmat(L,[1,1,3]);xe=0;ye=0;
istep=1;
Step(istep).W=W; %deflection
Step(istep).L=L; %load
Step(istep).Score=Score; %score
Step(istep).C=C; %failure criteria
Step(istep).U=U; %Underplating
Step(istep).XE=[xe,ye]; %Accretion site


wm=Xg*0;
while istep<=nstep
    istep=istep+1;
    [xs,ys]=SiteSample(ns,r0,Stype); %potential eruption sites
    sc=interp2(Xg,Yg,Score,xs,ys,'nearest'); %score potential sites
    ie=min(find(sc==7)); %eruption at 1st site where all the criteria are verified.
    if ~isempty(ie);  %there is a new eruption site
        xe=xs(ie); ye=ys(ie);
    end %otherwise stay at the same place (open conduit)
    Ls=l(Xg,Yg,xe,ye); % eruption height at each grid point
    lm=(Ls(1:end-1,1:end-1)+Ls(1:end-1,2:end)+Ls(2:end,1:end-1)+Ls(2:end,2:end))/4; %height at center point
    im=find(ne(lm,0));
    wm=Xg*0;
    for in=[im]';
        wm=wm+lm(in)*KEI(r(Xg,Yg,Xm(in),Ym(in))/beta);
    end
    W=W+wm*L2W;
    % compute score;
    % When Score is converted to binary, each bit corresponds to a criterion
    %   Score[1]=tension at top
    %   Score[2]=tension at botton
    %   Score[3]=vertical pressure tension gradient
    % Each value is a specific combination of verified criteria
    % C contains the numberical value for each criterion.
    
%     [C,Score]=MagmaScore(Xg,Yg,W,lam,mu,@(z)rhom*g*(1-z),H);
    [C,Score]=MagmaScore(Xg,Yg,W,lam,mu,@(yf)rhom*g*(H/2-yf),H,sl,DPG);
    L=L+Ls;
    %     eLse
    %         ie=1;
    %         xe=xs(ie); ye=ys(ie);
    %         Ls=l(Xg,Yg,xe,ye); % eruption height at each grid point
    %         U=U+Ls; %add to underplating
    %     end
    
    %store results
    Step(istep).W=W; %deflection
    Step(istep).L=L; %load
    Step(istep).Score=Score; %score
    Step(istep).C=C; %failure criteria
    Step(istep).U=U; %Underplating
    Step(istep).XE=[xe,ye]; %Accretion site
    Step(istep).xs=xs;
    Step(istep).ys=ys;
end
%
%% plotting
save(sprintf('%s.mat',LabelRoot));
ip=-1;
for istep=1:50:numel(Step);
    ip=ip+2;
    VolcanoFigure(xg/1000,xg/1000,...
        Step(istep).L,Step(istep).W,Step(istep).Score,Step(istep).C,...
        Step(istep).xs,Step(istep).ys,...
        ip,dA);
    print(ip,'-dpdf',sprintf('%sF%d.pdf',LabelRoot,ip));
    print(ip+1,'-dpdf',sprintf('%sF%d.pdf',LabelRoot,ip+1));
    
end
% for ip=[ip:-2:1]; figure(ip); end
    end
end


