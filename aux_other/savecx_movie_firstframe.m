% Save the first frame of a movie to a cortex file
function savecx_movie_firstframe(filename, notes, dmns, imgmtx)

% SAVECX(filename, notes, dmns, imgmtx)
%       save the image files as a cortex readable image file.
%       filename,       path should be included
%       notes,          maximum 10 characters
%       dmns=[depth, x, y, nframes], in which
%               depth,          bitmap depth (1,2,4, or 8)
%               x,              x dimension of the image
%               y,              y dimension of the image
%               nframes,        number of frames in the movie (1's based)
%       imgmtx,    An image, will be rounded to the range of 0-255.
%
% By Yi-Xiong Zhou on 4-9-96
% Modified by Brian Potetz, for saving movies incrementally. (6/23/04)
%

% Truncate/extend the "notes" field to 10 characters
if size(notes,2)>10
    notes = notes([1:10]);
else
    notes = [notes, zeros(1,10-size(notes,2))];
end

% Get image dimensions
x=dmns(2); y=dmns(3); nf=dmns(4);
imx = size(imgmtx,2);
imy = size(imgmtx,1);

% Make sure image is all proper.
imgmtx = round(imgmtx);
imgmtx = imgmtx'; 
if (size(imgmtx,1) ~= x) | (size(imgmtx,2) ~= y)
    disp('ERROR: image size does not match specified image dimensions');
    disp(sprintf('image was %d x %d (width x height), claimed to be %d x %d', size(imgmtx,1), size(imgmtx,2), x, y))
    return;
end

% Cortex counts frames starting at zero.
% This routine expects the user to count the frames starting at one, so
%  we translate the number of frames to zero-based here.
dmns(4) = max(0, dmns(4)-1);

fid = fopen(filename, 'w');

[fn, pp, ar]=fopen(fid);
if strcmp(ar, 'ieee-be')
	tmp=floor(dmns/256);
	dmns=(dmns-tmp*256)*256+tmp;
elseif ~strcmp(ar, 'ieee-le') && ~strcmp(ar, 'ieee-le.l64')
	disp('unknow file format. find out the byte switch requirement!')
	disp('use unswitch as default') 
end
% Write out first header and the first frame
fwrite(fid, notes, 'char');
fwrite(fid, dmns, 'uint16');
if i==1, dmns(4)=0; end
fwrite(fid, imgmtx, 'uchar');
fclose(fid);




