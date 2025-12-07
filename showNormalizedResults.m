% Display a sample of your normalized images
function showNormalizedResults()
    figure;
    
    % Get normalized images for Mohamed
    normFiles = dir('augmented_training_set/Mohamed/*.jpg');
    
    fprintf('Found %d normalized images for Mohamed\n', length(normFiles));
    
    % Display 9 random normalized images in a 3x3 grid
    for i = 1:min(9, length(normFiles))
        imgPath = fullfile('augmented_training_set/Mohamed', normFiles(i).name);
        img = imread(imgPath);
        
        subplot(3, 3, i);
        imshow(img);
        title(sprintf('Image %d', i));
    end
    
    sgtitle('Mohamed - Normalized Training Images (150x150)');
end