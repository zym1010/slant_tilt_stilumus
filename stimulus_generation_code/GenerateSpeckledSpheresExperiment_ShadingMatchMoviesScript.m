slantListD = [0, 45, -45, 70, -70];
tiltListD = [0, 45, 90, 135];

output_path = '/Users/yimengzh/Documents/Research/2013 Stimulus Generation/stimulus_result/output/';

for slantD = slantListD
    for tiltD = tiltListD
        GenerateSpeckledSpheresExperiment_ShadingMatchMoviesFunc(slantD,tiltD,output_path);
    end
end