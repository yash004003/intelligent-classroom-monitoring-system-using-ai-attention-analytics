function storeData(studentData, attentionHistory, frameCount)
    % Store data to file for reporting
    
    % Create timestamp
    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    
    % Prepare data structure
    reportData.timestamp = timestamp;
    reportData.frameCount = frameCount;
    reportData.classAttention = mean(attentionHistory(:,2));
    reportData.numStudents = length(studentData);
    
    % Student details
    for i = 1:length(studentData)
        reportData.students(i).id = studentData(i).id;
        reportData.students(i).averageAttention = studentData(i).averageAttention;
        reportData.students(i).firstSeen = datestr(studentData(i).firstSeen);
        reportData.students(i).lastSeen = datestr(studentData(i).lastSeen);
    end
    
    % Save to file
    filename = ['classroom_report_', timestamp, '.mat'];
    save(filename, 'reportData');
    
    % Also save as CSV for easy viewing
    csvFilename = ['classroom_data_', timestamp, '.csv'];
    csvData = [];
    for i = 1:length(studentData)
        csvData = [csvData; studentData(i).id, studentData(i).averageAttention, ...
            studentData(i).attentionHistory(end)];
    end
    csvwrite(csvFilename, csvData);
    
    disp(['Data saved to ', filename, ' and ', csvFilename]);
end