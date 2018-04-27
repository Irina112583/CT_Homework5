fid=fopen('log_robot_2.txt');
s=textscan(fid,'%f %f %f %f %f','headerlines',23);
fclose(fid);
t=s{1};
d=s{2};
a=s{3};
l=s{4};
r=s{5};

y = zeros;
x1 = zeros;
lastx = 0.0;
lasty = 0.0;
lasta = 0.0;
last_time = t(1);

any = size(l);
for i=1:any
    dt = t(i) - last_time;
    left = 0.0471 * l(i);
    right = 0.0471 * r(i);
    if abs(left - right) < 10^-8
         curx = lastx + left * cos(lasta) * dt;
         cury = lasty + left * sin(lasta) * dt;
         curang = lasta;

    else
        rf = 7.5*((right + left) / ((right - left)));
        omegadt = dt * (right - left) / 15;

        iccx = lastx - rf * sin(lasta);
        iccy = lasty + rf * cos(lasta);

        curx = cos(omegadt) * (lastx - iccx) - sin(omegadt) * (lasty - iccy) + iccx;
        cury = sin(omegadt) * (lastx - iccx) + cos(omegadt) * (lasty - iccy) + iccy;
        curang = lasta + omegadt;
    end
    y(i) = -1*cury;
    x1(i) = curx;
    lastx = curx;
    lasty = cury;
    lasta = curang;
    last_time = t(i);
end
    
plot(x1, y)