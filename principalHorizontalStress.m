
function [V,D] = principalHorizontalStress(xx,yy,xy);

ni=size(xx,1); nj=size(xx,2);
V=NaN(ni,nj,2,2);
D=NaN(ni,nj,2);
for i=1:size(xx,1);
    for j=1:size(xx,2);
        T=[xx(i,j),xy(i,j);xy(i,j),yy(i,j)];
%         [V(i,j,:,:),d]=eigs(T); %eig values & vectors
%         D(i,j,:)=diag(sort(d));      % keeping eig values for every point in field
        [Vi,Di]=eig(T); %eig values & vectors
        [d,IX]=sort(diag(Di));
        D(i,j,1)=d(1);      % keeping eig values for every point in field
        D(i,j,2)=d(2);      % keeping eig values for every point in field
        V(i,j,:,:)=Vi(IX,IX);
    end;
end
 

% tensor=zeros(3 , 3, numel(xx));
% vector=zeros(3,numel(xx));
% values=zeros(numel(xx),1);
% 
% for i=1:numel(xx)
%     tensor(:,:,i)=[xx(i) , xy(i) , xz(i);
%                    xy(i) , yy(i) , yz(i);
%                    xz(i) , yz(i)     , zz(i)];
%     
%                if norm(tensor(:,:,i))~=0
%                 [vector(:,i), values(i)]=eigs(tensor(:,:,i),1,'SM');
%                end  
%           clc
%           disp([num2str(i/numel(xx)*100) '% complete']);
% end
% 
% xdir=reshape(-vector(2,:),size(xx));
% ydir=reshape(vector(1,:),size(xx));
% figure(8);
% quiver(Xm,Ym,xdir,ydir);
% end
% 
