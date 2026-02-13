// Firebase Web Configuration for PumpShield Bharat
// Project: pump-shield (ID: pump-shield, #: 517321139558)
// Environment type: Unspecified

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "pump-shield.firebaseapp.com",
  projectId: "pump-shield",
  storageBucket: "pump-shield.appspot.com",
  messagingSenderId: "517321139558",
  appId: "1:517321139558:web:YOUR_APP_ID"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Firestore reference
const db = firebase.firestore();

// Collection references
const pumpsRef = db.collection('pumps');
const predictionsRef = db.collection('predictions');
const maintenanceLogRef = db.collection('maintenance_log');
const fleetRef = db.collection('fleet');

// Example: Add a pump
async function addPump(pumpData) {
  await pumpsRef.doc(pumpData.id).set(pumpData);
}

// Example: Get pump data
async function getPump(pumpId) {
  const doc = await pumpsRef.doc(pumpId).get();
  if (doc.exists) {
    return doc.data();
  }
  return null;
}

// Example: Update prediction
async function updatePrediction(pumpId, predictionData) {
  await predictionsRef.doc(pumpId).set(predictionData, { merge: true });
}

// Example: Add maintenance log entry
async function addMaintenanceLog(entry) {
  await maintenanceLogRef.add(entry);
}

// Export for use in other files
export { db, pumpsRef, predictionsRef, maintenanceLogRef, fleetRef };
