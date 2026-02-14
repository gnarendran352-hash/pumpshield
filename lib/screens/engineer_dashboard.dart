import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pump_shield_bharat/theme.dart';

class EngineerDashboard extends StatefulWidget {
  const EngineerDashboard({super.key});

  @override
  State<EngineerDashboard> createState() => _EngineerDashboardState();
}

class _EngineerDashboardState extends State<EngineerDashboard> {
  bool _isLive = true;
  double _currentVibration = 7.8;
  double _currentTemp = 74.2;
  double _thermalRate = 2.8;

  List<FlSpot> _fftData = [];

  @override
  void initState() {
    super.initState();
    _generateInitialFFTData();
    _startLiveUpdates();
  }

  void _generateInitialFFTData() {
    _fftData = [];
    for (double i = 0; i <= 20; i += 0.5) {
      double y = 0;
      y = 5 + (i * 2);
      if ((i - 7.2).abs() < 1.5) {
        y += 60 * (1 - (i - 7.2).abs() / 1.5);
      }
      if ((i - 14.4).abs() < 0.5) {
        y += 30 * (1 - (i - 14.4).abs() / 0.5);
      }
      _fftData.add(FlSpot(i, y));
    }
  }

  void _startLiveUpdates() {
    Future.doWhile(() async {
      if (!_isLive || !mounted) return false;
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return false;

      setState(() {
        _currentVibration = 7.5 + (DateTime.now().millisecond % 100) / 100;
        _currentTemp = 73 + (DateTime.now().second % 10) / 10;
        _thermalRate = 2.5 + (DateTime.now().millisecond % 100) / 500;

        _fftData = _fftData.map((spot) {
          double noise = (DateTime.now().millisecond % 20 - 10) / 20;
          double newY = spot.y + noise;
          if (newY < 0) newY = 0;
          if (newY > 100) newY = 100;
          return FlSpot(spot.x, newY);
        }).toList();
      });

      return true;
    });
  }

  @override
  void dispose() {
    _isLive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pump #001 - ML Analytics',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'RUL: 4.2d | MAE: 2.1d | 82% Accuracy',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isLive
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _isLive ? Colors.green : Colors.grey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLive ? Icons.sensors : Icons.sensors_off,
                    color: _isLive ? Colors.green : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isLive ? 'LIVE DATA' : 'PAUSED',
                    style: TextStyle(
                      color: _isLive ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Sensors Row - Using Column with fixed height containers
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildLiveSensorCard(
                      'Vibration',
                      '${_currentVibration.toStringAsFixed(2)}g',
                      Icons.vibration,
                      _currentVibration > 7.0 ? Colors.orange : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLiveSensorCard(
                      'Temperature',
                      '${_currentTemp.toStringAsFixed(1)}°C',
                      Icons.thermostat,
                      _currentTemp > 70 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLiveSensorCard(
                      'Thermal Rate',
                      '${_thermalRate.toStringAsFixed(1)}°C/hr',
                      Icons.speed,
                      _thermalRate > 2.5 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'VIBRATION FFT SPECTRUM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Text(
                          'PEAK: 1.8kHz',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 20,
                          verticalInterval: 2,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 4,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}kHz',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _fftData,
                            isCurved: true,
                            color: AppTheme.primaryGreen,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppTheme.primaryGreen.withOpacity(0.4),
                                  AppTheme.primaryGreen.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChartLegend(
                        'Peak Frequency',
                        '1.8 kHz',
                        Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      _buildChartLegend(
                        'Harmonic',
                        '3.6 kHz',
                        AppTheme.primaryGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'THERMAL DISK RATE TREND',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.alertRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.alertRed),
                        ),
                        child: Text(
                          'CRITICAL: ${_thermalRate.toStringAsFixed(1)}°C/hr',
                          style: const TextStyle(
                            color: AppTheme.alertRed,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'T${value.toInt()}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 9,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _generateThermalData(),
                            isCurved: true,
                            color: AppTheme.alertRed,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ML MODEL PERFORMANCE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModelCard(
                          'LSTM',
                          '82%',
                          Colors.blue,
                          'NASA CMAPSS',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildModelCard(
                          'Random Forest',
                          '78%',
                          Colors.green,
                          'Ensemble',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureImportance(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_down,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'MAE improved: 3.1d → 2.1d ✓',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.2),
                    AppTheme.primaryGreen.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.analytics, color: AppTheme.primaryGreen),
                      const SizedBox(width: 8),
                      const Text(
                        'ROOT CAUSE ANALYSIS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Bearing wear + thermal stress degradation"',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '87% Confidence Level',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons Row
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(Icons.qr_code_scanner, 'QR SCAN'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildActionButton(Icons.refresh, 'REFRESH')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildActionButton(Icons.download, 'EXPORT')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateThermalData() {
    List<FlSpot> spots = [];
    for (int i = 0; i <= 10; i++) {
      spots.add(FlSpot(i.toDouble(), 1.5 + (i * 0.15) + (i * i * 0.01)));
    }
    return spots;
  }

  Widget _buildLiveSensorCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[400])),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Icon(
                color == Colors.green ? Icons.trending_flat : Icons.trending_up,
                color: color,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModelCard(
    String model,
    String accuracy,
    Color color,
    String dataset,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      dataset,
                      style: TextStyle(fontSize: 9, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            accuracy,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            'Accuracy',
            style: TextStyle(fontSize: 10, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureImportance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feature Importance',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        _buildProgressBar('Vibration RMS', 0.65, AppTheme.primaryGreen),
        const SizedBox(height: 6),
        _buildProgressBar('Temperature', 0.22, Colors.orange),
        const SizedBox(height: 6),
        _buildProgressBar('Current', 0.13, Colors.blue),
      ],
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(fontSize: 11, color: color),
        ),
      ],
    );
  }

  Widget _buildChartLegend(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 11, color: Colors.grey[400]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 11)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.darkSurface,
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
