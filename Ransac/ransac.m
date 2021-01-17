function [ransacline,inliers]=ransac(points,iter,thr,mininlier)

points = points';
[numberPoints, c]=size(points);
inliers=zeros([numberPoints,1],'uint8');
ransacline=[0,0,0];
largestInliers=0;
numGoodFit=0;

% Set if you want to plot all iterations
plotAllResults=false;

for i=1:iter
randIndices=ceil(rand(2,1)*numberPoints);
while(randIndices(1)==randIndices(2))
randIndices=ceil(rand(2,1)*numberPoints);
end
point1=points(randIndices(1),:);
point2=points(randIndices(2),:);


% "n=[nx,ny]" is the normal vector to the line and "a" is the level of point1 and point2.
[nx,ny,a]=generateLineParameters(point1, point2);

%Test again line
dist=abs(points*[nx;ny]-a);
IterationInliers=dist<thr;
numInliers=sum(IterationInliers);
if(numInliers >= mininlier)
numGoodFit=numGoodFit+1;

end
if(numInliers>largestInliers)
largestInliers=numInliers;
ransacline=[nx,ny,a];
inliers=IterationInliers;
end

if(plotAllResults || i<6)
iterationName = ...
sprintf('Ransac Iteration %d. Number of Inlieres %d / %d ', ...
i,numInliers,numberPoints);
fig=figure('Name',iterationName,'NumberTitle','off'),

inliersIndices=find(IterationInliers);
outliersIndices=find(~IterationInliers);

plot(points(outliersIndices,1), points(outliersIndices,2),'o',...
'MarkerFaceColor','g','MarkerEdgeColor','g','MarkerSize',4);
hold on,
plot(points(inliersIndices,1),points(inliersIndices,2),'o',...
'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',4);
hold on,

Xcoord=[point1(1),point2(1)];
Ycoord=[point1(2),point2(2)];
line(Xcoord,Ycoord);
% [lX,lY]=findLineExtremaInBox(nx,ny,a);
% line(lX,lY);

legend('Outliers','Inliers')
title(iterationName)
axis([-2 2 -2 2])
set(gca,'XTick',-2:0.25:2)
set(gca,'YTick',-2:0.25:2)

outputName=sprintf('ransac%02d',i);
print(fig,'-dpng',outputName);
end
end

fprintf('Number of iterartion with a good fit : %d / %d \n',numGoodFit,iter);
fprintf('Largest number of inliers : %d / %d \n',largestInliers,numberPoints);

%Plot Best Result

plotName=sprintf('Ransac Best Result. Number of Inlieres %d / %d ',...
largestInliers,numberPoints);
fig=figure('Name',plotName,'NumberTitle','off'),

inliersIndices=find(inliers);
outliersIndices=find(~inliers);

plot(points(outliersIndices,1),points(outliersIndices,2),'o',...
'MarkerFaceColor','g','MarkerEdgeColor','g','MarkerSize',4);
hold on,
plot(points(inliersIndices,1),points(inliersIndices,2),'o',...
'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',4);
hold on,

% [lX,lY]=findLineExtremaInBox(ransacline(1),ransacline(2),ransacline(3));
% line(lX,lY);

point1=points(randIndices(1),:);
point2=points(randIndices(2),:);

Xcoord=[point1(1),point2(1)];
Ycoord=[point1(2),point2(2)];
line(Xcoord,Ycoord);

legend('Outliers','Inliers')
title(plotName)
axis([-2 2 -2 2])
set(gca,'XTick',-2:0.25:2)
set(gca,'YTick',-2:0.25:2)

print(fig,'-dpng','ransacBest');

end