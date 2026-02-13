import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pump_shield_bharat/theme.dart';

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  int _currentStep = 1;
  int _selectedRating = 3;

  // Work schedule data for the week
  final List<FlSpot> _weeklyWorkload = [
    FlSpot(0, 2), // Monday
    FlSpot(1, 4), // Tuesday
    FlSpot(2, 3), // Wednesday
    FlSpot(3, 5), // Thursday
    FlSpot(4, 2), // Friday
    FlSpot(5, 1), // Saturday
    FlSpot(6, 0), // Sunday
  ];

  // Maintenance schedule data
  final List<BarChartGroupData> _maintenanceBarData = [
    BarChartGroupData(
      x: 0,
      barRods: [BarChartRodData(toY: 3, color: Colors.red)],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [BarChartRodData(toY: 2, color: Colors.orange)],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [BarChartRodData(toY: 5, color: Colors.amber)],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [BarChartRodData(toY: 1, color: Colors.green)],
    ),
  ];

  // Machine failure timeline
  final List<Map<String, dynamic>> _failureTimeline = [
    {
      'day': 'Mon',
      'date': 'Feb 6',
      'issue': 'Vibration spike',
      'pump': '#001',
      'status': 'Fixed',
    },
    {
      'day': 'Tue',
      'date': 'Feb 7',
      'issue': 'Temp warning',
      'pump': '#003',
      'status': 'Fixed',
    },
    {
      'day': 'Wed',
      'date': 'Feb 8',
      'issue': 'Current overload',
      'pump': '#002',
      'status': 'Monitoring',
    },
    {
      'day': 'Thu',
      'date': 'Feb 9',
      'issue': 'Bearing wear',
      'pump': '#001',
      'status': 'Pending',
    },
    {
      'day': 'Fri',
      'date': 'Feb 10',
      'issue': 'Oil leak',
      'pump': '#005',
      'status': 'Scheduled',
    },
  ];

  // Upcoming maintenance schedule
  final List<Map<String, dynamic>> _maintenanceSchedule = [
    {
      'pump': '#001',
      'task': 'Bearing Replacement',
      'priority': 'URGENT',
      'date': 'Feb 12',
      'time': '09:00 AM',
      'color': AppTheme.alertRed,
    },
    {
      'pump': '#003',
      'task': 'Motor Rewinding',
      'priority': 'HIGH',
      'date': 'Feb 13',
      'time': '10:30 AM',
      'color': Colors.orange,
    },
    {
      'pump': '#007',
      'task': 'Routine Inspection',
      'priority': 'NORMAL',
      'date': 'Feb 14',
      'time': '02:00 PM',
      'color': Colors.green,
    },
    {
      'pump': '#002',
      'task': 'Filter Change',
      'priority': 'NORMAL',
      'date': 'Feb 15',
      'time': '09:00 AM',
      'color': Colors.green,
    },
    {
      'pump': '#005',
      'task': 'Oil Change',
      'priority': 'MEDIUM',
      'date': 'Feb 16',
      'time': '11:00 AM',
      'color': Colors.amber,
    },
  ];

  final steps = [
    {
      'title': 'Scan QR Code',
      'date': 'Done',
      'done': true,
      'icon': Icons.qr_code_scanner,
    },
    {
      'title': 'Visual Inspection',
      'date': 'Done',
      'done': true,
      'icon': Icons.visibility,
    },
    {
      'title': 'Vibration Check',
      'date': 'In Progress',
      'done': false,
      'icon': Icons.vibration,
    },
    {
      'title': 'Replace Bearing',
      'date': 'Pending',
      'done': false,
      'icon': Icons.build,
    },
    {
      'title': 'Test Run',
      'date': 'Pending',
      'done': false,
      'icon': Icons.play_arrow,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('URGENT ALERTS', style: TextStyle(fontSize: 13)),
            SizedBox(height: 2),
            Text('Pump #001 | 4.2d RUL', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sensors, color: Colors.green, size: 12),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
            // Failure Alert Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.alertRed.withOpacity(0.3),
                    AppTheme.alertRed.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.alertRed, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.alertRed,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BEARING FAILURE PREDICTED',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.alertRed,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'FIX IN 4.2 DAYS',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.alertRed.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Sensors
            const Text(
              'MACHINE HEALTH',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Live Sensors Row
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildSensorCard(
                      'VIBRATION',
                      '7.8g',
                      Icons.vibration,
                      const Color(0xFFFFB74D),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSensorCard(
                      'TEMP',
                      '74°C',
                      Icons.thermostat,
                      AppTheme.alertRed,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSensorCard(
                      'CURRENT',
                      '13.4A',
                      Icons.bolt,
                      const Color(0xFFFFB74D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Weekly Workload Chart
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
                        'WEEKLY WORKLOAD',
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
                          '17 Tasks',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S',
                                ];
                                if (value.toInt() < days.length) {
                                  return Text(
                                    days[value.toInt()],
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 9,
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
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _weeklyWorkload,
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.orange.withOpacity(0.3),
                                  Colors.orange.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Machine Failure Timeline
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
                        'FAILURE TIMELINE',
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
                        child: const Text(
                          '5 Issues',
                          style: TextStyle(
                            color: AppTheme.alertRed,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._failureTimeline.map((item) => _buildTimelineItem(item)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Maintenance Schedule Chart
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
                        'MAINTENANCE TASKS BY PRIORITY',
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
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.green,
                              size: 10,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'This Week',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                const priorities = [
                                  'Urgent',
                                  'High',
                                  'Medium',
                                  'Normal',
                                ];
                                if (value.toInt() < priorities.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      priorities[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 8,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
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
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        barGroups: _maintenanceBarData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Upcoming Maintenance Schedule
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
                        'UPCOMING SCHEDULE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._maintenanceSchedule.map(
                    (item) => _buildScheduleItem(item),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Maintenance Schedule Stepper
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
                    'CURRENT WORK ORDER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pump #001 - Bearing Replacement',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 16),
                  ...steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _buildStepRow(step, index);
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Work Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7043),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Maintenance Report
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
                    'UPLOAD MAINTENANCE REPORT',
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
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Notes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkSurface,
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons Row
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildActionButton(Icons.qr_code_scanner, 'QR SCAN'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildActionButton(Icons.call, 'CALL')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(Icons.record_voice_over, 'VOICE'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(Icons.schedule, 'SCHEDULE'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(
    String label,
    String value,
    IconData icon,
    Color statusColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: statusColor, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  statusColor == AppTheme.alertRed
                      ? Icons.warning
                      : Icons.warning_amber,
                  color: statusColor,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> item) {
    final statusColor = item['status'] == 'Fixed'
        ? Colors.green
        : item['status'] == 'Pending'
        ? AppTheme.alertRed
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item['day'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item['pump'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(
                          fontSize: 9,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  item['issue'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Text(
            item['date'],
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: (item['color'] as Color).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item['pump'],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: item['color'] as Color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item['task'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: item['color'] as Color),
                      ),
                      child: Text(
                        item['priority'],
                        style: TextStyle(
                          fontSize: 8,
                          color: item['color'] as Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey[500],
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['date'],
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, color: Colors.grey[500], size: 12),
                    const SizedBox(width: 4),
                    Text(
                      item['time'],
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: (item['color'] as Color).withOpacity(0.2),
              side: BorderSide(color: item['color'] as Color),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            child: Text(
              'RESCHEDULE',
              style: TextStyle(fontSize: 8, color: item['color'] as Color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(Map<String, dynamic> step, int index) {
    final isCompleted = step['done'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step['icon'] as IconData,
              color: isCompleted ? Colors.white : Colors.grey,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] as String,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  '- ${step['date']} ${isCompleted ? '(Done)' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isCompleted ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isCompleted ? Icons.check_circle : Icons.pending,
            color: isCompleted ? Colors.green : Colors.orange,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 9)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.darkSurface,
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
