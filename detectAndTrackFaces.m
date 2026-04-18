function [faceBoxes, trackedPoints, frame] = detectAndTrackFaces(frame)
    % Face detection and tracking using combination of detection and tracking
    persistent pointTracker initialized
    
    if isempty(initialized)
        initialized = false;
    end
    
    % Face detector
    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
    faceDetector.MinSize = [50 50];
    
    % Detect faces
    faceBoxes = step(faceDetector, frame);
    
    % If faces detected, initialize tracking
    if ~isempty(faceBoxes)
        % Extract points from face regions for tracking
        points = [];
        for i = 1:size(faceBoxes, 1)
            faceROI = faceBoxes(i,:);
            roiPoints = detectMinEigenFeatures(rgb2gray(frame), 'ROI', faceROI);
            points = [points; roiPoints.Location];
        end
        
        if ~isempty(points)
            pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
            initialize(pointTracker, points, frame);
            initialized = true;
        end
    end
    
    % If tracker is initialized, track points
    if initialized && ~isempty(pointTracker)
        [trackedPoints, validity] = step(pointTracker, frame);
        
        % Update face boxes based on tracked points
        if ~isempty(trackedPoints) && any(validity)
            validPoints = trackedPoints(validity, :);
            if size(validPoints, 1) > 10
                % Update face boxes based on point distribution
                minX = max(1, min(validPoints(:,1)) - 20);
                maxX = min(size(frame,2), max(validPoints(:,1)) + 20);
                minY = max(1, min(validPoints(:,2)) - 20);
                maxY = min(size(frame,1), max(validPoints(:,2)) + 20);
                faceBoxes = [minX, minY, maxX-minX, maxY-minY];
            end
        end
    else
        trackedPoints = [];
    end
    
    % Set points for next frame
    if initialized && ~isempty(pointTracker)
        setPoints(pointTracker, trackedPoints);
    end
end