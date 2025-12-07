function normalizedImg = normalizeImage(inputImg)
% NORMALIZEIMAGE Prepares an image for training classifier
% normalizedImg: processed 150x150 grayscale face image

% Convert to grayscale
grayImg = rgb2gray(inputImg);

% Creates a face detector using Viola-Jones algorithm build-in function in Computer Vision Toolbox
faceDetector = vision.CascadeObjectDetector(); 

% Detect faces using step build-in function in Computer Vision Toolbox
bbox = step(faceDetector, grayImg);

% Check if exactly one face was found
if size(bbox, 1) == 1
    % Extract the face region
    faceRegion = bbox(1, :);

    % Crop the face
    croppedFace = imcrop(grayImg, faceRegion);

    % Resize to 150x150 pixels
    normalizedImg = imresize(croppedFace, [150, 150]);

elseif isempty(bbox)
    % No face detected
    error('No face detected in the image');
else
    % Multiple faces detected
    error('Multiple faces detected in the image');
end

end


