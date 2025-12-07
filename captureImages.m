function captureImages(username, numImages) 
% CAPTUREIMAGE for  training classifier
%   username: name of the person (Ahmed or Mohamed)
%   numImages: we assuem that 50 images are enought for training data



% Create directory file if it doesn't exist
trainingDir = fullfile('training_set', username); %  builds a full file specification from the specified folder and file names
% creates the folder Name if it doesn't already exist
if ~exist(trainingDir, 'dir')
    mkdir(trainingDir); 
    fprintf('Created directory: %s\n', trainingDir);
end

% Initialize camera
fprintf('Initializing camera...\n');
cam = webcam;

    fprintf('Starting image capture for %s...\n', username);
    fprintf('Get ready! Starting in 2 seconds...\n');
    pause(2);
    
    % Countdown display to demostarte progress
    for i = 1:numImages
        fprintf('Capturing image %d/%d in ', i, numImages);
        fprintf('\n');
        
        % Capture image
        img = snapshot(cam);
        
        % Save image
        filename = sprintf('%s_%04d.jpg', username, i); % specify the name and type of image
        filepath = fullfile(trainingDir, filename);
        imwrite(img, filepath); % Save image accordingly
        
        pause(0.5);
       
    end
    
    fprintf('Successfully captured %d images for %s \n', numImages, username);

% Clean up and free up memory
clear cam;
fprintf('Image capture complete!\n');

end