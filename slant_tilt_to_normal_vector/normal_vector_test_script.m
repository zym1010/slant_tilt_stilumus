slantListD = [0, 45, -45, 70, -70];
tiltListD = [0, 45, 90, 135];

slantListR = slantListD .* (pi/180);
tiltListR = tiltListD .* (pi/180);

for slant = slantListR
    for tilt = tiltListR
        plot_plane_and_normal_vector(slant,tilt);
        fprintf('slant: %f, tilt: %f\n', slant*180/pi, tilt*180/pi);
        pause;
    end
end