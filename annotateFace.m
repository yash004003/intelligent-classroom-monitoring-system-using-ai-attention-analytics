function frame = annotateFace(frame, faceBox, attentionScore, gazeDirection)
    % Annotate detected face with attention score and gaze direction
    
    % Draw face bounding box
    color = getAttentionColor(attentionScore);
    frame = insertShape(frame, 'Rectangle', faceBox, 'Color', color, 'LineWidth', 2);
    
    % Add attention score text
    scoreText = sprintf('Attention: %.0f%%', attentionScore);
    frame = insertText(frame, [faceBox(1), faceBox(2)-20], scoreText, ...
        'FontSize', 12, 'BoxColor', color, 'BoxOpacity', 0.7, 'TextColor', 'white');
    
    % Add gaze direction
    if ~strcmp(gazeDirection, 'unknown')
        gazeText = sprintf('Gaze: %s', gazeDirection);
        frame = insertText(frame, [faceBox(1), faceBox(2)-40], gazeText, ...
            'FontSize', 10, 'BoxColor', 'black', 'BoxOpacity', 0.5, 'TextColor', 'white');
    end
end

function color = getAttentionColor(score)
    % Get color based on attention score
    if score >= 70
        color = [0 255 0]; % Green
    elseif score >= 40
        color = [255 255 0]; % Yellow
    else
        color = [255 0 0]; % Red
    end
end