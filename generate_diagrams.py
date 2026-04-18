from __future__ import annotations

import math
from pathlib import Path
from typing import List, Tuple

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(r"C:\Users\ch yeshwath\OneDrive\Desktop\PROJECT\Face Entry")
OUTDIR = ROOT / "diagram_exports"
OUTDIR.mkdir(exist_ok=True)

W = 1800
H = 1200
BG = "white"
FG = "black"


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = []
    if bold:
        candidates.extend(
            [
                r"C:\Windows\Fonts\arialbd.ttf",
                r"C:\Windows\Fonts\calibrib.ttf",
                r"C:\Windows\Fonts\segoeuib.ttf",
            ]
        )
    candidates.extend(
        [
            r"C:\Windows\Fonts\arial.ttf",
            r"C:\Windows\Fonts\calibri.ttf",
            r"C:\Windows\Fonts\segoeui.ttf",
        ]
    )
    for path in candidates:
        p = Path(path)
        if p.exists():
            return ImageFont.truetype(str(p), size=size)
    return ImageFont.load_default()


TITLE_FONT = font(34, True)
SUB_FONT = font(20, True)
TEXT_FONT = font(18, False)
SMALL_FONT = font(16, False)


def esc(s: str) -> str:
    return (
        s.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


def wrap_text(text: str, max_chars: int) -> List[str]:
    words = text.split()
    lines: List[str] = []
    cur = ""
    for word in words:
        trial = word if not cur else f"{cur} {word}"
        if len(trial) <= max_chars:
            cur = trial
        else:
            if cur:
                lines.append(cur)
            cur = word
    if cur:
        lines.append(cur)
    return lines


class SvgCanvas:
    def __init__(self, width: int = W, height: int = H):
        self.width = width
        self.height = height
        self.items: List[str] = []
        self.defs = """
<defs>
  <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
    <path d="M 0 0 L 10 5 L 0 10 z" fill="black"/>
  </marker>
</defs>
"""

    def rect(self, x, y, w, h, text_lines=None, title=None, dashed=False, rounded=12, stroke_width=2):
        dash = ' stroke-dasharray="8,6"' if dashed else ""
        self.items.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rounded}" ry="{rounded}" '
            f'stroke="{FG}" stroke-width="{stroke_width}" fill="{BG}"{dash}/>'
        )
        if title:
            self.text(x + w / 2, y + 26, title, size=20, anchor="middle", weight="bold")
        if text_lines:
            start_y = y + (50 if title else 26)
            for idx, line in enumerate(text_lines):
                self.text(x + w / 2, start_y + idx * 22, line, size=16, anchor="middle")

    def line(self, x1, y1, x2, y2, arrow=True, dashed=False, stroke_width=2):
        dash = ' stroke-dasharray="8,6"' if dashed else ""
        marker = ' marker-end="url(#arrow)"' if arrow else ""
        self.items.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{FG}" stroke-width="{stroke_width}"{dash}{marker}/>'
        )

    def polyline(self, pts: List[Tuple[float, float]], arrow=True, dashed=False, stroke_width=2):
        dash = ' stroke-dasharray="8,6"' if dashed else ""
        marker = ' marker-end="url(#arrow)"' if arrow else ""
        pts_s = " ".join(f"{x},{y}" for x, y in pts)
        self.items.append(
            f'<polyline points="{pts_s}" fill="none" stroke="{FG}" stroke-width="{stroke_width}"{dash}{marker}/>'
        )

    def text(self, x, y, content, size=18, anchor="start", weight="normal"):
        self.items.append(
            f'<text x="{x}" y="{y}" font-family="Arial, Helvetica, sans-serif" font-size="{size}" '
            f'font-weight="{weight}" text-anchor="{anchor}" fill="{FG}">{esc(content)}</text>'
        )

    def save(self, path: Path):
        svg = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.width}" height="{self.height}" viewBox="0 0 {self.width} {self.height}">',
            f'<rect width="100%" height="100%" fill="{BG}"/>',
            self.defs,
            *self.items,
            "</svg>",
        ]
        path.write_text("\n".join(svg), encoding="utf-8")


