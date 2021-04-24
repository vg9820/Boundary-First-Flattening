function A = Laplace(v,f)

Ea = sqrt(sum((v(f(:,2),:)-v(f(:,3),:)).^2,2));
Eb = sqrt(sum((v(f(:,3),:)-v(f(:,1),:)).^2,2));
Ec = sqrt(sum((v(f(:,1),:)-v(f(:,2),:)).^2,2));
cos_a = (Eb.^2 + Ec.^2 - Ea.^2)./(2*Eb.*Ec);
cos_b = (Ec.^2 + Ea.^2 - Eb.^2)./(2*Ec.*Ea);
cos_c = (Ea.^2 + Eb.^2 - Ec.^2)./(2*Ea.*Eb);
%每一个面中对应的cot
cot_a = cos_a./sqrt(1-cos_a.^2);
cot_b = cos_b./sqrt(1-cos_b.^2);
cot_c = cos_c./sqrt(1-cos_c.^2);
i = [f(:,1);f(:,2);f(:,3);f(:,1);f(:,1);f(:,2);f(:,2);f(:,3);f(:,3)];
j = [f(:,1);f(:,2);f(:,3);f(:,2);f(:,3);f(:,3);f(:,1);f(:,1);f(:,2)];
k = [1/2*(cot_b+cot_c);1/2*(cot_c+cot_a);1/2*(cot_a+cot_b);-1/2*cot_c;-1/2*cot_b;
    -1/2*cot_a;-1/2*cot_c;-1/2*cot_b;-1/2*cot_a];
A = sparse(i,j,k,size(v,1),size(v,1));

end

