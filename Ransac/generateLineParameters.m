function [nx,ny,a] = generateLineParameters(point1, point2)

x1 = point1(1);
y1 = point1(2);
x2 = point2(1);
y2 = point2(2);

nx = y1 - y2;
ny = x2 - x1;
a = (x1-x2)*y1 + (y2-y1)*x1;

end