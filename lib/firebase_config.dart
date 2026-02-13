// Firebase Configuration for PumpShield Bharat
// Project: pump-shield (ID: pump-shield, #: 517321139558)
// Environment type: Unspecified

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConfig {
  // Firebase Project Details
  static const String projectName = 'pump shield';
  static const String projectId = 'pump-shield';
  static const String projectNumber = '517321139558';
  static const String environmentType = 'unspecified'; // Environment type

  // Firestore Collection Names
  static const String pumpsCollection = 'pumps';
  static const String predictionsCollection = 'predictions';
  static const String maintenanceLogCollection = 'maintenance_log';
  static const String alertsCollection = 'alerts';
  static const String fleetCollection = 'fleet';
  static const String usersCollection = 'users';

  // Firebase Configuration
  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDOC-EXAMPLE-API-KEY",
    authDomain: "pump-shield.firebaseapp.com",
    projectId: projectId,
    storageBucket: "pump-shield.appspot.com",
    messagingSenderId: projectNumber,
    appId: "1:${projectNumber}:web:EXAMPLE-APP-ID",
  );

  // Pump Document Structure (pump-shield Firestore)
  /*
  pumps/001: {
    "qr_code": "pump001_madurai_coop_v3",
    "location": "Madurai, Tamil Nadu",
    "install_date": "2025-01-15",
    "total_hours": 2456,
    "sensor_stream": {
      "vibration_rms": 7.8,
      "temperature": 74.2,
      "current_rms": 13.4,
      "thermal_disk_rate": 2.8    // Innovation
    },
    "prediction": {
      "rul_days": 4.2,
      "mae": 2.1,
      "confidence": 0.87
    },
    "maintenance_log": [
      {"date": "2026-02-01", "work": "bearing", "tech": "Ravi", "cost": 2800}
    ]
  }
  */

  static Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(options: firebaseOptions);
  }

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Document Reference
  static DocumentReference<Map<String, dynamic>> pumpDocRef(String pumpId) {
    return firestore.collection(pumpsCollection).doc(pumpId);
  }

  static CollectionReference<Map<String, dynamic>> get pumpsCollectionRef {
    return firestore.collection(pumpsCollection);
  }

  static CollectionReference<Map<String, dynamic>> get fleetCollectionRef {
    return firestore.collection(fleetCollection);
  }

  // Sample pump data for demo
  static Map<String, dynamic> samplePumpData(String pumpId) {
    return {
      'qr_code': 'pump${pumpId}_madurai_coop_v3',
      'location': 'Madurai, Tamil Nadu',
      'install_date': '2025-01-15',
      'total_hours': 2456,
      'sensor_stream': {
        'vibration_rms': 7.8,
        'temperature': 74.2,
        'current_rms': 13.4,
        'thermal_disk_rate': 2.8, // Innovation
      },
      'prediction': {'rul_days': 4.2, 'mae': 2.1, 'confidence': 0.87},
      'maintenance_log': [
        {'date': '2026-02-01', 'work': 'bearing', 'tech': 'Ravi', 'cost': 2800},
      ],
    };
  }

  // Fleet data for Manager Dashboard
  static List<Map<String, dynamic>> fleetData() {
    return [
      {
        'id': '001',
        'location': 'Madurai',
        'status': 'critical',
        'rul_days': 4.2,
        'saved': 18000,
        'color': '#D32F2F',
      },
      {
        'id': '002',
        'location': 'Theni',
        'status': 'warning',
        'rul_days': 7.1,
        'saved': 22000,
        'color': '#FF8F00',
      },
      {
        'id': '003',
        'location': 'Dindigul',
        'status': 'critical',
        'rul_days': 2.1,
        'saved': 15000,
        'color': '#D32F2F',
      },
      {
        'id': '004',
        'location': 'Virudhunagar',
        'status': 'ok',
        'rul_days': 15.3,
        'saved': 28000,
        'color': '#2E7D32',
      },
      {
        'id': '005',
        'location': 'Sivaganga',
        'status': 'ok',
        'rul_days': 12.8,
        'saved': 21000,
        'color': '#2E7D32',
      },
    ];
  }
}
