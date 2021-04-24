clc;
clear;


[v, f, ~,~] = readObj('camelhead.obj');

%生成k
[Boundary, ~] = findBoundary(v, f);
Boundary = Boundary';
%给定scalar factor u 或者 测地曲率 k
u = ones(size(Boundary,1),1);
k = exterior_angle(Boundary,4);
%BFF
[x,y] = BFF(v,f,u,k,Boundary);
drawmesh(f, [x,y]);
