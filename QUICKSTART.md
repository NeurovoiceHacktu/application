# 🚀 Quick Start - Get Running in 5 Minutes!

## 🎯 Goal
Get the Parkinson's Detection App running with **real ML models** for Level 1 & 2, and mock for Level 3.

---

## ⚡ 3-Step Setup

### Step 1: Find Your Computer's IP Address (1 minute)

**Windows:**
```bash
ipconfig
```
Look for "IPv4 Address" under your active network (e.g., `192.168.1.100`)

**Mac/Linux:**
```bash
ifconfig
```

✍️ **Write it down**: _________________

---

### Step 2: Update Flutter Code - 3 Files (2 minutes)

**File 1**: `lib/features/voice_check/voice_check_viewmodel.dart`  
Find line ~56 and change:
```dart
static const String localBackendUrl =
    'http://YOUR_IP_HERE:5000/api/voice/result';  // <-- CHANGE THIS
```

**File 2**: `lib/features/facial_check/facial_check_view.dart`  
Find line ~29 and change:
```dart
static const String localBackendUrl =
    'http://YOUR_IP_HERE:5000/api/facial/result';  // <-- CHANGE THIS
```

**File 3**: `lib/features/tremor_check/tremor_check_viewmodel.dart`  
Find line ~40 and change:
```dart
static const String baseUrl = 'http://YOUR_IP_HERE:5000';  // <-- CHANGE THIS
```

---

### Step 3: Start Everything (2 minutes)

**Terminal 1 - Backend:**
```bash
cd backend
pip install -r requirements.txt
python app.py
```

Wait for: `🚀 Starting Parkinson's Detection API Server...` ✅

**Terminal 2 - Flutter:**
```bash
flutter pub get
flutter run
```

Select your device when prompted ✅

---

## ✅ Test It Works

### Test 1: Run Voice Test (REAL ML) ✨
1. Open app → Home screen
2. Tap **"Voice Assessment"** card
3. Tap "Start Recording" button
4. Wait 12 seconds
5. See result screen
6. **Check backend terminal**: Should see `✅ Stored voice test result`

### Test 2: Run Facial Test (REAL ML) ✨
1. Home → Tap **"Facial Assessment"** card
2. Allow camera access
3. Follow on-screen instructions
4. Complete assessment
5. **Check backend terminal**: Should see `✅ Stored facial test result`

### Test 3: Run Tremor Test (MOCK ML) 🔄
1. Home → Tap **"Tremor Test (Level 3)"** card
2. Read instructions
3. Tap "Start Test"
4. Hold phone steady for 10 seconds
5. See mock results

### Test 4: View Dashboards (REAL DATA) ✨
1. Home → Tap **"Caregiver Dashboard"**
   - See **REAL** speech stability data from voice tests
   - Daily scores calculated from actual ML predictions
   
2. Home → Tap **"Doctor Dashboard"**
   - See **REAL** risk severity combining all levels
   - Disease progression graph with real trends
   - AI summary generated from actual test data

---

## 🐛 Troubleshooting

### "Connection refused" or "Backend not reachable"
**Problem**: Flutter can't reach Python backend

**Solutions**:
1. ✅ Is backend running? Check Terminal 1 for server message
2. ✅ Is IP address correct? Double-check what you entered
3. ✅ Firewall blocking? Allow Python through Windows Firewall
4. ✅ Same network? Phone and computer must be on same WiFi

**Quick Test**: Open phone browser and visit `http://YOUR_IP:5000/health`

### "WebView is blank" (Facial test)
**Problem**: Can't load external ML model

**Solutions**:
1. Check internet connection
2. Visit in browser: https://level2-mediapipe-website.onrender.com
3. External service may be temporarily down (it's hosted externally)

### "No data in dashboards"
**Solutions**:
1. Run at least ONE test of each type first
2. Check backend received results: Look for `✅ Stored...` in terminal
3. Test backend: `curl http://YOUR_IP:5000/api/doctor/dashboard`

### Python import errors
```bash
cd backend
pip install --upgrade pip
pip install -r requirements.txt
```

### Flutter errors
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 What You Have Now

| Feature | Status | Type |
|---------|--------|------|
| Voice Test (Level 1) | ✅ Working | **REAL ML** (External API) |
| Facial Test (Level 2) | ✅ Working | **REAL ML** (WebView) |
| Tremor Test (Level 3) | ✅ Working | **MOCK ML** (Backend) |
| Caregiver Dashboard | ✅ Working | Uses **REAL voice data** |
| Doctor Dashboard | ✅ Working | Uses **REAL Level 1+2 data** |
| Backend Storage | ✅ Working | In-memory (temporary) |

---

## 🎯 Next Steps

### 1. Add Your Tremor Model (10 minutes)
Currently Level 3 uses mock predictions. To use your **real trained model**:

```python
import joblib

# Save your model
joblib.dump(your_model, 'backend/models/level3_tremor/tremor_model.pkl')
joblib.dump(your_scaler, 'backend/models/level3_tremor/feature_scaler.pkl')
```

Then update `backend/inference.py` to load it.

📖 **Full guide**: [backend/models/level3_tremor/README.md](backend/models/level3_tremor/README.md)

### 2. Explore Full System
- Read [ARCHITECTURE.md](ARCHITECTURE.md) for complete data flow
- See [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) for detailed setup
- Check [README.md](README.md) for project overview

### 3. Prepare for Production
- Add persistent database (currently in-memory)
- Implement user authentication
- Deploy backend to cloud (Render, AWS, etc.)
- Enable HTTPS/SSL

---

## 🎉 Success Checklist

- [ ] Backend shows: `🚀 Starting Parkinson's Detection API Server...`
- [ ] Flutter app opens on device/emulator
- [ ] Voice test completes and shows result
- [ ] Backend logs: `✅ Stored voice test result`
- [ ] Facial test loads camera and completes
- [ ] Backend logs: `✅ Stored facial test result`
- [ ] Tremor test runs and shows result
- [ ] Caregiver dashboard displays speech data
- [ ] Doctor dashboard shows risk analysis

**All checked?** 🎊 You're ready to go!

---

## 📱 What You'll See

### Home Screen Cards
- 🎤 **Voice Assessment** (Level 1) - REAL ML
- 👤 **Facial Assessment** (Level 2) - REAL ML
- 📱 **Tremor Test** (Level 3) - Mock ML
- 💚 **Caregiver Dashboard** - Patient monitoring
- 👨‍⚕️ **Doctor Dashboard** - Clinical analysis

### Caregiver Dashboard Features
- 😊 Emotional Health Tracking
- 💊 Medication Reminders & Compliance
- 🗣️ Speech Stability (from **REAL voice tests**)
- 🚨 Emergency Alerts Management

### Doctor Dashboard Features
- 📊 Risk Severity Index (from **REAL multi-level data**)
- 🧪 All Levels Assessment Bars
- 🤖 AI-Generated Clinical Summary
- 📈 6-Month Disease Progression Graph

---

**Need help?** See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed documentation.

**Ready for ML model?** See [backend/models/level3_tremor/README.md](backend/models/level3_tremor/README.md)
