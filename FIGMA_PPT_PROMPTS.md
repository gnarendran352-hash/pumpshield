# PumpShield Bharat - Figma PPT Prompts (SIH 2026)

## 6 Slides for 3-Minute Demo

### Slide 1: "Technician Urgent Alerts + Work Stepper"
```
Dark green app UI showing pump failure alert
- 🚨 "BEARING FAILURE - 4.2 DAYS" in red
- Sensor cards: Vib 7.8g🔴, Temp 74°C🔴, Current 13.4A🟠
- Work stepper: [Scan QR ✓] [Check bearing ⚠️] [Replace ⚠️]
- Orange action buttons: QR SCAN, CALL SUPERVISOR, VOICE GUIDE
Primary color: #2E7D32, Critical: #D32F2F
```

### Slide 2: "Engineer FFT Analysis + Thermal Disk Rate"
```
Technical dashboard with vibration FFT spectrum chart
- FFT peak @ 1.8kHz highlighted in orange
- Thermal disk rate: 2.8°C/hr with "CRITICAL" badge
- Feature importance bars: Vib 65%, Temp 22%, Current 13%
- ML Model outputs: LSTM 82%, RF 78%
- Root cause: "Bearing + thermal stress" at 87% confidence
```

### Slide 3: "Manager Fleet ROI ₹1.84L Savings Gauge"
```
Executive dashboard with circular ROI gauge at 78%
- Fleet summary: 10 Pumps | Saved: ₹1.84L | Health: 78%
- Savings trend chart showing ₹1.84L monthly ↑
- Budget approval card: Bearing ₹2.8K [APPROVE button]
- Team members: Ravi (Tech), Priya (Eng), You (Mgr)
- Critical: 2, Warning: 3, OK: 5 pumps
```

### Slide 4: "QR Scanner with Green Frame"
```
Mobile app QR scanner overlay
- Green scanning frame around QR code
- PumpShield QR Intelligence text below
- Info chips: 30-day trends, Maintenance log, ML predictions
- Background: Dark agricultural theme
QR code: "pump001_madurai_coop_v3"
```

### Slide 5: "Machine History Trends + Maintenance Log"
```
Pump complete lifecycle page
- Large RUL gauge: 4.2 days remaining (red)
- 30-day sensor trend mini-charts: Vib ↑ Temp ↑ Current ↑
- Maintenance timeline: Feb 1: Bearing ₹2.8K, Jan 15: Oil change ₹1.2K
- Prediction accuracy: 87% (7/8 correct)
- Install date, total hours display
```

### Slide 6: "Architecture: NASA → EdgeX → Flutter → Firebase"
```
System architecture diagram
NASA CMAPSS Dataset → Python MQTT Simulator → EdgeX Foundry (Docker)
↓                                                       ↓
TFLite LSTM Model (87ms inference) ←────────────────────┘
↓
Flutter Dashboards → Firebase pump-shield → 3 Role Views
↓
💰 ₹2,000CR annual savings | ⚡ 87ms edge latency | 📈 82% accuracy
```

---

## SIH 2026 Demo Script (3 Minutes)

```
"10M pumps × ₹20K losses = ₹2,000CR problem

[QR SCAN] → 'Pump #001 history instantly loaded'
[TECHNICIAN] → '🚨 4.2d BEARING FAILURE alert'
[ENGINEER] → 'Thermal disk 2.8°C/hr + FFT confirms'
[MANAGER] → '₹18K saved, fleet health 78%'
[Firebase] → 'pump-shield project LIVE'

100x cheaper than GE/Siemens = 15% yield boost!"
```

---

## Color Palette for Figma
- Primary Green: #2E7D32
- Dark Green: #1B5E20
- Accent Orange: #FF8F00
- Critical Red: #D32F2F
- Light Green: #81C784
- Dark Background: #121212
- Card Background: #2D2D2D
