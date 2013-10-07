function [ n_x, n_y, n_z ] = angle_to_normal_vector( slant, tilt )
%ANGLE_TO_NORMAL_VECTOR convert slant/tilt to 3 components of normal vector
%   slant/tilt are in radius.
%   the slant is the angle between normal vector and z.
%   the tilt is the angle of the vector's rotation around z clockwisely
%   (with z positive pointing at the eye)
%   y is vertical, x is horizontal, and z protrudes out of the paper,
%   forming a right-handedness system.

n_z = cos(slant);
n_y = sin(slant)*cos(tilt);
n_x = sin(slant)*sin(tilt);

end

