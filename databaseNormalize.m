function databaseNormalize()
% DATABASENORMALIZE Batch normalizes all training images
% Processes all images in training_set file and saves normalized versions

% Define paths
sourceDir = 'training_set';
targetDir = 'normalized_training_set'; % target file where normalized images will be saved

fprintf('Starting batch normalization...\n');

% Get list of all people in the subfolders in the main training_set folder
people = dir(sourceDir);
people = people([people.isdir] & ~strcmp({people.name}, '.') & ~strcmp({people.name}, '..'));
% Get only the name of the people that belong to the file name by using 
% strcmp build-in function in Communication Toolbox

fprintf('Found %d people to process:\n', length(people));
for i = 1:length(people)
    fprintf('  - %s\n', people(i).name);
end

% Process each person
for p = 1:length(people)
    personName = people(p).name;
    fprintf('\nProcessing: %s\n', personName); 
    % first print the name of the person in the file
    
    % Create target directory
    personTargetDir = fullfile(targetDir, personName);
    % creates the folder Name if it doesn't already exist
    if ~exist(personTargetDir, 'dir')
        mkdir(personTargetDir);
    end
    
    % Get all images for this person
    imageFiles = dir(fullfile(sourceDir, personName, '*.jpg'));
    
    fprintf('  Found %d images\n', length(imageFiles));
    
    % Process each image
    successCount = 0;
    for i = 1:length(imageFiles)
        try
            % Read image
            imgPath = fullfile(sourceDir, personName, imageFiles(i).name);
            img = imread(imgPath); % get image data
            
            % Normalize image using normalizeImage functino build in
            % normalizeImage.m folder
            normalizedImg = normalizeImage(img);
            
            % Save normalized image
            % [path, name, ext] = fileparts(filename)
            [~, name, ext] = fileparts(imageFiles(i).name); % ~ means "ignore this output"
            % We don't need the path component because we already know the file location

            % Building the Output Path
            outputPath = fullfile(personTargetDir, [name, '_normalized', ext]);
            % Save the image in the given file directory
            imwrite(normalizedImg, outputPath);
            
            % Count how many images are normalized successfully
            successCount = successCount + 1;
            
            % Progress indicator gives progress feedback without spamming the console
            if mod(i, 10) == 0
                fprintf('    Processed %d/%d images\n', i, length(imageFiles));
            end
            
        catch ME
            fprintf('    Failed to process %s: %s\n', imageFiles(i).name, ME.message);
        end
    end
    
    fprintf('  Successfully normalized %d/%d images for %s\n', successCount, length(imageFiles), personName);
end

fprintf('\nBatch normalization complete!\n');
fprintf('Normalized images saved to: %s\n', targetDir);

end