class PngCanvas:
    def __init__(self, width: int = W, height: int = H):
        self.width = width
        self.height = height
        self.image = Image.new("RGB", (width, height), BG)
        self.draw = ImageDraw.Draw(self.image)

    def rect(self, x, y, w, h, title=None, text_lines=None, dashed=False, radius=12, width=2):
        if dashed:
            self.dashed_rect(x, y, x + w, y + h, dash=12, gap=8, width=width)
        else:
            self.draw.rounded_rectangle([x, y, x + w, y + h], radius=radius, outline=FG, width=width, fill=BG)
        if title:
            bbox = self.draw.textbbox((0, 0), title, font=SUB_FONT)
            tw = bbox[2] - bbox[0]
            self.draw.text((x + (w - tw) / 2, y + 10), title, fill=FG, font=SUB_FONT)
        if text_lines:
            start_y = y + (42 if title else 18)
            for idx, line in enumerate(text_lines):
                bbox = self.draw.textbbox((0, 0), line, font=SMALL_FONT)
                tw = bbox[2] - bbox[0]
                self.draw.text((x + (w - tw) / 2, start_y + idx * 22), line, fill=FG, font=SMALL_FONT)

    def dashed_rect(self, x1, y1, x2, y2, dash=10, gap=6, width=2):
        self.dashed_line((x1, y1), (x2, y1), dash, gap, width)
        self.dashed_line((x2, y1), (x2, y2), dash, gap, width)
        self.dashed_line((x2, y2), (x1, y2), dash, gap, width)
        self.dashed_line((x1, y2), (x1, y1), dash, gap, width)

    def dashed_line(self, p1, p2, dash=10, gap=6, width=2):
        x1, y1 = p1
        x2, y2 = p2
        dx = x2 - x1
        dy = y2 - y1
        dist = math.hypot(dx, dy)
        if dist == 0:
            return
        ux = dx / dist
        uy = dy / dist
        pos = 0.0
        while pos < dist:
            end = min(pos + dash, dist)
            sx = x1 + ux * pos
            sy = y1 + uy * pos
            ex = x1 + ux * end
            ey = y1 + uy * end
            self.draw.line([sx, sy, ex, ey], fill=FG, width=width)
            pos += dash + gap

    def arrow(self, points: List[Tuple[float, float]], dashed=False, width=2):
        for i in range(len(points) - 1):
            p1, p2 = points[i], points[i + 1]
            if dashed:
                self.dashed_line(p1, p2, width=width)
            else:
                self.draw.line([p1, p2], fill=FG, width=width)
        self.arrowhead(points[-2], points[-1], size=12)

    def arrowhead(self, p1, p2, size=12):
        x1, y1 = p1
        x2, y2 = p2
        ang = math.atan2(y2 - y1, x2 - x1)
        a1 = ang + math.pi - math.radians(24)
        a2 = ang + math.pi + math.radians(24)
        p3 = (x2 + size * math.cos(a1), y2 + size * math.sin(a1))
        p4 = (x2 + size * math.cos(a2), y2 + size * math.sin(a2))
        self.draw.polygon([p2, p3, p4], fill=FG)

    def text(self, x, y, content, font_obj=TEXT_FONT, anchor="lt"):
        self.draw.text((x, y), content, fill=FG, font=font_obj, anchor=anchor)

    def centered_text(self, cx, cy, content, font_obj=TEXT_FONT):
        bbox = self.draw.textbbox((0, 0), content, font=font_obj)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
        self.draw.text((cx - tw / 2, cy - th / 2), content, fill=FG, font=font_obj)

    def save(self, path: Path):
        self.image.save(path)


def draw_title_svg(c: SvgCanvas, title: str, subtitle: str):
    c.text(W / 2, 48, title, size=30, anchor="middle", weight="bold")
    c.text(W / 2, 78, subtitle, size=17, anchor="middle")


