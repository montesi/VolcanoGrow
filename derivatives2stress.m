function [sxx,syy,szz,sxy]=derivatives2stress(dxx,dyy,dxy,lam,mu,yf);

% stresses 
sxx=-yf*((lam+2*mu)*dxx + lam*dyy);%+rand(size(Xm))*0.1; 
syy=-yf*(lam*dxx +(lam+2*mu)*dyy); 
szz=-yf*lam*(dxx+dyy); 
sxy=-2*mu*yf*dxy;