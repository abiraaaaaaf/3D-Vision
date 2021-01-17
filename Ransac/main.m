P = 400;
sigma = 0.1; %for Gaussian noise
points=zeros(2,P);

% 1) Add points belonging to x=y line
temp=random('unif',-2,2,[1,200]);
points(1,1:200)=temp;
points(2,1:200)=temp;

% 2) Add random points in [-2,2]x[-2,2]
points(:,201:400)=random('unif',-2,2,[2,200]);

% 3) Add Gaussian noises
temp=random('norm',0,sigma,[2,400]);
points = points + temp;

% 4) Call RANSAC
[line,inliers]=ransac(points,1000,0.1,50);


