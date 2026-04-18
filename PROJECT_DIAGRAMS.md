# Face Entry Project Diagrams

These diagrams are based on the modules present in this project folder.
They are organized to reflect the actual MATLAB source files, data files, media assets, and generated outputs.

All diagrams use a black and white style and keep labels short to reduce text collisions.

## 1. Architecture Diagram

### Purpose
This diagram shows the major subsystems, how users interact with them, and how source modules connect to data, devices, and outputs.

### Symbols Used
- Rectangle: application module or subsystem
- Cylinder-like node name: logical data store
- Arrow: data flow or control flow
- Group box: related project area

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#ffffff',
  'primaryTextColor': '#000000',
  'primaryBorderColor': '#000000',
  'lineColor': '#000000',
  'secondaryColor': '#ffffff',
  'tertiaryColor': '#ffffff',
  'background': '#ffffff',
  'clusterBkg': '#ffffff',
  'clusterBorder': '#000000'
}}}%%
flowchart TB
    U[User]
    CAM[Webcam]
    IMG[Input Image]

    subgraph A[Attendance Recognition System]
        MAIN[main.m + main.fig]
        ADD[Add Face Module]
        TRAIN[Training Module]
        MATCH[Recognition Module]
        ENTRY[Attendance Writer]
    end

    subgraph B[Feature Extraction Engine]
        BUILD[builddatabase.m]
        FIND[findsimilar.m]
        CALC[calcfeatures.m]
        CSD[colordescriptor.m]
        EHD[ehd.m + ehddist.m]
        HMMD[rgb2hmmd.m + rgb2quanthmmd.m]
    end

    subgraph C[E-Learning and Emotion System]
        ELEARN[E_Learning.m + E_Learning.fig]
        EMO[Emotion_Identification.m]
        ATTN[MAIN_CODE.m]
        FACEOPS[detectAndTrackFaces.m]
        SCORE[calculateAttentionScore.m]
        DASH[updateDashboard.m]
        STORE[storeData.m]
        HEAT[generateHeatmap.m]
        ANNO[annotateFace.m]
        STUD[updateStudentData.m]
    end

    subgraph D[Project Data]
        DB[(database/*.jpg)]
        FEAT[(features.mat)]
        INFO[(info.mat)]
        SHEET[(Entry_sheet.txt)]
        CLASSOUT[(classroom_report_*.mat\nclassroom_data_*.csv)]
        MEDIA[(acidrain/*\nblogging/*)]
    end

    subgraph E[Support Utilities]
        PDF[pdfRead.m]
        TTS[tts.m]
        MONGO[Mongo driver files]
    end

    U --> MAIN
    U --> ELEARN
    CAM --> MAIN
    CAM --> EMO
    CAM --> ATTN
    IMG --> MAIN

    MAIN --> ADD
    MAIN --> TRAIN
    MAIN --> MATCH
    MAIN --> ENTRY

    ADD --> DB
    ADD --> INFO
    TRAIN --> BUILD
    BUILD --> CALC
    CALC --> HMMD
    CALC --> CSD
    CALC --> EHD
    BUILD --> FEAT

    MATCH --> FIND
    FIND --> FEAT
    FIND --> DB
    MATCH --> INFO
    ENTRY --> SHEET

    ELEARN --> MEDIA
    ELEARN --> TTS
    ELEARN --> PDF
    ELEARN --> EMO
    ELEARN --> ATTN

    EMO --> CAM
    ATTN --> FACEOPS
    ATTN --> SCORE
    ATTN --> HEAT
    ATTN --> ANNO
    ATTN --> DASH
    ATTN --> STUD
    ATTN --> STORE
    STORE --> CLASSOUT

    MONGO -. optional legacy utility .- ELEARN
```

## 2. Class Diagram

### Purpose
This diagram models the project as logical classes/modules. The codebase is largely procedural MATLAB, so these are module-level classes rather than MATLAB `classdef` domain classes.

### Symbols Used
- Box with compartments: logical class/module
- `+` method: publicly used operation
- Arrow with open head: dependency or usage
- Diamond relation is avoided here to keep the layout clean

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#ffffff',
  'primaryTextColor': '#000000',
  'primaryBorderColor': '#000000',
  'lineColor': '#000000',
  'secondaryColor': '#ffffff',
  'tertiaryColor': '#ffffff',
  'background': '#ffffff'
}}}%%
classDiagram
    class MainGUI {
      +main()
      +loadImage()
      +captureFromCamera()
      +startTraining()
      +matchPerson()
      +writeEntry()
    }

    class FeatureDatabaseBuilder {
      +builddatabase()
      +calcfeatures(img)
    }

    class SimilarityMatcher {
      +findsimilar(img)
      +compareFeatureVectors()
    }

    class ColorDescriptorEngine {
      +rgb2hmmd(img)
      +rgb2quanthmmd(img, bins)
      +colordescriptor(hmmd, map)
    }

    class EdgeDescriptorEngine {
      +ehd(img, threshold)
      +ehddist(edge1, edge2, a, b, c)
    }

    class AttendanceStore {
      +readInfo()
      +saveInfo()
      +appendEntry()
    }

    class ELearningGUI {
      +E_Learning()
      +playTopicVideo()
      +readKeyPdf()
      +runEmotionCheck()
    }

    class EmotionEngine {
      +Emotion_Identification()
      +captureFace()
      +trainHOGModel()
      +predictEmotion()
    }

    class AttentionMonitor {
      +MAIN_CODE()
      +runMonitoringLoop()
    }

    class FaceTrackingService {
      +detectAndTrackFaces(frame)
    }

    class AttentionScoringService {
      +calculateAttentionScore(faceROI, faceBox)
    }

    class DashboardService {
      +updateDashboard(fig, frame, heatmap, history, score, students)
      +generateHeatmap(frame, boxes, scores)
      +annotateFace(frame, box, score, gaze)
    }

    class StudentDataService {
      +updateStudentData(studentData, id, score, gaze, pose)
      +storeData(studentData, history, frameCount)
    }

    MainGUI --> FeatureDatabaseBuilder : trains
    MainGUI --> SimilarityMatcher : identifies
    MainGUI --> AttendanceStore : persists
    FeatureDatabaseBuilder --> ColorDescriptorEngine : uses
    FeatureDatabaseBuilder --> EdgeDescriptorEngine : uses
    SimilarityMatcher --> FeatureDatabaseBuilder : uses features
    SimilarityMatcher --> EdgeDescriptorEngine : compares

    ELearningGUI --> EmotionEngine : triggers
    ELearningGUI --> AttentionMonitor : triggers

    AttentionMonitor --> FaceTrackingService : uses
    AttentionMonitor --> AttentionScoringService : uses
    AttentionMonitor --> DashboardService : updates
    AttentionMonitor --> StudentDataService : updates
```

## 3. ER Diagram

### Purpose
This diagram shows the project data model: stored images, feature files, identity mappings, attendance logs, and classroom monitoring outputs.

### Symbols Used
- Entity box: stored data object
- Attributes inside box: important fields
- Relationship line: association between entities
- Cardinality labels: one-to-one or one-to-many

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#ffffff',
  'primaryTextColor': '#000000',
  'primaryBorderColor': '#000000',
  'lineColor': '#000000',
  'secondaryColor': '#ffffff',
  'tertiaryColor': '#ffffff',
  'background': '#ffffff'
}}}%%
erDiagram
    DATABASE_IMAGE {
        string image_file
        string image_path
        int width
        int height
    }

    PERSON_INFO {
        string image_file
        string person_name
    }

    FEATURE_STORE {
        string feature_file
        string[] names
        matrix csd128hist
        matrix edges
    }

    ATTENDANCE_ENTRY {
        string person_name
        date entry_date
        string entry_time
        string status
    }

    TOPIC_MEDIA {
        string topic_name
        string media_file
        string media_type
    }

    CLASSROOM_REPORT {
        string report_file
        string timestamp
        int frame_count
        float class_attention
        int num_students
    }

    CLASSROOM_CSV {
        string csv_file
        string timestamp
    }

    STUDENT_METRIC {
        int student_id
        float average_attention
        string first_seen
        string last_seen
    }

    DATABASE_IMAGE ||--|| PERSON_INFO : mapped_by
    DATABASE_IMAGE }o--|| FEATURE_STORE : indexed_in
    PERSON_INFO ||--o{ ATTENDANCE_ENTRY : creates
    TOPIC_MEDIA ||--o{ CLASSROOM_REPORT : may_trigger
    CLASSROOM_REPORT ||--o{ STUDENT_METRIC : contains
    CLASSROOM_REPORT ||--|| CLASSROOM_CSV : exported_as
```

## 4. Sequence Diagram

### Purpose
This diagram shows the main attendance-recognition flow from user action to attendance entry creation. It uses the actual project modules involved in the successful recognition path.

### Symbols Used
- Participant: actor, module, or store
- Vertical dashed line: lifeline over time
- Solid arrow: synchronous call
- Dashed arrow: return/result
- `alt`: decision branch

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#ffffff',
  'primaryTextColor': '#000000',
  'primaryBorderColor': '#000000',
  'lineColor': '#000000',
  'secondaryColor': '#ffffff',
  'tertiaryColor': '#ffffff',
  'background': '#ffffff',
  'actorBorder': '#000000',
  'actorBkg': '#ffffff',
  'actorTextColor': '#000000',
  'signalColor': '#000000',
  'signalTextColor': '#000000',
  'labelBoxBkgColor': '#ffffff',
  'labelBoxBorderColor': '#000000'
}}}%%
sequenceDiagram
    actor User
    participant Main as main.m
    participant Camera as Webcam / Image Source
    participant Detect as CascadeObjectDetector
    participant Match as findsimilar.m
    participant Build as features.mat
    participant Info as info.mat
    participant Entry as Entry_sheet.txt
    participant Attend as MAIN_CODE.m

    User->>Main: Start recognition
    alt Live camera mode
        Main->>Camera: Capture frame
        Camera-->>Main: Face image
    else Pre-captured image mode
        User->>Main: Select image file
    end

    Main->>Detect: Detect single face
    Detect-->>Main: Face bounding box
    Main->>Main: Crop and resize to 300x300
    Main->>Match: findsimilar(faceImage)
    Match->>Build: Load trained features
    Build-->>Match: Feature vectors
    Match-->>Main: Best matching image file
    Main->>Info: Load name mapping
    Info-->>Main: Person name
    Main->>Main: Validate similarity threshold

    alt Match accepted
        Main->>Entry: Append attendance row
        Entry-->>Main: Entry saved
        Main->>Attend: Run follow-up monitoring
        Attend-->>Main: Monitoring started
        Main-->>User: Show success message
    else Match rejected
        Main-->>User: Show invalid person warning
    end
```

## Notes About Diagram Interpretation

- The project is not fully object-oriented. The class diagram is a logical design view derived from MATLAB modules.
- The ER diagram reflects how files and saved data behave as entities in this project.
- The sequence diagram focuses on the core attendance path because that is the most complete and consistent workflow in the codebase.
- The architecture diagram includes both the attendance system and the e-learning/emotion subsystem because both are present in the same project folder.

## Module Coverage Reference

Included project modules:
- `main.m`, `main.fig`
- `E_Learning.m`, `E_Learning.fig`
- `MAIN_CODE.m`
- `Emotion_Identification.m`
- `detectAndTrackFaces.m`
- `calculateAttentionScore.m`
- `generateHeatmap.m`
- `annotateFace.m`
- `updateDashboard.m`
- `updateStudentData.m`
- `storeData.m`
- `codes/builddatabase.m`
- `codes/findsimilar.m`
- `codes/calcfeatures.m`
- `codes/colordescriptor.m`
- `codes/ehd.m`
- `codes/ehddist.m`
- `codes/rgb2hmmd.m`
- `codes/rgb2quanthmmd.m`
- `pdfRead.m`
- `tts.m`
- Mongo utility files as optional legacy support
