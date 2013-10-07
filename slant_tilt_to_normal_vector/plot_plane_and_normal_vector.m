function  plot_plane_and_normal_vector( slant, tilt )
%PLOT_PLANE_AND_NORMAL_VECTOR Summary of this function goes here
%   Detailed explanation goes here
[n_x,n_y,n_z] = angle_to_normal_vector(slant, tilt);


display([n_x n_y n_z]);

p1 = [-1,1,(n_x-n_y)/n_z];

p2 = [1,1,(-n_x-n_y)/n_z];

p3 = [1,-1,(-n_x+n_y)/n_z];

p4 = [-1,-1,(n_x+n_y)/n_z];

slant_computed = acos(n_z);

tilt_computed = 0;

if n_y == 0
    if n_x > 0
        tilt_computed = pi/2;
    elseif n_x < 0
        tilt_computed = -pi/2;
    end
else
    tilt_computed = atan(n_x/n_y);
end

display('slant computed:');
display(slant_computed/pi);
display('tilt computed:');
display(tilt_computed/pi);

P = [p1; p2; p3; p4];
clf;
hold on;
quiver3(0,0,0,n_x,n_y,n_z);

fill3(P(:,1),P(:,2),P(:,3),'b','FaceAlpha',0.4);
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
hold off;



end

