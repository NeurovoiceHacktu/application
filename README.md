# Parkinson's Detection App

Complete Flutter mobile application with Python ML backend for multi-level Parkinson's disease detection, patient monitoring, and clinical analysis.

## 📋 Overview

This system integrates **three levels** of Parkinson's detection:
- **Level 1** - Voice Analysis (✅ **REAL ML** - Deployed external API)
- **Level 2** - Facial Movement (✅ **REAL ML** - Deployed WebView API)  
- **Level 3** - Tremor Detection (⏳ **MOCK** - Awaiting your trained model)

**Dashboards use REAL data** from Level 1 and Level 2 tests aggregated in local backend.

📖 **[Read Full Architecture Documentation →](ARCHITECTURE.md)**

---

## 🎯 Features

### Patient Testing
- **Voice Assessment**: Records voice sample → Analyzes via external ML API → Returns risk score
- **Facial Assessment**: Real-time face tracking → Detects asymmetry, blink rate, motion
- **Tremor Test**: Collects sensor data → Analyzes tremor patterns → Provides severity score

### Caregiver Dashboard
- ✅ **Speech Stability**: Uses **REAL** voice test results to track daily speech quality
- 🔄 Emotional Health Tracking (mock data - future integration)
- 🔄 Medication Reminders & Compliance (mock data - future integration)
- 🔄 Emergency Alerts Management (mock data - future integration)

### Doctor Dashboard
- ✅ **Risk Severity Index**: Combines **REAL** Level 1 + Level 2 + Mock Level 3 scores
- ✅ **AI Clinical Summary**: Generated from **REAL** test results
- ✅ **Disease Progression**: 6-month trends from **REAL** test history
- ✅ **Multi-Level Assessment**: Individual scores from all three detection levels

---

## 🚀 Quick Start

