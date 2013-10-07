% Scales matrix so all elements are between 0 and 1
function I = normlize(I, newmin, newmax)
I = I - min(I(:));
I = I/max(I(:));

% I = I/(2*max([abs(min(I(:))), abs(max(I(:)))])) + 0.5;

if (nargin == 3)
    I = I*(newmax - newmin) + newmin;
end
