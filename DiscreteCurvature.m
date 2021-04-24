function [Phi,k1] = DiscreteCurvature(v,f,Boundary)

Phi = ones(size(v,1),1)*2*pi;
Ea = sqrt(sum((v(f(:,2),:)-v(f(:,3),:)).^2,2));
Eb = sqrt(sum((v(f(:,3),:)-v(f(:,1),:)).^2,2));
Ec = sqrt(sum((v(f(:,1),:)-v(f(:,2),:)).^2,2));
cos_a = (Eb.^2 + Ec.^2 - Ea.^2)./(2*Eb.*Ec);
cos_b = (Ec.^2 + Ea.^2 - Eb.^2)./(2*Ec.*Ea);
cos_c = (Ea.^2 + Eb.^2 - Ec.^2)./(2*Ea.*Eb);
theta_a = acos(cos_a);
theta_b = acos(cos_b);
theta_c = acos(cos_c);
i = [f(:,1);f(:,2);f(:,3)];
j = ones(3*size(f,1),1);
Phi = Phi- sparse(i,j,[theta_a;theta_b;theta_c],size(v,1),1);
% for i=1:size(f,1)
%     Ea = norm(v(f(i,2),:)-v(f(i,3),:));
%     Eb = norm(v(f(i,3),:)-v(f(i,1),:));
%     Ec = norm(v(f(i,1),:)-v(f(i,2),:));
%     cos_a = (Eb.^2 + Ec.^2 - Ea.^2)./(2*Eb.*Ec);
%     cos_b = (Ec.^2 + Ea.^2 - Eb.^2)./(2*Ec.*Ea);
%     cos_c = (Ea.^2 + Eb.^2 - Ec.^2)./(2*Ea.*Eb);
%     theta_a = acos(cos_a);
%     theta_b = acos(cos_b);
%     theta_c = acos(cos_c);
%     
%     Phi(f(i,1)) = Phi(f(i,1)) - theta_a;
%     Phi(f(i,2)) = Phi(f(i,2)) - theta_b;
%     Phi(f(i,3)) = Phi(f(i,3)) - theta_c;
% end

Phi(Boundary) = Phi(Boundary)-pi;
k1 = Phi(Boundary);
Phi(Boundary) = 0;
end