def draw_title_png(c: PngCanvas, title: str, subtitle: str):
    c.centered_text(W / 2, 38, title, TITLE_FONT)
    c.centered_text(W / 2, 76, subtitle, SMALL_FONT)


def architecture():
    svg = SvgCanvas()
    png = PngCanvas()
    title = "Architecture Diagram"
    subtitle = "Face Entry project modules, data stores, external devices, and outputs"
    draw_title_svg(svg, title, subtitle)
    draw_title_png(png, title, subtitle)

    boxes = {
        "user": (60, 150, 180, 90, "User", []),
        "main": (320, 120, 300, 150, "Attendance Recognition", ["main.m", "main.fig"]),
        "feat": (760, 100, 340, 220, "Feature Extraction Engine", ["builddatabase.m", "findsimilar.m", "calcfeatures.m", "colordescriptor.m", "ehd.m / ehddist.m", "rgb2hmmd.m / rgb2quanthmmd.m"]),
        "data": (1250, 90, 460, 270, "Project Data Stores", ["database/*.jpg", "features.mat", "info.mat", "Entry_sheet.txt", "classroom_report_*.mat", "classroom_data_*.csv"]),
        "elearn": (320, 400, 300, 150, "E-Learning and Emotion", ["E_Learning.m", "E_Learning.fig", "Emotion_Identification.m"]),
        "attn": (760, 410, 340, 220, "Attention Monitoring", ["MAIN_CODE.m", "detectAndTrackFaces.m", "calculateAttentionScore.m", "generateHeatmap.m", "annotateFace.m", "updateDashboard.m", "updateStudentData.m", "storeData.m"]),
        "media": (1250, 430, 460, 150, "Media Assets", ["acidrain/*", "blogging/*", "key.pdf", "help.pdf"]),
        "support": (520, 760, 380, 150, "Support Utilities", ["tts.m", "pdfRead.m", "Mongo driver files"]),
        "device": (60, 450, 180, 120, "Input Devices", ["Webcam", "Image Files"]),
    }

    for _, (x, y, w, h, title_b, lines) in boxes.items():
        svg.rect(x, y, w, h, title=title_b, text_lines=lines)
        png.rect(x, y, w, h, title=title_b, text_lines=lines)

    arrows = [
        [(240, 195), (320, 195)],
        [(240, 510), (320, 510), (320, 475)],
        [(620, 195), (760, 195)],
        [(1100, 195), (1250, 195)],
        [(620, 475), (760, 475)],
        [(1100, 520), (1250, 520)],
        [(470, 270), (470, 400)],
        [(930, 320), (930, 410)],
        [(710, 835), (620, 835), (620, 550)],
        [(900, 760), (930, 760), (930, 630)],
    ]
    for pts in arrows:
        svg.polyline(pts)
        png.arrow(pts)

    dashed = [[(900, 760), (1480, 760), (1480, 580)]]
    for pts in dashed:
        svg.polyline(pts, dashed=True)
        png.arrow(pts, dashed=True)

    svg.save(OUTDIR / "architecture_diagram.svg")
    png.save(OUTDIR / "architecture_diagram.png")


