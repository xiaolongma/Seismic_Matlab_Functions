% Matlab script stereonet.m
% To plot lines and planes in stereographic
% (equal-angle) projections
function [t1,r1,t2,r2] =PolarFocal(strike,dip,rake)
% top plot is the lower emisphere
% bottom is the upper

% Data in column 1 are strikes, and data in column 2 are dips
% of planes, with angles given in degrees
[strike2, dip2, ~] = AuxPlane(strike,dip,rake);

striketot=[strike strike2];
diptot=[dip dip2];
clear strike dip rake

strike =striketot*pi/180;
dip = diptot*pi/180;
num = length(strike);
% find cyclographic traces of planes and plot them
R = 1;

rake = 0:pi/180:pi;



subplot(223)
for i=1:num;

    plunge = asin(sin(dip(i)).*sin(rake));
    trend = strike(i) + atan2(cos(dip(i)).*sin(rake), cos(rake));
    rho = R.*tan(pi/4 - (plunge/2));
    t1(i,:)=trend;
    r1(i,:)=plunge;
    % polarb plots ccl from 3:00, so convert to cl from 12:00
    polar(trend,rho,'k');
    hold on
    
end

% north up
view([90 -90])



subplot(221)
for i=1:num;

    plunge = asin(sin(dip(i)).*sin(rake));
    trend = strike(i) - atan2(cos(dip(i)).*sin(rake), cos(rake));
    rho = R.*tan(pi/4 - (plunge/2));
    
    t2(i,:)=trend;
    r2(i,:)=plunge;
    % polarb plots ccl from 3:00, so convert to cl from 12:00
    polar(trend,rho,'k');
    hold on
    
end
view([90 -90])



function [strike, dip, rake] = AuxPlane(s1,d1,r1);
%function [strike, dip, rake] = AuxPlane(s1,d1,r1);
% Get Strike and dip of second plane, adapted from Andy Michael bothplanes.c
r2d = 180/pi;

z = (s1+90)/r2d;
z2 = d1/r2d;
z3 = r1/r2d;
%/* slick vector in plane 1 */
sl1 = -cos(z3).*cos(z)-sin(z3).*sin(z).*cos(z2);
sl2 = cos(z3).*sin(z)-sin(z3).*cos(z).*cos(z2);
sl3 = sin(z3).*sin(z2);
[strike, dip] = strikedip(sl2,sl1,sl3);

n1 = sin(z).*sin(z2);  %/* normal vector to plane 1 */
n2 = cos(z).*sin(z2);
n3 = cos(z2);
h1 = -sl2; %/* strike vector of plane 2 */
h2 = sl1;
%/* note h3=0 always so we leave it out */

z = h1.*n1 + h2.*n2;
z = z./sqrt(h1.*h1 + h2.*h2);
z = acos(z);

rake = zeros(size(strike));
j = find(sl3 > 0);
rake(j) = z(j)*r2d;
j = find(sl3 <= 0);
rake(j) = -z(j)*r2d;

function [strike, dip] = strikedip(n, e, u)
%function [strike, dip] = strikedip(n, e, u)
%       Finds strike and dip of plane given normal vector having components n, e, and u
%

% Adapted from Andy Michaels stridip.c

r2d = 180/pi;

j = find(u < 0);
n(j) = -n(j);
e(j) = -e(j);
u(j) = -u(j);

strike = atan2(e,n)*r2d;
strike = strike - 90;
while strike >= 360
        strike = strike - 360;
end
while strike < 0
        strike = strike + 360;
end

x = sqrt(n.^2 + e.^2);
dip = atan2(x,u)*r2d;