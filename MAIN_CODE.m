 
 

%% Initialize System Parameters
% Camera setup
camera = webcam(1); % Use first available webcam
resolution = [640 480];
camera.Resolution = '640x480';

% Create video player for display
videoPlayer = vision.VideoPlayer('Position', [100 100 800 600]);

% Initialize face detector
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
faceDetector.MinSize = [50 50];
faceDetector.MaxSize = [200 200];

% Initialize eye detector
eyeDetector = vision.CascadeObjectDetector('EyePairBig');

% Initialize point tracker for tracking
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Storage variables
studentData = [];
frameCount = 0;
attentionHistory = [];
maxStudents = 30;

% Create figure for dashboard
dashboardFig = figure('Name', 'Teacher Dashboard', 'Position', [100 100 1200 800]);

%% Main Processing Loop
disp('Starting Classroom Attention Monitoring System...');
disp('Press Ctrl+C to stop');

while true
    frameCount = frameCount + 1;
    
    % Capture frame
    frame = snapshot(camera);
    frame = imresize(frame, resolution);
    
    % Detect faces
    [faceBoxes, trackedPoints, frame] = detectAndTrackFaces(frame);
    
    % Process each detected face
    attentionScores = [];
    for i = 1:size(faceBoxes, 1)
        % Extract face region
        faceROI = imcrop(frame, faceBoxes(i,:));
        
        % Calculate attention score for this face
        [attentionScore, gazeDirection, headPose] = calculateAttentionScore(faceROI, faceBoxes(i,:));
        attentionScores = [attentionScores; attentionScore];
        
        % Store individual student data
        studentData = updateStudentData(studentData, i, attentionScore, gazeDirection, headPose);
        
        % Annotate face with score
        frame = annotateFace(frame, faceBoxes(i,:), attentionScore, gazeDirection);
    end
    
    % Calculate class-level attention
    if ~isempty(attentionScores)
        classAttention = mean(attentionScores);
        attentionHistory = [attentionHistory; frameCount, classAttention, length(attentionScores)];
        
        % Keep only last 1000 frames
        if size(attentionHistory, 1) > 1000
            attentionHistory(1,:) = [];
        end
    else
        classAttention = 0;
    end
    
    % Generate heatmap
    heatmapImg = generateHeatmap(frame, faceBoxes, attentionScores);
    
    % Update teacher dashboard
    updateDashboard(dashboardFig, frame, heatmapImg, attentionHistory, classAttention, studentData);
    
    % Display live video with annotations
    step(videoPlayer, frame);
    
    % Data storage (every 30 frames)
    if mod(frameCount, 30) == 0
        storeData(studentData, attentionHistory, frameCount);
    end
end

% Cleanup
clear camera;
release(videoPlayer);
close(dashboardFig);