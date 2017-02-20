function [out]=KEI(x);
out=imag(besselk(0,x*(1+i)/sqrt(2)));
out(find(x==0))=-pi/4;
% if x==0
%     out=-pi/4;
% else
%     out=imag(besselk(0,x*(1+i)/sqrt(2)));
% %     kei=@(z)imag(besselk(0,z*(1+i)/sqrt(2)))
% end
