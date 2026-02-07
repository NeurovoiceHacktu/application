/*******************************************************
 * MediaPipe FaceMesh – Facial Parkinson’s Screening
 * Plain JavaScript Reference Implementation
 * -----------------------------------------------------
 * Metrics:
 *  - Blink rate (blinks/min)
 *  - Facial rigidity (motion)
 *  - Facial asymmetry
 *  - Deterministic risk score
 *******************************************************/

let video = document.getElementById("video");
let canvas = document.getElementById("canvas");
let ctx = canvas.getContext("2d");

let faceMesh;
let camera;

// ===================== CONFIG =====================
const RECORDING_DURATION = 30; // seconds

// Facial state tracking
let recording = false;
let startTime = 0;

let blinkCount = 0;
let leftEyeOpen = true;
let rightEyeOpen = true;

let motionValues = [];
let asymmetryValues = [];
let previousLandmarks = null;

// ===================== INIT CAMERA =====================
async function initCamera() {
  const stream = await navigator.mediaDevices.getUserMedia({
    video: { width: 640, height: 480, facingMode: "user" },
    audio: false
  });

  video.srcObject = stream;
  await video.play();

  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
}

// ===================== INIT FACEMESH =====================
async function initFaceMesh() {
  faceMesh = new FaceMesh({
    locateFile: (file) =>
      `https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh/${file}`
  });

  faceMesh.setOptions({
    maxNumFaces: 1,
    refineLandmarks: true,
    minDetectionConfidence: 0.5,
    minTrackingConfidence: 0.5
  });

  faceMesh.onResults(onResults);

  camera = new Camera(video, {
    onFrame: async () => {
      await faceMesh.send({ image: video });
    },
    width: 640,
    height: 480
  });

  camera.start();
}

// ===================== START RECORDING =====================
function startRecording() {
  blinkCount = 0;
  motionValues = [];
  asymmetryValues = [];
  previousLandmarks = null;

  leftEyeOpen = true;
  rightEyeOpen = true;

  recording = true;
  startTime = performance.now();

  console.log("▶️ Recording started");
}

// ===================== STOP RECORDING =====================
function stopRecording() {
  recording = false;

  const duration = (performance.now() - startTime) / 1000;

  const blinkRate = (blinkCount / duration) * 60;
  const avgMotion =
    motionValues.length > 0
      ? motionValues.reduce((a, b) => a + b, 0) / motionValues.length
      : 1.5;

  const avgAsymmetry =
    asymmetryValues.length > 0
      ? asymmetryValues.reduce((a, b) => a + b, 0) / asymmetryValues.length
      : 0.02;

  const risk = calculateRisk(blinkRate, avgMotion, avgAsymmetry);

  console.log("✅ FINAL RESULT", {
    blinkRate,
    avgMotion,
    avgAsymmetry,
    risk
  });

  // SEND RESULT (WebView / Native / Debug)
  if (window.FlutterBridge) {
    window.FlutterBridge.postMessage(
      JSON.stringify({ blinkRate, avgMotion, avgAsymmetry, risk })
    );
  }
}

// ===================== FACEMESH RESULTS =====================
function onResults(results) {
  if (!results.multiFaceLandmarks || results.multiFaceLandmarks.length === 0)
    return;

  const landmarks = results.multiFaceLandmarks[0];

  drawFace(landmarks);

  if (!recording) return;

  // ⏱ Stop after duration
  if ((performance.now() - startTime) / 1000 >= RECORDING_DURATION) {
    stopRecording();
    return;
  }

  // ========== 1️⃣ BLINK DETECTION ==========
  const leftEyeDist = Math.abs(landmarks[159].y - landmarks[145].y);
  const rightEyeDist = Math.abs(landmarks[386].y - landmarks[374].y);
  const faceHeight = Math.abs(landmarks[10].y - landmarks[152].y);
  const blinkThreshold = faceHeight * 0.015;

  const leftClosed = leftEyeDist < blinkThreshold;
  const rightClosed = rightEyeDist < blinkThreshold;

  if (leftEyeOpen && rightEyeOpen && leftClosed && rightClosed) {
    blinkCount++;
    leftEyeOpen = false;
    rightEyeOpen = false;
  }

  if (!leftClosed && !rightClosed) {
    leftEyeOpen = true;
    rightEyeOpen = true;
  }

  // ========== 2️⃣ FACIAL MOTION ==========
  if (previousLandmarks) {
    let totalMotion = 0;
    const indices = [61, 291, 13, 14, 105, 334, 93, 323];

    indices.forEach((i) => {
      const dx = landmarks[i].x - previousLandmarks[i].x;
      const dy = landmarks[i].y - previousLandmarks[i].y;
      totalMotion += Math.sqrt(dx * dx + dy * dy);
    });

    motionValues.push(totalMotion / indices.length);
  }

  previousLandmarks = landmarks.map((l) => ({
    x: l.x,
    y: l.y,
    z: l.z
  }));

  // ========== 3️⃣ ASYMMETRY ==========
  const mouth = Math.abs(landmarks[61].y - landmarks[291].y);
  const brow = Math.abs(landmarks[105].y - landmarks[334].y);
  const cheek = Math.abs(landmarks[206].y - landmarks[426].y);

  asymmetryValues.push((mouth + brow + cheek) / 3);
}

// ===================== DRAW FACE =====================
function drawFace(landmarks) {
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  ctx.strokeStyle = "#4DA3FF";
  ctx.lineWidth = 1;

  FACEMESH_TESSELATION.forEach(([a, b]) => {
    const p1 = landmarks[a];
    const p2 = landmarks[b];
    ctx.beginPath();
    ctx.moveTo(p1.x * canvas.width, p1.y * canvas.height);
    ctx.lineTo(p2.x * canvas.width, p2.y * canvas.height);
    ctx.stroke();
  });
}

// ===================== RISK CALCULATION =====================
function calculateRisk(blinkRate, motion, asymmetry) {
  let score = 0;

  // Blink (40%)
  if (blinkRate < 4) score += 40;
  else if (blinkRate < 7) score += 30;
  else if (blinkRate < 10) score += 15;

  // Motion (35%)
  const motionScore = motion * 1000;
  if (motionScore < 0.6) score += 35;
  else if (motionScore < 1.0) score += 20;
  else if (motionScore < 1.5) score += 10;

  // Asymmetry (25%)
  if (asymmetry > 0.07) score += 25;
  else if (asymmetry > 0.05) score += 15;
  else if (asymmetry > 0.035) score += 5;

  return Math.min(100, Math.round(score));
}

// ===================== BOOT =====================
(async function boot() {
  await initCamera();
  await initFaceMesh();
  startRecording();
})();