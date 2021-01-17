
clc
clear all
close all

I1=imread('I1.jpg');
I2=imread('I2.jpg');
I3=imread('I3.jpg');

imshow(I1);
x_old = ginput(8); 
imshow(I2);
y_old = ginput(8);
imshow(I3);
z_old = ginput(8);

c2 = ones(8,1);  % second column to add 
x = [x_old c2];
y = [y_old c2];

z = [z_old c2];

n = length(x); % n = 2

if length(y) ~= n || length(z) ~= n 
    error('The number of points in the two images must be the same');
end

% Set up matrix A1,A2,A3 such that A*E(:) = 0, where E is the essential matrix.
% This system encodes the epipolar constraint

A1 = zeros(n, 9);
A2 = zeros(n, 9);
A3 = zeros(n, 9);
% 
for i = 1:n
    %A1(i,:) = kron(x(i,:),y(i,:));
    A1(i,:) = [y(i,1)*x(i,1) y(i,1)*x(i,2) y(i,1) ...
    y(i,2)*x(i,1) y(i,2)*x(i,2) y(i,2) ...
    x(i,1) x(i,2) 1];
end
A1

for i = 1:n
    %A2(i,:) = kron(y(i,:),z(i,:));
    A2(i,:) = [z(i,1)*y(i,1) z(i,1)*y(i,2) z(i,1) ...
    z(i,2)*y(i,1) z(i,2)*y(i,2) z(i,2) ...
    y(i,1) y(i,2) 1];
end
A2

for i = 1:n
    %A3(i,:) = kron(x(i,:),z(i,:));
    A3(i,:) = [z(i,1)*x(i,1) z(i,1)*x(i,2) z(i,1) ...
    z(i,2)*x(i,1) z(i,2)*x(i,2) z(i,2) ...
    x(i,1) x(i,2) 1];
end
A3
if rank(A1) < 8 || rank(A2) < 8  || rank(A3) < 8 
    error('Measurement matrix rank deficient')
end;
% The singular vector corresponding to the smallest singular value of A
% is the arg min_{norm(e) = 1} A * e, and is the LSE estimate of E(:)
[~, ~, V1] = svd(A1);
[U1 D1 V1] = svd(A1);
f1 = V1(:,end);
F1_unconditioned = reshape(f1,3,3)';
[U_1 D_1 V_1] = svd(F1_unconditioned);
D_1(1,1) = 1;
D_1(2,2) = 1;
D_1(end,end) = 0;
E1 = U_1*D_1*V_1';

% E1 = reshape(V1(:,9), 3, 3);
E1

[U2 D2 V2] = svd(A2);
f2 = V2(:,end);
F2_unconditioned = reshape(f2,3,3)';
[U_2 D_2 V_2] = svd(F2_unconditioned);
D_2(1,1) = 1;
D_2(2,2) = 1;
D_2(end,end) = 0;
E2 = U_2*D_2*V_2';

[U3 D3 V3] = svd(A3);
f3 = V3(:,end);
F3_unconditioned = reshape(f3,3,3)';
[U_3 D_3 V_3] = svd(F3_unconditioned);
D_3(1,1) = 1;
D_3(2,2) = 1;
D_3(end,end) = 0;
E3 = U_3*D_3*V_3';


[~, ~, V2] = svd(A2);
%E2 = reshape(V2(:,9), 3, 3);
E2
E_t = E2*E1
[~, ~, V3] = svd(A3);
%E3 = reshape(V3(:,9), 3, 3);
E3
% The two possible translation vectors are t and -t, where t is a unit
% vector in the null space of E
[~, ~, VE1] = svd(E1);
VE1
t1 = VE1(:, 3);

[~, ~, VE2] = svd(E2);
VE2
t2 = VE2(:, 3);
VE_t = VE2*VE1;
VE_t
t_t = t1+t2;

[~, ~, VE3] = svd(E3);
VE3
t_t
t3 = VE3(:, 3);
t3

% Two rotation matrix choices are found by solving the Procrustes problem
% for the rows of E and skew(t), and allowing for the ambiguity resulting
% from the sign of the null-space vectors (both E and skew(t) are rank 2).
% These two choices are independent of the sign of t, because both E and -E
% are essential matrices

tx1 = [0 -t1(3) t1(2); t1(3) 0 -t1(1); -t1(2) t1(1) 0];
tx2 = [0 -t2(3) t2(2); t2(3) 0 -t2(1); -t2(2) t2(1) 0];
tx3 = [0 -t3(3) t3(2); t3(3) 0 -t3(1); -t3(2) t3(1) 0];
tx1
tx2
tx3


[UR1, ~, VR1] = svd(E1 * tx1);
R1 = UR1 * VR1';
%R1 = R1 * det(R1);
[UR2, ~, VR2] = svd(E2 * tx2);
R2 = UR2 * VR2';
%R2 = R2 * det(R2);
[UR3, ~, VR3] = svd(E3 * tx3);
R3 = UR3 * VR3';
%R3 = R3 * det(R3);
R_t = R2*R1;
R_t
R3


% UR(:, 3) = -UR(:, 3);
% R2 = UR * VR';
% R2 = R2 * det(R2);

