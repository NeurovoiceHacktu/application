# System Architecture - Parkinson's Detection App

## Overview

This Flutter application integrates **three levels** of Parkinson's disease detection using machine learning models. Levels 1 and 2 use **real deployed ML models**, while Level 3 uses mock predictions until you provide your trained tremor detection model.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FLUTTER MOBILE APP                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │
│  │   Level 1    │  │   Level 2    │  │   Level 3    │            │
│  │ Voice Test   │  │ Facial Test  │  │ Tremor Test  │            │
│  │   (REAL ML)  │  │   (REAL ML)  │  │   (MOCK ML)  │            │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘            │
│         │                  │                  │                     │
└─────────┼──────────────────┼──────────────────┼─────────────────────┘
          │                  │                  │
          ↓                  ↓                  ↓
   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
   │ External ML  │   │ External ML  │   │ Local Python │
   │     API      │   │   WebView    │   │   Backend    │
   │  (Render)    │   │  (Render)    │   │ (Flask)      │
   └──────┬───────┘   └──────┬───────┘   └──────┬───────┘
          │                  │                  │
          └──────────┬───────┴──────────────────┘
                     ↓
          ┌─────────────────────┐
          │   Local Backend     │
          │  (Flask - Port 5000)│
          │  - Stores results   │
          │  - Aggregates data  │
          │  - Serves dashboards│
          └─────────┬───────────┘
                    │
         ┌──────────┴───────────┐
         ↓                      ↓
   ┌────────────┐        ┌────────────┐
   │ Caregiver  │        │  Doctor    │
   │ Dashboard  │        │ Dashboard  │
   └────────────┘        └────────────┘
```

---

## Data Flow

### Level 1 - Voice Analysis (REAL ML)

**Status**: ✅ Deployed and Active

```
1. User clicks "Voice Test" → Flutter app
2. Records 12 seconds of voice → AudioRecorderService
3. Collects clinical features (age, test history, hypertension, UPDRS)
4. Uploads WAV file + features → https://neurovoice-level1-ml.onrender.com/predict
5. External ML model analyzes audio → Returns risk_score (0-1) and risk_level
6. Flutter sends result → https://neurovoice-db.onrender.com/api/voice-results (original backend)
7. Flutter sends result → http://YOUR_IP:5000/api/voice/result (local backend)
8. Local backend stores result → In-memory for dashboard aggregation
9. Dashboards fetch data → Real voice test history used in analysis
```

**Files Involved**:
- [lib/features/voice_check/voice_check_viewmodel.dart](lib/features/voice_check/voice_check_viewmodel.dart) - Main logic
- [lib/core/network/voice_ml_api.dart](lib/core/network/voice_ml_api.dart) - API client
- [lib/core/utils/audio_helper.dart](lib/core/utils/audio_helper.dart) - Audio recording

**External Dependencies**:
- Voice ML API: `https://neurovoice-level1-ml.onrender.com`
- Original Backend: `https://neurovoice-db.onrender.com`

---

### Level 2 - Facial Movement (REAL ML)

**Status**: ✅ Deployed and Active

```
1. User clicks "Facial Test" → Flutter app
2. Opens WebView → Loads https://level2-mediapipe-website.onrender.com
3. React app requests camera access → User grants permission
4. MediaPipe analyzes face in real-time (browser-based ML)
5. Detects: facial landmarks, blink rate, motion, asymmetry
6. JavaScript sends results → Flutter via JavaScript channel 'assessmentResult'
7. Flutter receives FacialResult object
8. Flutter sends result → https://neurovoice-db.onrender.com/api/face-results (original backend)
9. Flutter sends result → http://YOUR_IP:5000/api/facial/result (local backend)
10. Local backend stores result → In-memory for dashboard aggregation
11. Dashboards fetch data → Real facial test history used in analysis
```

**Files Involved**:
- [lib/features/facial_check/facial_check_view.dart](lib/features/facial_check/facial_check_view.dart) - WebView integration
- [lib/core/models/face_result.dart](lib/core/models/face_result.dart) - Data model

**External Dependencies**:
- Facial ML WebView: `https://level2-mediapipe-website.onrender.com`
- Original Backend: `https://neurovoice-db.onrender.com`

---

### Level 3 - Tremor Detection (MOCK ML)

**Status**: ⏳ Awaiting Real Model

