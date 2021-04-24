function h = drawmesh(t, x, B, ecolor, color, varargin)

newplot = isempty( get(gca, 'child') ); % ~isempty( get(0,'CurrentFigure') ) && ~isempty( get(gcf, 'CurrentAxes') );

if nargin<3, B = []; end

if nargin<4, ecolor = 'k'; end
% ecolor = [1 1 1]*0.4; %'k';
    

if nargin<5, color = 'w'; end
% color = 'g'; %interp
% color = 'none';

if size(x, 1)==1 && size(x, 2)>1, warning('transpose x for display'); x = x.'; end
if ~isreal(x), x = [real(x) imag(x)]; end

% figure;

% drawfunc = @trisurf;
drawfunc = @trimesh;
dim = size(x,2);
if dim>3
    if range( x(:,4) )<1e-10, x(:,4) = 0; end
    h=drawfunc(t, x(:,1), x(:,2), x(:,3), x(:,4));
    view(3);
elseif dim>2
    h=drawfunc(t, x(:,1), x(:,2), x(:,3), zeros(size(x,1),1));
    if range( x(:,3) )>1e-10
        view(3);
    else
        view(2);
    end
else
    h=drawfunc(t, x(:,1), x(:,2), zeros(size(x,1),1));
    view(2);
end

set(h, 'FaceColor', color, 'EdgeColor', ecolor);

if nargin>5, set(h, varargin{:}); end

if nargin>2 && ~isempty(B)
    hold on;
    tB = [B B(1)];
    if dim<3
        hB = plot( x(tB, 1), x(tB, 2) );
    else
        hB = plot3( x(tB, 1), x(tB, 2), x(tB, 3));
    end
    
    linewidth = 1;
    set(hB, 'color', 'b', 'linewidth', linewidth+1);

    h(end+1) = hB;
end

%% note, don't mix LineSmoothing with face/edge alpha, may crash matlab
% set(h,'LineSmoothing','on');

if newplot
    axis equal;
    axis off;
end
% axis tight;

% camlight; lighting gouraud;