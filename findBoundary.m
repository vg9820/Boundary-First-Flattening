function [B, H]=findBoundary(x, p)

% function B=findBoundary(x, p)
%
% Identify boundary vertices of a given mesh in CW order 
%      (startpoint is arbitrary)
%
% Input parameters: 
%
% x - mesh geometry
% p - mesh connectivity (list of triangle/polygon faces)
%
% Output parameters:
%
% B - list of boundary vertex ID's in CCW order
%

if ~isreal(x), x = [real(x) imag(x)]; end

polyDim = size(p, 2);
nf = size(p, 1);
nv = size(x, 1);

if any( any( sparse(p, p(:, [2:end 1]), ones(nf, polyDim), nv, nv)>1 ) )
    warning('inconsistent triangulation/polygon partition!');
end

VV2F = sparse(p, p(:, [2:end 1]), repmat(1:nf, 1, polyDim), nv, nv);
VV2F( VV2F & VV2F' ) = 0;

H = {};
while true
    [e1, e2] = find(VV2F,1);
    if isempty(e1), break; end

    VV2F(e1, e2) = 0;
    VV2Ft = VV2F';
    tmpB = [e1 e2];

    while tmpB(end)~=tmpB(1)
%         e2 = find( VV2F(tmpB(end),:), 1 );
        e2 = find( VV2Ft(:, tmpB(end)), 1 );   % faster to access columns in matlab sparse matrix
        if isempty(e2)
            warning('incomplete boundary!');
%             VV2F = [];
            VV2Ft = [];
            break;
        end

%         VV2F(tmpB(end), e2) = 0;
        VV2Ft(e2, tmpB(end)) = 0;
        tmpB(end+1) = e2;
    end

    VV2F = VV2Ft';
    H{end+1} = tmpB;
end

if isempty(H), H = { [] }; end

if size(x,2)>2 && range(x(:,3))>eps
% naive way, holes with max number of vertices is the Boundary
    [~, Bid] = max( cellfun(@numel, H) );
else
    fPolyArea = @(x) sum( x(:,1).*x([2:end 1],2) - x([2:end 1],1).*x(:,2) );
    area2s = cellfun( @(h) fPolyArea( x(h,:) ), H );
    [~, Bid] = max(abs(area2s));
end

H = cellfun( @(x) x(1:end-1), H, 'UniformOutput', false );

B = H{Bid};
H = H( setdiff(1:numel(H), Bid) );
