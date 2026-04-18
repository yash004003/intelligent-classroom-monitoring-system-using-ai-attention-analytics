function [attentionScore, gazeDirection, headPose] = calculateAttentionScore(faceROI, faceBox)
    % Calculate attention score based on eye gaze and head movement
    % Returns score from 0-100
    
    attentionScore = 0;
    gazeDirection = 'unknown';
    headPose = [0, 0, 0]; % yaw, pitch, roll
    
    if isempty(faceROI) || size(faceROI,1) < 50 || size(faceROI,2) < 50
        attentionScore = 0;
        return;
    end
    
    % Detect eyes
    eyeDetector = vision.CascadeObjectDetector('EyePairBig');
    eyes = step(eyeDetector, faceROI);
    
    if ~isempty(eyes)
        % Extract eye region
        eyeROI = imcrop(faceROI, eyes(1,:));
        
        % Convert to grayscale for eye analysis
        grayEye = rgb2gray(eyeROI);
        
        % Detect pupil using circular Hough transform
        [centers, radii] = imfindcircles(grayEye, [5 15], 'ObjectPolarity', 'dark');
        
        if ~isempty(centers)
            % Calculate gaze direction based on pupil position
            eyeWidth = size(grayEye, 2);
            pupilX = centers(1,1);
            
            % Gaze estimation (simplified)
            if pupilX < eyeWidth * 0.3
                gazeDirection = 'left';
                gazeScore = 0.4;
            elseif pupilX > eyeWidth * 0.7
                gazeDirection = 'right';
                gazeScore = 0.4;
            else
                gazeDirection = 'center';
                gazeScore = 0.8;
            end
        else
            gazeScore = 0.5;
        end
    else
        gazeScore = 0.3;
    end
    
    % Head pose estimation using facial landmarks (simplified)
    % Detect facial features
    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
    noseDetector = vision.CascadeObjectDetector('Nose');
    mouthDetector = vision.CascadeObjectDetector('Mouth');
    
    nose = step(noseDetector, faceROI);
    mouth = step(mouthDetector, faceROI);
    
    if ~isempty(nose) && ~isempty(mouth)
        % Estimate head pose based on nose and mouth positions
        noseY = nose(2);
        mouthY = mouth(2);
        faceHeight = size(faceROI, 1);
        
        % Head tilt estimation
        if noseY < faceHeight * 0.3
            headPose(2) = -15; % Looking up
            headScore = 0.7;
        elseif noseY > faceHeight * 0.6
            headPose(2) = 15; % Looking down
            headScore = 0.5;
        else
            headPose(2) = 0;
            headScore = 0.9;
        end
    else
        headScore = 0.4;
    end
    
    % Calculate final attention score
    % Weights: gaze 60%, head pose 40%
    attentionScore = (gazeScore * 0.6 + headScore * 0.4) * 100;
    
    % Clamp score between 0 and 100
    attentionScore = max(0, min(100, attentionScore));
end