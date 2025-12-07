function createFaceClassifier()
% CREATEFACECLASSIFIER Trains a face recognition classifier
% Uses HOG features and SVM to create a face recognition model

fprintf('Starting face classifier training...\n');

% Define paths
normalizedDir = 'augmented_training_set';

% Get list of people (subfolders)
people = dir(normalizedDir);
people = people([people.isdir] & ~strcmp({people.name}, '.') & ~strcmp({people.name}, '..'));
% Get only the name of the people that belong to the file name by using 
% strcmp build-in function in Communication Toolbox

fprintf('Found %d people to train:\n', length(people));
for i = 1:length(people)
    fprintf('  - %s\n', people(i).name);
end

% Initialize variables for training data
trainingFeatures = [];
trainingLabels = [];

fprintf('\nExtracting HOG features...\n');

% Process each person
for p = 1:length(people)
    personName = people(p).name;
    fprintf('Processing: %s... ', personName);
    
    % Get all normalized images for this person
    imageFiles = dir(fullfile(normalizedDir, personName, '*.jpg'));
    
    % Extract features from each image
    for i = 1:length(imageFiles)
        % Read the normalized image
        imgPath = fullfile(normalizedDir, personName, imageFiles(i).name);
        img = imread(imgPath);
        
        % Extract HOG features "Histogram of Oriented Gradients"
        hogFeatures = extractHOGFeatures(img);
        % MATLAB function returns extracted HOG features from a truecolor or grayscale input image
        % Computer Vision Toolbox.

        %  Store all the HOG feature vectors in vector and The corresponding person names
        trainingFeatures = [trainingFeatures; hogFeatures]; 
        trainingLabels = [trainingLabels; {personName}]; 
    end
    
    fprintf('%d images processed\n', length(imageFiles));
end

fprintf('\nTraining SVM classifier...\n');

% Train multiclass SVM classifier (Support Vector Machine)
faceClassifier = fitcecoc(trainingFeatures, trainingLabels); 
% fitcecoc = "Fit Error-Correcting Output Codes" in Statistics and Machine Learning Toolbox.
% MATLAB function returns a full, trained, multiclass, error-correcting output codes (ECOC) model 
% using the predictors in table Tbl and the class labels in Tbl.
% After this step the machine will be able to distinguish between different people

% Save the trained classifier, so we can load it later without retraining
save('faceClassifier.mat', 'faceClassifier');
fprintf('Classifier saved as faceClassifier.mat\n');

% Display training summary
fprintf('\n=== TRAINING COMPLETE ===\n');
fprintf('Total training images: %d\n', size(trainingFeatures, 1));
fprintf('Feature vector length: %d\n', size(trainingFeatures, 2));
fprintf('People trained: %d\n', length(people));
fprintf('Classifier type: %s\n', class(faceClassifier));

end