```
1. User clicks "Tremor Test" → Flutter app
2. Shows instructions to hold phone steady
3. Collects accelerometer + gyroscope data → 10 seconds
4. Sends sensor data → http://YOUR_IP:5000/api/tremor/analyze
5. Local backend runs inference:
   - CURRENTLY: Mock predictions (random but realistic)
   - FUTURE: Real ML model from backend/models/level3_tremor/
6. Returns: risk_level, confidence, tremor_frequency, severity_score
7. Flutter displays results
8. Local backend stores result → Automatically saved for dashboards
9. Dashboards fetch data → Tremor test history included in analysis
```

**Files Involved**:
- [lib/features/tremor_check/tremor_check_viewmodel.dart](lib/features/tremor_check/tremor_check_viewmodel.dart) - Main logic
- [lib/features/tremor_check/tremor_check_view.dart](lib/features/tremor_check/tremor_check_view.dart) - UI
- [lib/features/tremor_check/tremor_processing_view.dart](lib/features/tremor_check/tremor_processing_view.dart) - Processing screen
- [lib/features/tremor_check/tremor_results_view.dart](lib/features/tremor_check/tremor_results_view.dart) - Results display
- [backend/app.py](backend/app.py) - API endpoint
- [backend/inference.py](backend/inference.py) - ML inference (currently mock)

**To Integrate Real Model**:
1. Place trained model in `backend/models/level3_tremor/tremor_model.pkl`
2. Update `backend/inference.py` with real model loading
3. Restart backend

---

## Dashboard Data Integration

### Caregiver Dashboard

**Endpoint**: `GET http://YOUR_IP:5000/api/caregiver/dashboard`

**Data Sources**:
- ✅ **Speech Stability**: Calculated from **REAL Level 1 voice tests**
  - Uses actual risk scores from voice ML model
  - Shows 7-day trend of speech quality
  - Determines if improving/stable/declining
  
- ⏳ **Emotional Health**: Mock data (future: integrate mood tracking)
- ⏳ **Medication**: Mock reminders (future: integrate medication system)
- ⏳ **Emergency Alerts**: Mock alerts (future: integrate fall detection)

**Files**:
- [lib/features/caregiver/caregiver_dashboard_view.dart](lib/features/caregiver/caregiver_dashboard_view.dart)
- [lib/features/caregiver/caregiver_viewmodel.dart](lib/features/caregiver/caregiver_viewmodel.dart)
- [backend/app.py](backend/app.py) - `_calculate_speech_stability_from_real_data()`

---

### Doctor Dashboard

**Endpoint**: `GET http://YOUR_IP:5000/api/doctor/dashboard`

**Data Sources**:
- ✅ **Risk Severity Index**: Calculated from **REAL multi-level data**
  - Voice score from Level 1 ML predictions
  - Facial score from Level 2 ML predictions
  - Tremor score from Level 3 (currently mock)
  - Overall severity = average of all three
  
- ✅ **Disease Progression Graph**: Shows **REAL 6-month trends**
  - Voice scores over time (from actual tests)
  - Facial/motor scores over time (from actual tests)
  - Tremor scores over time (mock until real model provided)
  
- ✅ **AI Clinical Summary**: Generated from **REAL test results**
  - Analyzes actual voice risk levels
  - Includes facial asymmetry findings
  - Notes tremor patterns
  - Compliance tracking based on test frequency
  
- ✅ **Level Assessments**: Individual bars for each test type
  - Level 1 (Voice): Real ML prediction scores
  - Level 2 (Facial): Real ML prediction scores
  - Level 3 (Tremor): Mock scores (until real model)

**Files**:
- [lib/features/doctor/doctor_dashboard_view.dart](lib/features/doctor/doctor_dashboard_view.dart)
- [lib/features/doctor/doctor_viewmodel.dart](lib/features/doctor/doctor_viewmodel.dart)
- [backend/app.py](backend/app.py) - Multiple calculation functions

---

## Backend Architecture

### Local Flask Backend (`backend/app.py`)

**Port**: 5000  
**Host**: 0.0.0.0 (accessible from mobile devices on same network)

**Endpoints**:

