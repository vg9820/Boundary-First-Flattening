function k = exterior_angle(Boundary,m)
%ӳ�䵽��������

n = size(Boundary,1);
k = zeros(n,1);
for i=1:m
    k(floor(i*n/m)) = 2*pi/m;
end

end

