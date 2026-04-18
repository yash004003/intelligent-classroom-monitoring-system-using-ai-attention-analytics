function updateDashboard(dashboardFig, frame, heatmapImg, attentionHistory, classAttention, studentData)
    % Update teacher dashboard with real-time statistics
    
    figure(dashboardFig);
    clf;
    
    % Create subplot layout
    subplot(2,3,1);
    imshow(frame);
    title('Live Video Feed', 'FontSize', 12, 'FontWeight', 'bold');
    
    subplot(2,3,2);
    imshow(heatmapImg);
    title('Attention Heatmap', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Class attention over time
    subplot(2,3,3);
    if ~isempty(attentionHistory)
        plot(attentionHistory(:,1), attentionHistory(:,2), 'b-', 'LineWidth', 2);
        xlabel('Frame Number');
        ylabel('Attention Score (%)');
        title('Class Attention Trend', 'FontSize', 12, 'FontWeight', 'bold');
        grid on;
        ylim([0 100]);
    end
    
    % Current class statistics
    subplot(2,3,4);
    if ~isempty(studentData)
        numStudents = length(studentData);
        avgAttention = mean([studentData.averageAttention]);
        bar([numStudents, avgAttention, classAttention]);
        set(gca, 'XTickLabel', {'Students', 'Avg Attention', 'Current Class'});
        ylabel('Value');
        title('Class Statistics', 'FontSize', 12, 'FontWeight', 'bold');
        ylim([0 100]);
        grid on;
        
        % Add text values on bars
        text(1, numStudents, num2str(numStudents), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        text(2, avgAttention, [num2str(round(avgAttention)), '%'], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        text(3, classAttention, [num2str(round(classAttention)), '%'], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    
    % Individual student attention
    subplot(2,3,[5,6]);
    if ~isempty(studentData)
        studentIDs = 1:length(studentData);
        avgScores = [studentData.averageAttention];
        
        % Create bar chart with color coding
        barColors = zeros(length(avgScores), 3);
        for i = 1:length(avgScores)
            if avgScores(i) >= 70
                barColors(i,:) = [0 1 0]; % Green - High attention
            elseif avgScores(i) >= 40
                barColors(i,:) = [1 1 0]; % Yellow - Medium attention
            else
                barColors(i,:) = [1 0 0]; % Red - Low attention
            end
        end
        
        bar(studentIDs, avgScores, 'FaceColor', 'flat', 'CData', barColors);
        xlabel('Student ID');
        ylabel('Average Attention Score (%)');
        title('Individual Student Attention Scores', 'FontSize', 12, 'FontWeight', 'bold');
        ylim([0 100]);
        grid on;
        
        % Add value labels on bars
        for i = 1:length(avgScores)
            text(i, avgScores(i), [num2str(round(avgScores(i))), '%'], ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        end
    end
    
    drawnow;
end