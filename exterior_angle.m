function k = exterior_angle(Boundary,m)
%Ó³Éäµ½¾ØĞÎÇøÓò

n = size(Boundary,1);
k = zeros(n,1);
for i=1:m
    k(floor(i*n/m)) = 2*pi/m;
end

end

