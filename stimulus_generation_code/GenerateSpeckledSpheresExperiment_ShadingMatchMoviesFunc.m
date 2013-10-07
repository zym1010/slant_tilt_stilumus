
function GenerateSpeckledSpheresExperiment_ShadingMatchMoviesFunc(slantD,tiltD,fn_path)

slant = slantD/180*pi;
tilt = tiltD/180*pi;

% pixel_size = (32.9/700);    % cm, with emitter on, for 800x600 resolution
pixel_size = 32.9 / 700;%(31.75/1200);    % cm, with emitter on, for 1200x1600 resolution
monitor_distance = 57;
pixel_visual_angle = (180/pi)*2*atan((pixel_size/2)/monitor_distance);
dotsize_visual_angle = 2*pixel_visual_angle;    % Don't forget, each dot in the DRDS is 2x2 pixels.
% distance_to_spheres = monitor_distance; % Assumes sphere are at zero disparity

T = 3.8;    % cm of eye separation (baseline)

% Bubble properties
bubble_diameter = 3.0 * 2; % used to be 3 degrees, I have to double it to make it be correct, poplinre
bubble_diameter_ndots   = ceil(bubble_diameter / dotsize_visual_angle);
bubble_diameter_npixels = 2 * bubble_diameter_ndots;
% margin_multiplier = 0.5;    % Margins between bubbles are M times their diameters

%---------------------------------------------------
% Generate the 4 shading patterns
% Color parameters
% LA_contrast = 0.75;
% background_color = 0.5;

% Amount of Stereo
n_seperations_r =5;
eye_separation_mags = (n_seperations_r/2)*(-n_seperations_r:n_seperations_r)/n_seperations_r;
n_eye_mags = length(eye_separation_mags);

%---------------------------------------------------
% Generate random dots
dot_parameters.dotsize_x = 3;
dot_parameters.dotsize_y = 1.5;


% Generate the 3D surface
% [X,Y] = meshgrid(1:bubble_diameter_npixels, 1:bubble_diameter_ndots);
% X = X - mean(mean(X));
% Y = Y - mean(mean(Y));
% R2 = ((X*pixel_visual_angle).^2 + (Y*dotsize_visual_angle).^2);
% r = bubble_diameter/2;
% concave_surface = sqrt(max(0, r^2 - R2)); %_vex
% %concave_surface = (r^2 - R2) >= 0; %_dis
% convex_surface  = -concave_surface;
% w = size(concave_surface,2);
% h = size(concave_surface,1);

% try a 45 slant, 0 tilt first...

[nx,ny,nz]=angle_to_normal_vector(slant,tilt);

[X,Y] = meshgrid(1:bubble_diameter_npixels, 1:bubble_diameter_ndots);
X = X - mean(mean(X));
Y = Y - mean(mean(Y));

concave_surface = (-X*pixel_visual_angle*nx - Y*dotsize_visual_angle*ny)/nz;
%concave_surface = (r^2 - R2) >= 0; %_dis
w = size(concave_surface,2);
h = size(concave_surface,1);


for repeat = 1:1
    % Generate the random dot images
    left_images  = zeros(h, w, n_eye_mags);
    right_images = zeros(h, w, n_eye_mags);
    for di = 1:n_eye_mags
        for f = 1:12
            dot_density = 0.25;
            im_w = bubble_diameter_npixels;
            im_h = bubble_diameter_ndots;
            n_sdots = round(dot_density * (im_w * im_h) / (dot_parameters.dotsize_x * dot_parameters.dotsize_y));
            sdot_locations = rand(n_sdots, 2);
            sdot_locations(:,1) = sdot_locations(:,1) * im_h;	    % y coord
            sdot_locations(:,2) = sdot_locations(:,2) * im_w;	% x coord, monocular image
            sdot_colors = 2*(rand(n_sdots,1) < 0.5) - 1;
            dot_parameters.central_dot_pattern = [sdot_locations, sdot_colors];

            [im_L, im_R, ~] = MakeStereogram_Sparse(eye_separation_mags(di)*concave_surface, monitor_distance, T, pixel_size, dot_parameters);
            left_images(:,:,di)  = im_L;
            right_images(:,:,di) = im_R;

            max_albedo = 0.75;
            min_albedo = 0.05; %changed from 0.25, rpoplin
            left_images  = normalize(left_images,  min_albedo, max_albedo);
            right_images = normalize(right_images, min_albedo, max_albedo);

%             dbl = floor(1:0.5:(bubble_diameter_ndots+0.5));
%             sphere_mask = R2 > r^2;

%             im_L = left_images(:,:,di) .* shading_patterns(:,dbl,li,di,1);
%             im_R = right_images(:,:,di) .* shading_patterns(:,dbl,li,di,2);
            
            im_L = left_images(:,:,di);
            im_R = right_images(:,:,di);
            % Trim dots that do not lie within the sphere
%             im_L(sphere_mask) = LA_contrast*background_color;
%             im_R(sphere_mask) = LA_contrast*background_color;

            % PPT stands for psychophysics popout test
            fn_base = sprintf('S%+dT%+dD%02dR%02d',round(slantD),round(tiltD),di,repeat);    % Speckled Popout 7
            fn_L = [fn_base, 'L.ctx'];
            fn_R = [fn_base, 'R.ctx'];
            depth = 8;
            
            if (f == 1)
                savecx_movie_firstframe([fn_path, fn_L],  '', [depth, w, h, 12], round(128 + 127*im_L));
                savecx_movie_firstframe([fn_path, fn_R], '', [depth, w, h, 12], round(128 + 127*im_R));
            else
                savecx_movie_succframe([fn_path, fn_L],   '', [depth, w, h, 12], round(128 + 127*im_L));
                savecx_movie_succframe([fn_path, fn_R],  '', [depth, w, h, 12], round(128 + 127*im_R));
            end
        end;
    end;
end;

end







