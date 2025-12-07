% Test the normalization function
function testNormalization()
    % Take a single test photo
    cam = webcam;
    fprintf('Taking test photo in 3 seconds, Please look at the camera...\n');
    pause(3);
    testImg = snapshot(cam);
    clear cam;
    
    % Try to normalize it
    try
        normalized = normalizeImage(testImg);
        
        % Display results
        figure;
        subplot(1,2,1);
        imshow(testImg);
        title('Original Image');
        
        subplot(1,2,2);
        imshow(normalized);
        title('Normalized Face (150x150)');
        
        fprintf('Normalization successful!\n');
        
    catch ME
        fprintf('Normalization failed: %s\n', ME.message);
    end
end