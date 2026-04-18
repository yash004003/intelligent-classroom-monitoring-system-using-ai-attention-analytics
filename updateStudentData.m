function studentData = updateStudentData(studentData, studentID, attentionScore, gazeDirection, headPose)
    % Update individual student records
    
    currentTime = datetime('now');
    
    % Check if student exists
    if studentID <= length(studentData)
        % Update existing student
        studentData(studentID).attentionHistory = [studentData(studentID).attentionHistory; attentionScore];
        studentData(studentID).lastSeen = currentTime;
        studentData(studentID).gazeDirection = gazeDirection;
        studentData(studentID).headPose = headPose;
        
        % Keep only last 100 records
        if length(studentData(studentID).attentionHistory) > 100
            studentData(studentID).attentionHistory(1) = [];
        end
        
        % Calculate average attention
        studentData(studentID).averageAttention = mean(studentData(studentID).attentionHistory);
    else
        % Add new student
        studentData(studentID).id = studentID;
        studentData(studentID).attentionHistory = attentionScore;
        studentData(studentID).averageAttention = attentionScore;
        studentData(studentID).firstSeen = currentTime;
        studentData(studentID).lastSeen = currentTime;
        studentData(studentID).gazeDirection = gazeDirection;
        studentData(studentID).headPose = headPose;
    end
end