function augmentTrainingData()
% AUGMENTTRAININGDATA Creates variations of training images to help the
% system detect the user image in different environments with different
% light, contrast, illumenation, and brightness conditions.


fprintf('Augmenting training data...\n');
sourceDir = 'normalized_training_set';
augmentedDir = 'augmented_training_set';

% Get all people names in file
people = dir(sourceDir);
people = people([people.isdir] & ~strcmp({people.name}, '.') & ~strcmp({people.name}, '..')); 
% Get only the name of the people that belong to the file name by using 
% strcmp build-in function in Communication Toolbox


for p = 1:length(people)
    personName = people(p).name;
    fprintf('Augmenting: %s\n', personName);
    
    % Create augmented directory
    personAugDir = fullfile(augmentedDir, personName);
    % creates the folder Name if it doesn't already exist
    if ~exist(personAugDir, 'dir') 
        mkdir(personAugDir); 
    end
    
    % Get original images from the specified directory 
    imageFiles = dir(fullfile(sourceDir, personName, '*_normalized.jpg'));
    
    % Read all the image's data in the given file
    for i = 1:length(imageFiles)
        imgPath = fullfile(sourceDir, personName, imageFiles(i).name);
        img = imread(imgPath);
        
        % Save original  
        [~, name, ext] = fileparts(imageFiles(i).name); 
        % [filepath,name,ext] = fileparts(filename)
        % MATLAB function returns the path name, file name, and extension for the specified file.
        outputPath = fullfile(personAugDir, [name, ext]);
        imwrite(img, outputPath);
        
        % Create variations:
        
        % 1. Brightness variations
        imgBright = imadjust(img, [0.05 0.95], []); 
        % MATLAB function maps the intensity values in grayscale image I to
        % new values in J

        outputPath = fullfile(personAugDir, [name, '_bright', ext]);
        imwrite(imgBright, outputPath);
        
        imgDark = imadjust(img, [0.0 0.7], []); % Darker
        outputPath = fullfile(personAugDir, [name, '_dark', ext]);
        imwrite(imgDark, outputPath);
        
        % 2. Contrast variations
        imgHighContrast = imadjust(img, [0.3 0.7], []); % Higher contrast
        outputPath = fullfile(personAugDir, [name, '_highcontrast', ext]);
        imwrite(imgHighContrast, outputPath);
        
        % 3. Slight rotations 
        imgRotate1 = imrotate(img, 5, 'crop'); % 5 degrees
        % MATLAB function rotates image I by angle degrees in 
        % a counterclockwise direction around its center point Syntax.

        outputPath = fullfile(personAugDir, [name, '_rotate5', ext]);
        imwrite(imgRotate1, outputPath);
        
        imgRotate2 = imrotate(img, -5, 'crop'); % -5 degrees
        outputPath = fullfile(personAugDir, [name, '_rotate-5', ext]);
        imwrite(imgRotate2, outputPath);
        
        % 4. Gaussian noise for poor quality images
        imgNoise = imnoise(img, 'gaussian', 0, 0.01);
        % MATLAB function adds zero-mean, Gaussian white noise
        %  with variance of 0.01 to grayscale image 
        outputPath = fullfile(personAugDir, [name, '_noise', ext]);
        imwrite(imgNoise, outputPath);
    end
    
    fprintf('  Created %d augmented images from %d originals\n', ...
            length(imageFiles)*6, length(imageFiles));
end

fprintf('Data augmentation complete!\n');

end