def class_diagram():
    svg = SvgCanvas()
    png = PngCanvas()
    title = "Class Diagram"
    subtitle = "Logical module classes derived from the MATLAB project structure"
    draw_title_svg(svg, title, subtitle)
    draw_title_png(png, title, subtitle)

    boxes = {
        "main": (70, 130, 280, 170, "MainGUI", ["+ main()", "+ loadImage()", "+ captureFromCamera()", "+ startTraining()", "+ matchPerson()"]),
        "fdb": (450, 120, 310, 170, "FeatureDatabaseBuilder", ["+ builddatabase()", "+ calcfeatures(img)"]),
        "sim": (860, 120, 280, 150, "SimilarityMatcher", ["+ findsimilar(img)", "+ compareFeatureVectors()"]),
        "color": (1240, 95, 450, 210, "ColorDescriptorEngine", ["+ rgb2hmmd(img)", "+ rgb2quanthmmd(img,bins)", "+ colordescriptor(hmmd,map)"]),
        "edge": (1240, 355, 450, 190, "EdgeDescriptorEngine", ["+ ehd(img,threshold)", "+ ehddist(edge1,edge2,a,b,c)"]),
        "store": (70, 410, 280, 170, "AttendanceStore", ["+ readInfo()", "+ saveInfo()", "+ appendEntry()"]),
        "elearn": (450, 410, 310, 170, "ELearningGUI", ["+ E_Learning()", "+ playTopicVideo()", "+ readKeyPdf()", "+ runEmotionCheck()"]),
        "emotion": (860, 400, 280, 190, "EmotionEngine", ["+ Emotion_Identification()", "+ captureFace()", "+ trainHOGModel()", "+ predictEmotion()"]),
        "attn": (450, 760, 310, 150, "AttentionMonitor", ["+ MAIN_CODE()", "+ runMonitoringLoop()"]),
        "track": (860, 720, 280, 130, "FaceTrackingService", ["+ detectAndTrackFaces(frame)"]),
        "score": (1240, 680, 450, 140, "AttentionScoringService", ["+ calculateAttentionScore(faceROI,faceBox)"]),
        "dash": (860, 900, 280, 170, "DashboardService", ["+ updateDashboard(...)", "+ generateHeatmap(...)", "+ annotateFace(...)"]),
        "student": (1240, 880, 450, 160, "StudentDataService", ["+ updateStudentData(...)", "+ storeData(...)"]),
    }

    for _, (x, y, w, h, title_b, lines) in boxes.items():
        svg.rect(x, y, w, h, title=title_b, text_lines=lines)
        png.rect(x, y, w, h, title=title_b, text_lines=lines)

    edges = [
        [(350, 205), (450, 205)],
        [(760, 205), (860, 205)],
        [(1140, 205), (1240, 205)],
        [(350, 495), (450, 495)],
        [(760, 495), (860, 495)],
        [(605, 580), (605, 760)],
        [(760, 835), (860, 785)],
        [(1140, 785), (1240, 750)],
        [(1000, 850), (1000, 900)],
        [(1140, 985), (1240, 960)],
        [(605, 300), (605, 410)],
        [(1000, 270), (1000, 400)],
    ]
    for pts in edges:
        svg.polyline(pts)
        png.arrow(pts)

    svg.save(OUTDIR / "class_diagram.svg")
    png.save(OUTDIR / "class_diagram.png")


def er_diagram():
    svg = SvgCanvas()
    png = PngCanvas()
    title = "ER Diagram"
    subtitle = "Project data entities and relationships based on stored files and generated outputs"
    draw_title_svg(svg, title, subtitle)
    draw_title_png(png, title, subtitle)

    entities = {
        "img": (90, 150, 320, 180, "DATABASE_IMAGE", ["PK image_file", "image_path", "width", "height"]),
        "info": (500, 150, 300, 150, "PERSON_INFO", ["PK/FK image_file", "person_name"]),
        "feat": (930, 120, 390, 210, "FEATURE_STORE", ["PK feature_file", "names[]", "csd128hist", "edges"]),
        "entry": (1400, 150, 300, 170, "ATTENDANCE_ENTRY", ["person_name", "entry_date", "entry_time", "status"]),
        "media": (110, 500, 300, 150, "TOPIC_MEDIA", ["topic_name", "media_file", "media_type"]),
        "report": (560, 470, 320, 210, "CLASSROOM_REPORT", ["PK report_file", "timestamp", "frame_count", "class_attention", "num_students"]),
        "csv": (1000, 510, 250, 130, "CLASSROOM_CSV", ["PK csv_file", "timestamp"]),
        "metric": (1400, 470, 300, 190, "STUDENT_METRIC", ["student_id", "average_attention", "first_seen", "last_seen"]),
    }

    for _, (x, y, w, h, title_b, lines) in entities.items():
        svg.rect(x, y, w, h, title=title_b, text_lines=lines)
        png.rect(x, y, w, h, title=title_b, text_lines=lines)

    relations = [
        ([(410, 225), (500, 225)], "1:1"),
        ([(800, 225), (930, 225)], "N:1"),
        ([(1320, 225), (1400, 225)], "1:N"),
        ([(250, 330), (250, 500)], ""),
        ([(410, 225), (410, 575), (560, 575)], ""),
        ([(880, 575), (1000, 575)], "1:1"),
        ([(1250, 575), (1400, 575)], "1:N"),
    ]
    for pts, label in relations:
        svg.polyline(pts)
        png.arrow(pts)
        if label:
            mx = (pts[0][0] + pts[-1][0]) / 2
            my = (pts[0][1] + pts[-1][1]) / 2 - 10
            svg.text(mx, my, label, size=16, anchor="middle", weight="bold")
            png.centered_text(mx, my, label, SMALL_FONT)

    svg.save(OUTDIR / "er_diagram.svg")
    png.save(OUTDIR / "er_diagram.png")


