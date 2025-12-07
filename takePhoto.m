function userImg = takePhoto()
% TAKEPHOTO Captures a single photo from webcam
% This will be the first step in verfying face app
% userImg = takePhoto()
% Returns: RGB image captured from webcam

fprintf('Initializing camera...\n');
cam = webcam;

fprintf('Look at the camera! Capturing photo in 3 seconds...\n');
pause(1);
fprintf('2...\n');
pause(1);
fprintf('1...\n');
pause(1);
fprintf('Capturing now!\n');

% Capture image
userImg = snapshot(cam);

% Clean up
clear cam;
fprintf('Photo captured successfully!\n');

end