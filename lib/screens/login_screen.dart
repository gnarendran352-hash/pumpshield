import 'package:flutter/material.dart';
import 'package:pump_shield_bharat/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Strict role order: Technician → Engineer → Manager
  final List<String> roles = ['TECHNICIAN', 'ENGINEER', 'MANAGER'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.darkBg, AppTheme.darkSurface],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'PumpShield Bharat',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'AI Predictive Maintenance',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select Access Level',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                // Role selector with hierarchy order
                Row(
                  children: roles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final role = entry.value;
                    final isSelected = index == selectedIndex;
                    final roleColor = _getRoleColor(index);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: index < roles.length - 1 ? 6 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? roleColor
                                : AppTheme.darkSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: roleColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _getRoleIcon(index),
                                color: isSelected ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                role[0] + role.substring(1).toLowerCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 32,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Role description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getRoleColor(selectedIndex).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRoleColor(selectedIndex).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRoleIcon(selectedIndex),
                        color: _getRoleColor(selectedIndex),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getRoleTitle(selectedIndex),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getRoleColor(selectedIndex),
                              ),
                            ),
                            Text(
                              _getRoleDescription(selectedIndex),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        '+91',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    hintText: 'Enter phone number',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate based on role selection
                      _navigateToDashboard(selectedIndex);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getRoleColor(selectedIndex),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Login as ${roles[selectedIndex].substring(0, 1)}${roles[selectedIndex].substring(1).toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Icon(
                    Icons.settings,
                    size: 60,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getRoleIcon(int index) {
    switch (index) {
      case 0:
        return Icons.build; // Technician
      case 1:
        return Icons.analytics; // Engineer
      case 2:
        return Icons.dashboard; // Manager
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFF7043); // Orange for Technician
      case 1:
        return AppTheme.primaryGreen; // Green for Engineer
      case 2:
        return const Color(0xFF5C6BC0); // Indigo for Manager
      default:
        return AppTheme.primaryGreen;
    }
  }

  String _getRoleTitle(int index) {
    switch (index) {
      case 0:
        return 'TECHNICIAN';
      case 1:
        return 'ENGINEER';
      case 2:
        return 'MANAGER';
      default:
        return '';
    }
  }

  String _getRoleDescription(int index) {
    switch (index) {
      case 0:
        return 'Field maintenance & repairs';
      case 1:
        return 'Technical analysis & diagnostics';
      case 2:
        return 'Fleet oversight & decisions';
      default:
        return '';
    }
  }

  void _navigateToDashboard(int index) {
    String route;
    switch (index) {
      case 0:
        route = '/technician_dashboard';
        break;
      case 1:
        route = '/engineer_dashboard';
        break;
      case 2:
        route = '/manager_dashboard';
        break;
      default:
        route = '/technician_dashboard';
    }
    Navigator.pushReplacementNamed(context, route);
  }
}
