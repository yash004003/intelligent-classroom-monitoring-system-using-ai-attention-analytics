function heatmapImg = generateHeatmap(frame, faceBoxes, attentionScores)
    % Generate attention heatmap overlay
    
    heatmapImg = frame;
    
    if isempty(faceBoxes) || isempty(attentionScores)
        return;
    end
    
    % Create heatmap overlay
    heatmapLayer = zeros(size(frame,1), size(frame,2));
    
    % Apply Gaussian distribution around each face based on attention score
    for i = 1:size(faceBoxes, 1)
        % Get face center
        faceCenterX = faceBoxes(i,1) + faceBoxes(i,3)/2;
        faceCenterY = faceBoxes(i,2) + faceBoxes(i,4)/2;
        
        % Intensity based on attention score (higher score = cooler colors)
        intensity = attentionScores(i) / 100;
        
        % Create Gaussian kernel
        [X, Y] = meshgrid(1:size(frame,2), 1:size(frame,1));
        gaussian = exp(-((X - faceCenterX).^2 + (Y - faceCenterY).^2) / (2 * (faceBoxes(i,3)/2)^2));
        gaussian = gaussian * intensity;
        
        % Add to heatmap layer
        heatmapLayer = heatmapLayer + gaussian;
    end
    
    % Normalize heatmap
    if max(heatmapLayer(:)) > 0
        heatmapLayer = heatmapLayer / max(heatmapLayer(:));
    end
    
    % Apply colormap
    colormapHot = jet(256);
    heatmapColored = ind2rgb(uint8(heatmapLayer * 255), colormapHot);
    
    % Blend with original frame
    alpha = 0.5;
    heatmapImg = uint8(double(frame) * (1-alpha) + heatmapColored * 255 * alpha);
end