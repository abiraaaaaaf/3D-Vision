
clc
clear all
close all

I1=imread('I1.jpg');
I4=imread('I4.jpg');

[m4,n4,l4]=size(I4);
size(I4)
[m1,n1,l1]=size(I1);
size(I1)


x1 = [650.5000;594.5000;1.9625e+03;1.7745e+03];
x2 = [5.7500;7.2500;788.7500;788.7500];
x3 = [1.0465e+03;1.0585e+03;1.3665e+03;1.3425e+03];
y1 = [1.7625e+03;3.4385e+03;3.3985e+03;1.7345e+03];
y2 = [9.7500;1.2713e+03;1.2698e+03;6.7500];
y3 = [534.5000;862.5000;866.5000;534.5000];


HH = [-x1(1),-y1(1),-1,0,0,0,x1(1)*x2(1),y1(1)*x2(1),x2(1);
   0,0,0,-x1(1),-y1(1),-1,x1(1)*y2(1),y1(1)*y2(1),y2(1);
   -x1(2),-y1(2),-1,0,0,0,x1(2)*x2(2),y1(2)*x2(2),x2(2);
   0,0,0,-x1(2),-y1(2),-1,x1(2)*y2(2),y1(2)*y2(2),y2(2);
   -x1(3),-y1(3),-1,0,0,0,x1(3)*x2(3),y1(3)*x2(3),x2(3);
   0,0,0,-x1(3),-y1(3),-1,x1(3)*y2(3),y1(3)*y2(3),y2(3);
   -x1(4),-y1(4),-1,0,0,0,x1(4)*x2(4),y1(4)*x2(4),x2(4);
   0,0,0,-x1(4),-y1(4),-1,x1(4)*y2(4),y1(4)*y2(4),y2(4);
   ];

[~, ~, V] = svd(HH);
Homography=V(:,end);
Homography1=[Homography(1),Homography(2),Homography(3);Homography(4),Homography(5),Homography(6);Homography(7), Homography(8),Homography(9)];
O1=I1;
mask = poly2mask(y1,x1,m1,n1);
for i=1:size(mask,1)
    for j=1:size(mask,2)
        if mask(i,j)==1
                a=[i;j;1];
                bpr = Homography1*a;
                bpr=bpr(:)./bpr(3);
                bpr=round(bpr); 
                if( bpr(1)>0 && bpr(2)>0)
                    O1(i,j,:)=I4(bpr(1),bpr(2),:);
                end
        end
    end
end

HH = [-x3(1),-y3(1),-1,0,0,0,x3(1)*x2(1),y3(1)*x2(1),x2(1);
   0,0,0,-x3(1),-y3(1),-1,x3(1)*y2(1),y3(1)*y2(1),y2(1);
   -x3(2),-y3(2),-1,0,0,0,x3(2)*x2(2),y3(2)*x2(2),x2(2);
   0,0,0,-x3(2),-y3(2),-1,x3(2)*y2(2),y3(2)*y2(2),y2(2);
   -x3(3),-y3(3),-1,0,0,0,x3(3)*x2(3),y3(3)*x2(3),x2(3);
   0,0,0,-x3(3),-y3(3),-1,x3(3)*y2(3),y3(3)*y2(3),y2(3);
   -x3(4),-y3(4),-1,0,0,0,x3(4)*x2(4),y3(4)*x2(4),x2(4);
   0,0,0,-x3(4),-y3(4),-1,x3(4)*y2(4),y3(4)*y2(4),y2(4);
   ];

[~, ~, V] = svd(HH);
Homography=V(:,end);
Homography1=[Homography(1),Homography(2),Homography(3);Homography(4),Homography(5),Homography(6);Homography(7),Homography(8),Homography(9)];

O2=I1;

mask = poly2mask(y3,x3,m1,n1);
for i=1:size(mask,1)
    for j=1:size(mask,2)
        if mask(i,j)==1
                a=[i;j;1];
                bpr = Homography1*a;
                bpr=bpr(:)./bpr(3);
                bpr=round(bpr); 
                if( bpr(1)>0 && bpr(2)>0)
                    O2(i,j,:)=I4(bpr(1),bpr(2),:);
                end
        end
    end
end

figure,imshow(uint8(O1));
figure,imshow(uint8(O2));