```python
# Test Analysis
POST /api/tremor/analyze       # Tremor detection (Level 3)

# Result Storage
POST /api/voice/result          # Store voice test results from Level 1
POST /api/facial/result         # Store facial test results from Level 2

# Dashboard Data
GET  /api/caregiver/dashboard   # Caregiver view (uses REAL voice data)
GET  /api/doctor/dashboard      # Doctor view (uses REAL multi-level data)
GET  /api/patient/history       # Patient test history

# Health Check
GET  /health                    # Backend status + test counts
```

**Data Storage**:
- **In-Memory**: Currently using Python dictionaries
- **Structure**:
  ```python
  test_results = {
      'voice': [    # Level 1 results from real ML
          {'timestamp': '...', 'risk_level': 'High', 'confidence': 0.85},
          ...
      ],
      'facial': [   # Level 2 results from real ML
          {'timestamp': '...', 'percentage': 72, 'level': 'Medium'},
          ...
      ],
      'tremor': [   # Level 3 results (currently mock)
          {'timestamp': '...', 'risk_level': 'Low', 'severity_score': 45},
          ...
      ]
  }
  ```

**Future Enhancement**: Replace with persistent database (SQLite, PostgreSQL, or Firebase)

---

## ML Models Organization

### Directory Structure

```
backend/models/
├── level1_voice/
│   ├── notes.txt              # Documentation (model is external)
│   └── (no model files - external API)
│
├── level2_facial/
│   ├── notes.txt              # Documentation (model is external)
│   └── (no model files - external WebView)
│
└── level3_tremor/
    ├── README.md              # Integration instructions
    ├── tremor_model.pkl       # <-- PLACE YOUR MODEL HERE
    └── feature_scaler.pkl     # <-- PLACE YOUR SCALER HERE
```

### Model Status

| Level | Type | Status | Location | Format |
|-------|------|--------|----------|--------|
| 1 | Voice | ✅ Deployed | External API | Unknown (API) |
| 2 | Facial | ✅ Deployed | External WebView | MediaPipe + Custom |
| 3 | Tremor | ⏳ Mock | Local Backend | .pkl (awaiting) |

---

## Configuration

### Update IP Addresses

You need to update **YOUR_IP** in three places:

