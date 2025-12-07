function [userName, probability, accessGranted, status, capturedImg] = verifyFace()
% VERIFYFACE Main face verification function
% [userName, probability, accessGranted] = verifyFace()
% Returns:
%   - userName: Predicted person name
%   - probability: Confidence score (0-1)
%   - accessGranted: true/false
%   - status: success, no_face, multi_faces, error
%   - captureImg: saved the image that will be captured


% Load our saved trained classifier file "AI model"
fprintf('Loading face classifier...\n');
load('faceClassifier.mat', 'faceClassifier');

% Take a photo of the user
fprintf('Capturing user photo...\n');
capturedImg = takePhoto();

% To verify the user face - after the photo is taken - the system will go through all the same steps in
% the previous files
try
    % First: Normalize the image (detect face, crop, resize)
    fprintf('Processing image...\n');
    normalizedImg = normalizeImage(capturedImg);
    
    % Second: Extract HOG features
    fprintf('Extracting HOG features...\n');
    userFeatures = extractHOGFeatures(normalizedImg);
    
    % Third: Ensure features is a numeric matrix, not a cell
    if iscell(userFeatures)
        userFeatures = cell2mat(userFeatures);
    end

    % Third: Classify the face
    fprintf('Verifying face...\n');
    [userName, scores] = predict(faceClassifier, userFeatures);
    % predict() Predict labels using classification tree model
    % This MATLAB function returns a vector of predicted class labels for the predictor data in the table or matrix X,
    % based on the trained classification tree tree. 
    % userName: Predicted person ('Mohamed')
    % scores: confidence scores for each person

    
    % Convert scores to probability
    expScores = exp(scores);
    probabilities = expScores ./ sum(expScores, 2);
    probability = max(probabilities);
    % Formula explanation:
    % This is called "softmax" conversion - it turns raw scores into probabilities that sum to 100%.
    % let's assume [2.1, -1.5] is our classifier scores
    % exp(scores) - Exponential function: [exp(2.1), exp(-1.5)] = [8.17, 0.22]
    % sum(exp(scores)) - Sum: 8.17 + 0.22 = 8.39
    % exp(scores) ./ sum(exp(scores)) - Divide: [8.17/8.39, 0.22/8.39] = [0.97, 0.03]
    % max(...) - will ake highest probability: 0.97 (97%)
    
    % Decision threshold
    threshold = 0.65;
    
    % Access will only be granted if the threshold is greater than 0.65
    accessGranted = probability >= threshold;
    
    fprintf('Verification complete:\n');
    fprintf('  User: %s\n', userName{1});  % Handle cell array outpu
    
    fprintf('  Confidence: %.2f%%\n', probability * 100);
    fprintf('  Access: %s\n', string(accessGranted));
    
    status = 'success';
    
catch ME
    fprintf('Verification failed: %s\n', ME.message);
    
    % Determine the specific type of error
    if contains(ME.message, 'No face detected')
        status = 'no_face';
    elseif contains(ME.message, 'Multiple faces detected') 
        status = 'multiple_faces';
    else
        status = 'error';
    end
    
    userName = {'Unknown'};
    probability = 0;
    accessGranted = false;
end

end