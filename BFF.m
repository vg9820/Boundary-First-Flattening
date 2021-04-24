function [x,y] = BFF(v,f,g,k,Boundary)


%% º∆À„laplace matrix ∫Õ gauss curvature

[Phi,k1] = DiscreteCurvature(v,f,Boundary);
A = Laplace(v,f);


%% æÿ’Û∑÷øÈ
I = setdiff(1:size(v,1),Boundary);
B = Boundary;
Aii = A(I,I);
Aib = A(I,B);
Abb = A(B,B);


%% Neumann to Dirichlet
t0 = zeros(size(v,1),1);
t0(Boundary) = k1-k;
a = A\(Phi-t0);
a = a-a(1);
g = a(Boundary);

%% Dirichlet to Neeumann

%k = k1 - (Phi(B) - Aib'*(Aii\(Phi(I)-Aib*g))-Abb*g);



%% Best fit curve
L_ = zeros(size(Boundary,1),1); 
for i=1:(size(Boundary,1)-1)
    L_(i) = exp((g(i)+g(i+1))/2)*norm(v(Boundary(i),:)-v(Boundary(i+1),:));
end
L_(end) = exp((g(end)+g(1))/2)*norm(v(Boundary(end),:)-v(Boundary(1),:));

L = BestFitCurve(L_,v,k,Boundary);

%% Extend Curve
% harmonic extension on x
x = zeros(size(v,1),1);
x(B) = real(L);
x(I) = Aii\(-Aib*x(B));

% % harmonic extension on y
% y = zeros(size(v,1),1);
% y(B) = imag(L);
% y(I) = Aii\(-Aib*y(B));

% Hilbert transform on y
h = zeros(size(Boundary,1),1);
for i =2:size(Boundary,1)-1
    h(i) = 1/2*(x(Boundary(i+1))-x(Boundary(i-1)));
end
h(1) = 1/2*(x(Boundary(2))-x(Boundary(end)));
h(end) = 1/2*(x(Boundary(1))-x(Boundary(end-1)));
t1 = zeros(size(v,1),1);
t1(Boundary) = h;

y = A\t1;
y = y -y(1)+imag(L(1));







end