### Prerequisites
- **Flutter**: 3.0+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Python**: 3.8+ ([Install Python](https://www.python.org/downloads/))
- **Mobile Device or Emulator**: For testing

### 1. Install Dependencies

**Backend:**
```bash
cd backend
pip install -r requirements.txt
```

**Flutter:**
```bash
flutter pub get
```

### 2. Configure Your IP Address

Find your computer's IP address:
```bash
# Windows
ipconfig
# Look for "IPv4 Address" (e.g., 192.168.1.100)

# macOS/Linux
ifconfig
```

Update in **THREE** files:
1. [lib/features/voice_check/voice_check_viewmodel.dart](lib/features/voice_check/voice_check_viewmodel.dart) - Line ~56
2. [lib/features/facial_check/facial_check_view.dart](lib/features/facial_check/facial_check_view.dart) - Line ~29
3. Dashboard viewmodels (or API constants)

Replace `192.168.1.100` with your actual IP.

### 3. Start the Backend

**Windows:**
```bash
start_backend.bat
```

**macOS/Linux:**
```bash
cd backend
python app.py
```

Backend runs on `http://YOUR_IP:5000`

### 4. Run the Flutter App

```bash
flutter run
```

Select your device when prompted.

### 5. Test the System

1. **Run Voice Test** (Level 1):
   - Home → "Voice Assessment"
   - Record 12 seconds
   - View results
   - Check backend console: `✅ Stored voice test result`

2. **Run Facial Test** (Level 2):
   - Home → "Facial Assessment"  
   - Allow camera access
   - Complete assessment
   - Check backend console: `✅ Stored facial test result`

3. **Run Tremor Test** (Level 3):
   - Home → "Tremor Test (Level 3)"
   - Hold phone steady for 10 seconds
   - View mock results

4. **View Dashboards**:
   - Home → "Caregiver Dashboard" (see real speech data)
   - Home → "Doctor Dashboard" (see aggregated analysis)

---

## 🧠 Integrating Your Tremor ML Model

Currently Level 3 uses **mock predictions**. To use your **real trained model**:

### Step 1: Prepare Your Model
```python
import joblib
from sklearn.ensemble import RandomForestClassifier

# Train your model
model = RandomForestClassifier(...)
model.fit(X_train, y_train)

# Save model
joblib.dump(model, 'backend/models/level3_tremor/tremor_model.pkl')
joblib.dump(scaler, 'backend/models/level3_tremor/feature_scaler.pkl')
```

### Step 2: Update Inference Code
Edit [backend/inference.py](backend/inference.py):
```python
import joblib

# Load your model
model = joblib.load('models/level3_tremor/tremor_model.pkl')
scaler = joblib.load('models/level3_tremor/feature_scaler.pkl')

def predict_tremor_risk(sensor_data):
    # Your feature extraction
    features = extract_features(sensor_data)
    features_scaled = scaler.transform([features])
    
    # Predict
    prediction = model.predict(features_scaled)[0]
    confidence = model.predict_proba(features_scaled)[0].max()
    
    return {
        'risk_level': prediction,
        'confidence': confidence,
        # ... other metrics
    }
```

### Step 3: Restart Backend
```bash
python backend/app.py
```

📖 **[Detailed Model Integration Guide →](backend/models/level3_tremor/README.md)**

---

## 📊 Backend API Endpoints

### Test Analysis
- `POST /api/tremor/analyze` - Analyze tremor sensor data (Level 3)

### Result Storage
- `POST /api/voice/result` - Store voice test results from Level 1
- `POST /api/facial/result` - Store facial test results from Level 2

### Dashboard Data
- `GET /api/caregiver/dashboard` - Caregiver monitoring data (uses **REAL** voice data)
- `GET /api/doctor/dashboard` - Clinical analysis data (uses **REAL** multi-level data)
- `GET /api/patient/history` - Patient test history

### Health Check
- `GET /health` - Backend status and test result counts

**Example Request:**
```bash
curl http://YOUR_IP:5000/api/doctor/dashboard
```

---

## 🗂️ Project Structure

```
application/
├── lib/
│   ├── features/
│   │   ├── voice_check/         # Level 1 - Voice test (REAL ML)
│   │   ├── facial_check/        # Level 2 - Facial test (REAL ML)
│   │   ├── tremor_check/        # Level 3 - Tremor test (MOCK ML)
│   │   ├── caregiver/           # Caregiver dashboard
│   │   └── doctor/              # Doctor dashboard
│   ├── core/
│   │   ├── network/             # API clients
│   │   └── models/              # Data models
│   └── shared/
│       └── widgets/             # Reusable components
│
├── backend/
│   ├── app.py                   # Flask API server
│   ├── inference.py             # ML model inference (mock for Level 3)
│   ├── requirements.txt         # Python dependencies
│   ├── models/
│   │   ├── level1_voice/        # Voice ML documentation
│   │   ├── level2_facial/       # Facial ML documentation
│   │   └── level3_tremor/       # <-- Place your tremor model here
│   └── README.md
│
├── ARCHITECTURE.md              # System architecture overview
├── INTEGRATION_GUIDE.md         # Setup and integration guide
└── README.md                    # This file
```

---

## 🔍 How Data Flows

### Test Execution Flow
```
Flutter App (User runs test)
    ↓
External ML API (Level 1 & 2) or Local Backend (Level 3)
    ↓
Result returned to Flutter
    ↓
Flutter sends result to LOCAL backend (/api/voice or /api/facial or auto-stored for tremor)
    ↓
Local backend stores in-memory
    ↓
Dashboards fetch aggregated data from local backend
```

### Dashboard Data Sources
- **Voice Test Data**: Level 1 external ML API → Stored locally → Used in speech stability
- **Facial Test Data**: Level 2 external WebView ML → Stored locally → Used in risk severity
- **Tremor Test Data**: Level 3 local backend → Auto-stored → Used in risk severity

---

## 🛠️ Development

### Running Tests
```bash
# Flutter tests
flutter test

# Python backend tests (if you create them)
cd backend
pytest
```

### Debugging
- **Flutter DevTools**: `flutter pub global activate devtools` then `flutter pub global run devtools`
- **Backend Logs**: Check terminal where `python app.py` is running
- **Network Issues**: Verify IP address and firewall settings

### Common Issues

| Problem | Solution |
|---------|----------|
| "Backend not reachable" | Check IP address in Flutter code matches your computer's IP |
| "WebView blank" | Ensure internet connection and verify external ML URL is accessible |
| "No data in dashboards" | Run at least one test of each type first |
| "Import errors in Python" | Run `pip install -r backend/requirements.txt` |

---

## 📚 Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Complete system architecture with diagrams
- **[INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)** - Detailed setup instructions
- **[backend/README.md](backend/README.md)** - Backend API documentation
- **[backend/models/README.md](backend/models/README.md)** - ML models organization
- **[backend/models/level3_tremor/README.md](backend/models/level3_tremor/README.md)** - Tremor model integration guide

---

## 🚦 Current Status

| Component | Status | Notes |
|-----------|--------|-------|
| Level 1 - Voice | ✅ **Production** | Real ML model deployed externally |
| Level 2 - Facial | ✅ **Production** | Real ML model in WebView |
| Level 3 - Tremor | ⏳ **Mock** | Awaiting your trained model |
| Caregiver Dashboard | ✅ **Integrated** | Uses real voice data for speech stability |
| Doctor Dashboard | ✅ **Integrated** | Uses real Level 1 + 2 data, mock Level 3 |
| Backend Storage | 🔄 **In-Memory** | Recommend database for production |

---

## 🔐 Security Notes

**⚠️ Development Mode**:
- No authentication on API endpoints
- Data stored in-memory (lost on restart)
- HTTP only (no HTTPS)

**For Production**:
- [ ] Add JWT authentication
- [ ] Use persistent database (PostgreSQL/Firebase)
- [ ] Enable HTTPS with SSL certificates
- [ ] Implement rate limiting
- [ ] Encrypt sensitive health data
- [ ] Ensure HIPAA compliance (if applicable)

---

## 🎯 Next Steps

1. ✅ System architecture complete with real ML integration
2. ✅ Dashboards aggregate real test data
3. ⏳ **Add your tremor ML model** to complete Level 3
4. 🔜 Replace in-memory storage with database
5. 🔜 Add user authentication
6. 🔜 Deploy backend to cloud (Render, AWS, etc.)

---

## 📞 Support

Questions about:
- **ML Model Integration**: See [backend/models/level3_tremor/README.md](backend/models/level3_tremor/README.md)
- **System Architecture**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Setup Issues**: See [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)

---

**Made with ❤️ for advancing Parkinson's disease detection and patient care**
