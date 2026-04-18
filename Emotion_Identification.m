global flag;global count;
% Create the face detector object.
faceDetector = vision.CascadeObjectDetector();

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
if exist('cam') ==0
cam = webcam(1)
end

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Detection & Tracking
runLoop = true;
numPts = 0;
frameCount = 0;

while runLoop && frameCount < 100

    % Get the next frame.
    videoFrame = snapshot(cam);
    
    % Get frame to save data to database
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;

    if numPts < 10
        % Detection mode.
        bbox = faceDetector.step(videoFrameGray);

        if ~isempty(bbox)
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display tracked points.
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');

            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
        end

    end

    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end

% Clean up.
clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);

% Save your image to your database
% You have to repeat it from step 1 to here to save more face either same person or different person.
position1 = min(bboxPolygon(2),bboxPolygon(4));
position2 = max(bboxPolygon(6),bboxPolygon(8));
position3 = min(bboxPolygon(1),bboxPolygon(7));
position4 = max(bboxPolygon(3),bboxPolygon(5));

warning('off')
getimage = videoFrameGray(position1:position2,position3:position4,:);
% figure();imshow(getimage)
%resize image
getimage = imresize(getimage, [300 300]);

% Modify here. In the folder database2, label the name of ppl and put their
% faces inside the folder.
imwrite(getimage,'database2\Admin_G\35.jpg');
imwrite(getimage,'database2\Admin_G\35.jpg');

% Train your Image in the database folder

%% Load Image Information from ATT Face Database Directory
faceDatabase = imageSet('database2','recursive');

%% Split Database into Training & Test Sets
[training,test] = partition(faceDatabase,[0.8 0.2]);

%% Extract and display Histogram of Oriented Gradient Features for single face 
person = 2;
[hogFeature, visualization]= ...
    extractHOGFeatures(read(training(person),1));
% figure();
% subplot(2,1,1);imshow(read(training(person),1));title('Input Face');
% subplot(2,1,2);plot(visualization);title('HoG Feature');

% Extract HOG Features for training set 
trainingFeatures = zeros(size(training,2)*training(1).Count,46656);
featureCount = 1;
for i=1:size(training,2)
    for j = 1:training(i).Count
        points = detectSURFFeatures(read(training(i),j));
        trainingFeatures(featureCount,:) = extractHOGFeatures(read(training(i),j));
        trainingLabel{featureCount} = training(i).Description;    
        featureCount = featureCount + 1;
    end
    personIndex{i} = training(i).Description;
end
% Create 40 class classifier using  
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);

% Predict Person in the database folder
% Create the face detector object.
faceDetector = vision.CascadeObjectDetector();

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
if exist('cam') ==0
cam = webcam(1);
end
% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
% Run Video for Prediction
runLoop = true;
numPts = 0;
frameCount = 0;
% cam = webcam('HP TrueVision HD Camera');
while runLoop && frameCount < 300

    % Get the next frame.
    videoFrame = snapshot(cam);
    
    % Get frame to save data to database
    videoFrame2 = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;

    if numPts < 10
        % Detection mode.
        bbox = faceDetector.step(videoFrameGray);

        if ~isempty(bbox)
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display detected corners.
            videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    else
        % Tracking mode.
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);


            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display tracked points.
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');

            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
            
            position1 = min(bboxPolygon(2),bboxPolygon(4));
            position2 = max(bboxPolygon(6),bboxPolygon(8));
            position3 = min(bboxPolygon(1),bboxPolygon(7));
            position4 = max(bboxPolygon(3),bboxPolygon(5));
            
            warning('off')
            if position2<640 && position4<640 && position1>0 && position2>0
            getimage = videoFrameGray(position1:position2,position3:position4,:);

            %resize image
            getimage = imresize(getimage, [300 300]);

            
            queryFeatures = extractHOGFeatures(getimage);
            [personLabel,PostProbs]  = predict(faceClassifier,queryFeatures);
            maxpro = max(abs(PostProbs(1)),abs(PostProbs(2)));
            position = [position3 position2];
            box_color = {'yellow'};
%             disp(maxpro)
            string = strcat(personLabel,num2str(maxpro));
            videoFrame = insertText(videoFrame,position,string,'FontSize',18,'BoxColor',...
            box_color,'BoxOpacity',0.4,'TextColor','white');
         
        if(maxpro>=0.62 && maxpro<=0.72)
       disp('Happy');
       set(handles.edit1,'String','Happy');tts('Detected Emotion is Happy');
    
        end 
          if (maxpro>=0.59 && maxpro<0.62)
              disp('Sad');
              set(handles.edit1,'String','Sad');tts('Detected Emotion is Sad');
              flag=1;count=count +1;break
            
            end
           if (maxpro>0.48 && maxpro<=0.58)
              disp('Sleep');
              set(handles.edit1,'String','Sleep');tts('Detected Emotion is Sleep');
              flag=1;count=count +1;break
             
            end
           if (maxpro>0.52 && maxpro<=0.54) 
              disp('Half sleep');
                     set(handles.edit1,'String','Half Sleep');tts('Detected Emotion is Half Sleep');
                     flag=1;count=count +1;break
                     
           end 
           if (maxpro>0.24 && maxpro<=0.28) 
              disp('Stare');
                     set(handles.edit1,'String','Stare');tts('Detected Emotion is Stare');
                     flag=1;count=count +1;break
                    
           end 
             
            end
        end
 
    end 

   % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end

clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);
