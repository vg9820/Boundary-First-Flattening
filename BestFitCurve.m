function gamma = BestFitCurve(L_,v,k,Boundary)

T = zeros(2,size(L_,1));
phi = 0;
T(:,1) = [1,0];
for j =1:size(L_,1)-1
    phi = phi + k(j+1);
    T(:,j+1) = [real(exp(1i*phi)),imag(exp(1i*phi))];
end
N = zeros(size(L_,1),size(L_,1));
for j = 2:size(L_,1)-2
    N(j,j) = 1/2*(norm(v(Boundary(j),:)-v(Boundary(j+1),:))+norm(v(Boundary(j-1),:)-v(Boundary(j),:)));
end
N(1,1) = 1/2*(norm(v(Boundary(1),:)-v(Boundary(2),:))+norm(v(Boundary(end),:)-v(Boundary(1),:)));
N(size(L_,1),size(L_,1)) = 1/2*(norm(v(Boundary(end),:)-v(Boundary(1),:))+norm(v(Boundary(end-1),:)-v(Boundary(end),:)));

L = L_ - N*T'*((T*N*T')\T)*L_;
gamma = zeros(size(L_,1),1);
gamma(1) = 0+0*1i;

for j =2:size(L_,1)
    gamma(j) = gamma(j-1) + L(j-1)*(T(1,j-1)+1i*T(2,j-1));
end

end

