import 'package:flutter/material.dart';
import 'package:pump_shield_bharat/theme.dart';
import 'machine_history_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _hasScanned = false;
  String _scannedPumpId = '';

  void _onQRCodeScanned(String code) {
    if (!_hasScanned) {
      setState(() {
        _hasScanned = true;
        _scannedPumpId = code;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MachineHistoryScreen(pumpId: code),
          ),
        ).then((_) {
          // Reset scanner when returning
          setState(() {
            _hasScanned = false;
            _scannedPumpId = '';
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview placeholder
          Container(
            color: Colors.black,
            child: Center(
              child: Icon(
                Icons.qr_code_scanner,
                size: 200,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // Scan frame
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryGreen, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _hasScanned
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'SUCCESS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pump #$_scannedPumpId',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightGreen,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
          // Top text
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white.withOpacity(0.5),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  _hasScanned ? 'Accessing Machine Data...' : 'Scan Pump QR',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _hasScanned
                      ? 'Complete history loading...'
                      : 'for complete history',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Bottom buttons
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomButton(Icons.flash_on, 'Flash'),
                _buildBottomButton(Icons.image, 'Gallery'),
                _buildBottomButton(Icons.keyboard, 'Manual ID'),
              ],
            ),
          ),
          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.darkSurface.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}