def sequence_diagram():
    svg = SvgCanvas()
    png = PngCanvas()
    title = "Sequence Diagram"
    subtitle = "Attendance recognition flow using the actual project modules"
    draw_title_svg(svg, title, subtitle)
    draw_title_png(png, title, subtitle)

    participants = [
        ("User", 120),
        ("main.m", 380),
        ("Webcam / Image", 650),
        ("Cascade Detector", 920),
        ("findsimilar.m", 1190),
        ("features.mat", 1460),
        ("info.mat / Entry", 1690),
    ]

    for label, x in participants:
        svg.rect(x - 80, 110, 160, 60, text_lines=[label])
        png.rect(x - 80, 110, 160, 60, text_lines=[label])
        svg.line(x, 170, x, 1090, arrow=False, dashed=True, stroke_width=1)
        png.dashed_line((x, 170), (x, 1090), width=1)

    messages = [
        (120, 380, 220, "Start recognition"),
        (380, 650, 290, "Capture frame / load image"),
        (650, 380, 360, "Return face image"),
        (380, 920, 430, "Detect single face"),
        (920, 380, 500, "Bounding box"),
        (380, 380, 570, "Crop and resize 300x300"),
        (380, 1190, 640, "findsimilar(faceImage)"),
        (1190, 1460, 710, "Load trained features"),
        (1460, 1190, 780, "Feature vectors"),
        (1190, 380, 850, "Best image file"),
        (380, 1690, 920, "Load name map / append entry"),
        (1690, 380, 990, "Name and save result"),
        (380, 120, 1060, "Success or invalid warning"),
    ]

    for x1, x2, y, label in messages:
        if x1 == x2:
            svg.polyline([(x1, y), (x1 + 120, y), (x1 + 120, y + 50), (x1, y + 50)])
            png.arrow([(x1, y), (x1 + 120, y), (x1 + 120, y + 50), (x1, y + 50)])
            svg.text(x1 + 60, y - 8, label, size=16, anchor="middle")
            png.centered_text(x1 + 60, y - 10, label, SMALL_FONT)
        else:
            svg.line(x1, y, x2, y)
            png.arrow([(x1, y), (x2, y)])
            svg.text((x1 + x2) / 2, y - 8, label, size=16, anchor="middle")
            png.centered_text((x1 + x2) / 2, y - 10, label, SMALL_FONT)

    svg.rect(260, 1010, 420, 110, title="Accepted Match", text_lines=["Append attendance row", "Optionally run MAIN_CODE.m"])
    png.rect(260, 1010, 420, 110, title="Accepted Match", text_lines=["Append attendance row", "Optionally run MAIN_CODE.m"])
    svg.rect(760, 1010, 360, 110, title="Rejected Match", text_lines=["Show invalid person warning"])
    png.rect(760, 1010, 360, 110, title="Rejected Match", text_lines=["Show invalid person warning"])

    svg.save(OUTDIR / "sequence_diagram.svg")
    png.save(OUTDIR / "sequence_diagram.png")


def main():
    architecture()
    class_diagram()
    er_diagram()
    sequence_diagram()


if __name__ == "__main__":
    main()