1. **Voice Check**: [lib/features/voice_check/voice_check_viewmodel.dart](lib/features/voice_check/voice_check_viewmodel.dart#L56)
   ```dart
   static const String localBackendUrl =
       'http://192.168.1.100:5000/api/voice/result'; // <-- UPDATE
   ```

2. **Facial Check**: [lib/features/facial_check/facial_check_view.dart](lib/features/facial_check/facial_check_view.dart#L29)
   ```dart
   static const String localBackendUrl =
       'http://192.168.1.100:5000/api/facial/result'; // <-- UPDATE
   ```

3. **Tremor + Dashboards**: [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart) (if exists) or in each dashboard viewmodel

**Find Your IP**:
```bash
# Windows
ipconfig

# Look for "IPv4 Address" under your active network adapter
# Example: 192.168.1.100
```

---

## Running the System

### 1. Start Backend
```bash
cd backend
python app.py
```

Expected output:
```
🚀 Starting Parkinson's Detection API Server...
📍 Server running on http://localhost:5000
🔗 Endpoints:
   - POST /api/tremor/analyze
   - POST /api/voice/result
   - POST /api/facial/result
   - GET  /api/caregiver/dashboard
   - GET  /api/doctor/dashboard
   - GET  /api/patient/history

💡 Connect to: http://YOUR_COMPUTER_IP:5000 for real devices
```

### 2. Update Flutter Config
Update IP addresses in Flutter code (see Configuration section above)

### 3. Run Flutter App
```bash
flutter run
```

### 4. Test Data Flow

**Test Voice (Level 1)**:
1. Open app → Home screen
2. Click "Voice Assessment" card
3. Complete voice test
4. Check backend console: `✅ Stored voice test result`
5. Open Caregiver Dashboard → See real speech stability data

**Test Facial (Level 2)**:
1. Open app → Home screen
2. Click "Facial Assessment" card
3. Allow camera access
4. Complete facial test
5. Check backend console: `✅ Stored facial test result`
6. Open Doctor Dashboard → See real facial scores

**Test Tremor (Level 3)**:
1. Open app → Home screen
2. Click "Tremor Test" card (Level 3)
3. Hold phone steady for 10 seconds
4. Check backend console: Mock prediction logged
5. Open Doctor Dashboard → See mock tremor scores

**Test Dashboards**:
1. After running tests, go to Home screen
2. Click "Caregiver Dashboard"
   - Speech Stability shows REAL voice data
3. Click "Doctor Dashboard"
   - Risk Severity combines all three levels
   - Progression graph shows trends
   - AI Summary generated from real data

---

## Development Workflow

### Adding Real Tremor Model

1. **Train your model offline**:
   ```python
   from sklearn.ensemble import RandomForestClassifier
   import joblib
   
   # Train model
   model = RandomForestClassifier(...)
   model.fit(X_train, y_train)
   
   # Save
   joblib.dump(model, 'backend/models/level3_tremor/tremor_model.pkl')
   joblib.dump(scaler, 'backend/models/level3_tremor/feature_scaler.pkl')
   ```

2. **Update backend/inference.py**:
   - Replace mock implementation with real model loading
   - See [backend/models/level3_tremor/README.md](backend/models/level3_tremor/README.md) for details

3. **Restart backend**:
   ```bash
   python backend/app.py
   ```

4. **Test**:
   - Run tremor test in app
   - Verify real predictions appear in dashboards

---

## Debugging

### Backend Not Reachable
```
⚠️ Local backend not reachable (dashboards may show old data)
```

**Solutions**:
1. Check backend is running: `http://YOUR_IP:5000/health`
2. Verify firewall allows port 5000
3. Confirm IP address is correct in Flutter code
4. Ensure phone and computer on same WiFi network

### Dashboards Show No Data
- Run at least one test of each type first
- Check backend console for "✅ Stored..." messages
- Verify endpoints return data: `curl http://YOUR_IP:5000/api/doctor/dashboard`

### External ML APIs Not Working
- Level 1 and 2 require internet connection
- These are deployed externally and not part of this backend
- Check URLs are correct and services are online

---

## Security Considerations

### Current Implementation (Development)
- ⚠️ No authentication on endpoints
- ⚠️ Data stored in-memory (lost on restart)
- ⚠️ HTTP only (no HTTPS)

### Production Recommendations
1. **Add authentication**: JWT tokens or API keys
2. **Use persistent storage**: PostgreSQL or Firebase
3. **Enable HTTPS**: SSL certificates
4. **Rate limiting**: Prevent abuse
5. **Data encryption**: Encrypt sensitive health data
6. **HIPAA compliance**: If handling real patient data

---

## Testing

### Unit Tests
```bash
# Flutter tests
flutter test

# Backend tests (create test_app.py)
pytest backend/
```

### Manual Testing Checklist

- [ ] Voice test completes and shows results
- [ ] Facial test loads WebView and returns data
- [ ] Tremor test collects sensor data and analyzes
- [ ] Backend receives all three test types
- [ ] Caregiver dashboard shows real speech data
- [ ] Doctor dashboard aggregates all levels
- [ ] Navigation between screens works
- [ ] Backend survives restart

---

## Future Enhancements

### Short Term
- [ ] Replace mock tremor model with real trained model
- [ ] Add persistent database (SQLite or PostgreSQL)
- [ ] Implement user authentication
- [ ] Add medication tracking system
- [ ] Integrate emotional health monitoring

### Long Term
- [ ] Deploy backend to cloud (Render, AWS, GCP)
- [ ] Add real-time notifications for caregivers
- [ ] Implement historical data analysis
- [ ] Add export reports (PDF generation)
- [ ] Multi-patient support for doctors
- [ ] Integration with wearable devices
- [ ] Telemedicine video consultation

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Backend won't start | Check Python 3.8+, install dependencies: `pip install -r requirements.txt` |
| Flutter build fails | Run `flutter pub get` and `flutter clean` |
| WebView blank/crashes | Check internet connection, verify WebView URL is accessible |
| Sensor data not collected | Grant sensor permissions in app settings |
| Dashboard always shows same data | Backend using fallback mock data - run tests first |

---

## Architecture Benefits

✅ **Modular Design**: Each level is independent  
✅ **Real ML Integration**: Levels 1 & 2 use production models  
✅ **Extensible**: Easy to add Level 4, 5, etc.  
✅ **Dashboard Aggregation**: Unified view of all test data  
✅ **Graceful Degradation**: Works even if some services unavailable  
✅ **Development-Friendly**: Mock data for Level 3 allows full UI development  

---

*Last Updated: February 8, 2026*
