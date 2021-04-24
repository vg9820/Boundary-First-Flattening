clc;
clear;


[v, f, ~,~] = readObj('camelhead.obj');

%����k
[Boundary, ~] = findBoundary(v, f);
Boundary = Boundary';
%����scalar factor u ���� ������� k
u = ones(size(Boundary,1),1);
k = exterior_angle(Boundary,4);
%BFF
[x,y] = BFF(v,f,u,k,Boundary);
drawmesh(f, [x,y]);
